#!/usr/bin/env python3
"""
archive_chats.py — Lokale KI-Chatverläufe ins Obsidian-Archiv konvertieren.

Liest lokale Transcripts von Claude Code (~/.claude/projects) und Codex
(~/.codex/sessions), erzeugt pro Session eine lesbare Markdown-Datei
(Tool-Aufrufe/System-Reminder gefiltert) und legt die Original-.jsonl daneben.
Schreibt eine INDEX.md als Einstiegspunkt. Idempotent: schon archivierte
Sessions werden übersprungen.

Ziel:  <Vault>/80_ARCHIV/Chat-Archiv/{Claude-Code,Codex}/<projekt>/
Cloud: ChatGPT/Claude-Web/Manus/WhatsApp bekommen nur _ANLEITUNG.md (Gerüst).

Aufruf:
    python3 archive_chats.py                 # echter Lauf
    python3 archive_chats.py --dry-run       # nur anzeigen, nichts schreiben
    python3 archive_chats.py --vault <pfad>  # anderes Vault-Verzeichnis
"""
from __future__ import annotations
import argparse
import json
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

# ---------------------------------------------------------------------------
DEFAULT_VAULT = Path("/Users/jessenikoi/Workplace/Obsidian")
ARCHIVE_SUBDIR = "80_ARCHIV/Chat-Archiv"
CLAUDE_PROJECTS = Path.home() / ".claude" / "projects"
CODEX_SESSIONS = Path.home() / ".codex" / "sessions"

# Nachrichten, die mit einem dieser Marker beginnen, sind System-/Tool-Rauschen.
# Projekt-/Pfad-Fragmente, die KEINE echten Nutzer-Chats sind (intern/automatisch).
NOISE_PATH_FRAGMENTS = (
    "observer-sessions", "mem-observer", "/subagents/", "-subagents",
    ".claude-mem",
)

NOISE_PREFIXES = (
    "<environment_context", "<permissions", "<skill>", "<system-reminder",
    "<user-prompt-submit-hook", "<command-name", "<command-message",
    "<command-args", "<local-command", "Caveat:", "<budget", "<task-",
    "<example", "[Request interrupted", "<persisted-context",
)


def slugify(text: str, maxlen: int = 60) -> str:
    text = (text or "").strip().lower()
    text = re.sub(r"[^a-z0-9äöüß\s-]", "", text)
    text = re.sub(r"[\s_-]+", "-", text).strip("-")
    return (text[:maxlen].rstrip("-")) or "ohne-titel"


def is_noise_path(path: Path) -> bool:
    s = str(path).lower()
    return any(frag in s for frag in NOISE_PATH_FRAGMENTS)


def is_noise(text: str) -> bool:
    if not text or not text.strip():
        return True
    stripped = text.lstrip()
    return stripped.startswith(NOISE_PREFIXES)


def fm_escape(text: str) -> str:
    return (text or "").replace('"', "'").replace("\n", " ").strip()


# ---------------------------------------------------------------------------
def project_from_claude_dir(dirname: str) -> str:
    """`-Users-jessenikoi-Claude-Code-Mainordner-Wedding` -> `Wedding` (letztes Glied)."""
    parts = [p for p in dirname.split("-") if p]
    # 'Users','jessenikoi' am Anfang abschneiden, Rest als Projektpfad
    while parts and parts[0] in ("Users", "jessenikoi", ""):
        parts.pop(0)
    if not parts:
        return "diverse"
    name = "-".join(parts[-3:]) if len(parts) > 3 else "-".join(parts)
    return slugify(name) or "diverse"


def project_from_cwd(cwd: str) -> str:
    if not cwd:
        return "diverse"
    base = Path(cwd).name or Path(cwd).parent.name
    if base in ("jessenikoi", ""):
        return "home"
    return slugify(base) or "diverse"


# ---------------------------------------------------------------------------
def parse_claude_session(path: Path):
    """-> (title, iso_date, [(role, text), ...]) oder None bei leer/kaputt."""
    title = None
    first_ts = None
    msgs = []
    try:
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    except Exception:
        return None
    for line in lines:
        try:
            d = json.loads(line)
        except Exception:
            continue
        t = d.get("type")
        ts = d.get("timestamp")
        if ts and not first_ts:
            first_ts = ts
        if t == "ai-title":
            title = d.get("title") or d.get("aiTitle")
        elif t == "user":
            content = (d.get("message") or {}).get("content")
            if isinstance(content, str) and not is_noise(content):
                msgs.append(("Du", content.strip()))
        elif t == "assistant":
            content = (d.get("message") or {}).get("content")
            if isinstance(content, list):
                texts = [b.get("text", "") for b in content
                         if isinstance(b, dict) and b.get("type") == "text"]
                joined = "\n\n".join(x for x in texts if x.strip())
                if joined and not is_noise(joined):
                    msgs.append(("KI", joined.strip()))
    if not msgs:
        return None
    if not title:
        # erster echter Du-Beitrag als Titel
        for role, text in msgs:
            if role == "Du":
                title = text[:80]
                break
        title = title or "Ohne Titel"
    iso = (first_ts or "")[:10] or "0000-00-00"
    return title.strip(), iso, msgs


def parse_codex_session(path: Path):
    title = None
    first_ts = None
    cwd = ""
    msgs = []
    try:
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    except Exception:
        return None
    for line in lines:
        try:
            d = json.loads(line)
        except Exception:
            continue
        ts = d.get("timestamp")
        if ts and not first_ts:
            first_ts = ts
        if d.get("type") == "session_meta":
            cwd = (d.get("payload") or {}).get("cwd", cwd)
        elif d.get("type") == "response_item":
            p = d.get("payload") or {}
            if p.get("type") == "message" and p.get("role") in ("user", "assistant"):
                blocks = p.get("content") or []
                text = "\n\n".join(
                    b.get("text", "") for b in blocks
                    if isinstance(b, dict) and b.get("text"))
                if text and not is_noise(text):
                    role = "Du" if p["role"] == "user" else "KI"
                    msgs.append((role, text.strip()))
    if not msgs:
        return None
    for role, text in msgs:
        if role == "Du":
            title = text[:80]
            break
    title = title or (Path(cwd).name if cwd else "Codex-Session")
    iso = (first_ts or "")[:10] or "0000-00-00"
    return title.strip(), iso, msgs, cwd


# ---------------------------------------------------------------------------
def render_md(title, iso, source, project, session_id, msgs) -> str:
    out = ["---",
           f'titel: "{fm_escape(title)}"',
           f"datum: {iso}",
           f"quelle: {source}",
           f"projekt: {project}",
           f"session_id: {session_id}",
           f"nachrichten: {len(msgs)}",
           "tags: [chat-archiv, " + source.lower().replace(' ', '-') + "]",
           "---", "",
           f"# {title}", "",
           f"> **Quelle:** {source}  ·  **Projekt:** {project}  ·  "
           f"**Datum:** {iso}  ·  **Session:** `{session_id}`", ""]
    for role, text in msgs:
        out.append(f"## {role}")
        out.append("")
        out.append(text)
        out.append("")
    return "\n".join(out)


def write_session(target_dir: Path, base: str, md: str, raw_src: Path, dry: bool):
    """Schreibt <base>.md (+ kopiert raw .jsonl). Gibt True bei neu geschrieben."""
    md_path = target_dir / f"{base}.md"
    if md_path.exists():
        return False
    if dry:
        return True
    target_dir.mkdir(parents=True, exist_ok=True)
    md_path.write_text(md, encoding="utf-8")
    try:
        shutil.copy2(raw_src, target_dir / f"{base}.jsonl")
    except Exception:
        pass
    return True


# ---------------------------------------------------------------------------
CLOUD_GUIDES = {
    "ChatGPT": "ChatGPT-Verläufe exportieren:\n\n"
               "1. ChatGPT öffnen → Settings → **Data controls** → **Export data**\n"
               "2. Bestätigen — der Export kommt per E-Mail (Link, gültig 24 h)\n"
               "3. ZIP herunterladen, entpacken\n"
               "4. `conversations.json` (+ den HTML-Ordner) **hier ablegen**\n",
    "Claude-Web": "Claude.ai / Cowork exportieren:\n\n"
                  "1. claude.ai → Settings → **Privacy** → **Export data**\n"
                  "2. Export kommt per E-Mail\n"
                  "3. `conversations.json` **hier ablegen**\n",
    "Manus": "Manus exportieren:\n\n"
             "1. Im Manus-Konto nach **Export / Download** suchen\n"
             "2. (Lokal liegt nur `~/.manus/logs` — keine Verläufe)\n"
             "3. Exportierte Dateien **hier ablegen**\n",
    "WhatsApp": "WhatsApp-Chats exportieren (pro Unterhaltung):\n\n"
                "1. Chat öffnen → ⋮ → **Mehr** → **Chat exportieren**\n"
                "2. **Mit Medien** wählen\n"
                "3. Die `_chat.txt` + Medien in einen Unterordner `<Kontakt>/` **hier ablegen**\n\n"
                "⚠️ Das **verschlüsselte Voll-Backup** (iCloud/Drive) ist NICHT lesbar — "
                "nutze immer „Chat exportieren\".\n",
}


def write_cloud_skeleton(archive: Path, dry: bool):
    for name, guide in CLOUD_GUIDES.items():
        d = archive / name
        f = d / "_ANLEITUNG.md"
        if f.exists():
            continue
        if dry:
            print(f"  [dry] Cloud-Gerüst: {f}")
            continue
        d.mkdir(parents=True, exist_ok=True)
        f.write_text(f"# {name} — Export-Anleitung\n\n{guide}\n", encoding="utf-8")


def write_index(archive: Path, rows: list, dry: bool):
    rows.sort(key=lambda r: r["datum"], reverse=True)
    lines = ["---", "titel: Chat-Archiv Index", f"stand: {datetime.now().strftime('%Y-%m-%d')}",
             "tags: [chat-archiv, index]", "---", "",
             "# Chat-Archiv — Index", "",
             f"Stand: {len(rows)} archivierte Sessions. Generiert von `archive_chats.py`.", "",
             "| Datum | Quelle | Projekt | Titel |", "|---|---|---|---|"]
    for r in rows:
        link = r["relpath"].replace(" ", "%20")
        lines.append(f"| {r['datum']} | {r['quelle']} | {r['projekt']} | [{r['titel'][:70]}]({link}) |")
    lines += ["", "## Cloud-Quellen (manuell exportieren)",
              "- [ChatGPT](ChatGPT/_ANLEITUNG.md)",
              "- [Claude-Web](Claude-Web/_ANLEITUNG.md)",
              "- [Manus](Manus/_ANLEITUNG.md)",
              "- [WhatsApp](WhatsApp/_ANLEITUNG.md)", ""]
    if dry:
        print(f"  [dry] INDEX.md mit {len(rows)} Zeilen")
        return
    (archive / "INDEX.md").write_text("\n".join(lines), encoding="utf-8")


# ---------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--vault", type=Path, default=DEFAULT_VAULT)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    archive = args.vault / ARCHIVE_SUBDIR
    if not args.vault.exists():
        sys.exit(f"ABBRUCH: Vault '{args.vault}' existiert nicht.")

    rows = []
    new_count = skip_count = err_count = 0
    errors = []

    # ---- Claude Code ----
    print("==> Claude Code")
    for jsonl in sorted(CLAUDE_PROJECTS.rglob("*.jsonl")):
        if is_noise_path(jsonl):
            continue
        parsed = parse_claude_session(jsonl)
        if not parsed:
            err_count += 1
            errors.append(str(jsonl))
            continue
        title, iso, msgs = parsed
        project = project_from_claude_dir(jsonl.parent.name)
        sid = jsonl.stem
        base = f"{iso}_{slugify(title)}_{sid[:8]}"
        tdir = archive / "Claude-Code" / project
        md = render_md(title, iso, "Claude Code", project, sid, msgs)
        wrote = write_session(tdir, base, md, jsonl, args.dry_run)
        rows.append({"datum": iso, "quelle": "Claude Code", "projekt": project,
                     "titel": title, "relpath": f"Claude-Code/{project}/{base}.md"})
        new_count += wrote
        skip_count += (not wrote)

    # ---- Codex ----
    print("==> Codex")
    for jsonl in sorted(CODEX_SESSIONS.rglob("rollout-*.jsonl")):
        if is_noise_path(jsonl):
            continue
        parsed = parse_codex_session(jsonl)
        if not parsed:
            err_count += 1
            errors.append(str(jsonl))
            continue
        title, iso, msgs, cwd = parsed
        if is_noise_path(Path(cwd)):
            continue
        project = project_from_cwd(cwd)
        sid = jsonl.stem.split("-")[-1]
        base = f"{iso}_{slugify(title)}_{sid[:8]}"
        tdir = archive / "Codex" / project
        md = render_md(title, iso, "Codex", project, sid, msgs)
        wrote = write_session(tdir, base, md, jsonl, args.dry_run)
        rows.append({"datum": iso, "quelle": "Codex", "projekt": project,
                     "titel": title, "relpath": f"Codex/{project}/{base}.md"})
        new_count += wrote
        skip_count += (not wrote)

    write_cloud_skeleton(archive, args.dry_run)
    write_index(archive, rows, args.dry_run)

    print("\n==> Fertig")
    print(f"  Neu geschrieben: {new_count}")
    print(f"  Übersprungen (schon da): {skip_count}")
    print(f"  Übersprungen (leer/kaputt): {err_count}")
    print(f"  Sessions im Index: {len(rows)}")
    if args.dry_run:
        print("  (dry-run: nichts geschrieben)")
    print(f"  Archiv: {archive}")


if __name__ == "__main__":
    main()
