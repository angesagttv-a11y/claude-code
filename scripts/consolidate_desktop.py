#!/usr/bin/env python3
"""
consolidate_desktop.py — Desktop-Dateien sicher in den Workplace einsortieren.

Strategie (Projekt B): Docs/Projekte KOPIEREN (umkehrbar), große Medien MOVEN
(Platz sparen). 0-Byte-Ordner (Symlink-Farmen) werden übersprungen. Erst immer
--dry-run. Schreibt ein Manifest (was → wohin) ins Eingang.

Aufruf:
    python3 consolidate_desktop.py --dry-run   # nur anzeigen, NICHTS ändern
    python3 consolidate_desktop.py             # echter Lauf
"""
from __future__ import annotations
import argparse
import subprocess
import unicodedata
from datetime import datetime
from pathlib import Path


def norm(s: str) -> str:
    """Unicode-normalisieren (NFC) + Rand-Whitespace weg — für robustes Matching."""
    return unicodedata.normalize("NFC", s).strip()

HOME = Path.home()
DESKTOP = HOME / "Desktop"
W = HOME / "Workplace"

KUNDEN = W / "40_KUNDEN_PARTNER"
FINANZ_EINGANG = W / "20_FIRMEN_FINANZEN_RECHT" / "00_Eingang" / "_Desktop_Import"
MEDIEN_UNSORT = W / "50_MEDIEN_ASSETS" / "01_Eingang_Unsortiert" / "_Desktop_Import"
TRIAGE = W / "01_EINGANG" / "02_SCHREIBTISCH_PRUEFEN" / "_Desktop_Import"
CS_REVIEW = TRIAGE / "Campus_Sparbuch_2026_PRUEFEN"

# Sensible Schlüsselwörter (lose Dateien) -> Finanz/Recht
SENSITIVE = ("jobcenter", "versicher", "provision", "beleg", "gehalt", "steuer",
             "rechnung", "überweis", "uberweis", "mahnung", "bkk", "sparkasse",
             "kontoauszug", "lohn", "bescheid")

# Explizite Ordner-Regeln: name -> (ziel, aktion)
FOLDER_RULES = {
    "Schlossmühle, Grillwerkstatt - Sven Schurig":
        (KUNDEN / "Schlossmuehle_Grillwerkstatt_Sven_Schurig" / "_Desktop_Import", "copy"),
    "Andreas": (KUNDEN / "00_Eingang" / "Andreas", "copy"),
    "Campus Sparbuch 2026": (CS_REVIEW, "copy"),
    "campus-sparbuch-videos": (CS_REVIEW / "videos", "copy"),
    # DCIM / DCIM 2 / Insta 360 bleiben bewusst auf dem Desktop (Nutzer-Wunsch).
    "Schreibtisch aufräumen 01.02.2025":
        (W / "01_EINGANG" / "02_SCHREIBTISCH_PRUEFEN" / "Schreibtisch_2025-02-01", "copy"),
}
FOLDER_RULES_NORM = {norm(k): v for k, v in FOLDER_RULES.items()}


def dir_size(p: Path) -> int:
    """Echter Plattenverbrauch via `du -sk` (Bytes). 0 = nur Symlinks/leer.
    NICHT apparent size — Sparse-Files würden sonst riesig erscheinen."""
    try:
        out = subprocess.run(["du", "-sk", str(p)], capture_output=True,
                             text=True, timeout=120)
        return int(out.stdout.split()[0]) * 1024
    except Exception:
        return 0


def human(n: int) -> str:
    for unit in ("B", "K", "M", "G"):
        if n < 1024:
            return f"{n:.0f}{unit}"
        n /= 1024
    return f"{n:.0f}T"


def classify_loose(f: Path) -> Path:
    name = f.name.lower()
    if any(k in name for k in SENSITIVE):
        return FINANZ_EINGANG
    if name.endswith(".png") or name.startswith("bildschirmfoto"):
        return TRIAGE / "Screenshots"
    return TRIAGE / "Dokumente"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()
    dry = args.dry_run

    manifest = [f"# Desktop-Konsolidierung — Manifest ({datetime.now():%Y-%m-%d %H:%M})",
                "", f"Modus: {'DRY-RUN (nichts geändert)' if dry else 'ECHT'}", ""]
    stats = {"copy": 0, "move": 0, "skip": 0, "loose": 0}

    def do(src: Path, dst: Path, action: str):
        if dst.exists() and action != "skip":
            manifest.append(f"- SKIP (Ziel existiert): `{src.name}` → `{dst}`")
            stats["skip"] += 1
            return
        manifest.append(f"- {action.upper()}: `{src.name}` → `{dst.relative_to(W)}`")
        if dry:
            return
        dst.parent.mkdir(parents=True, exist_ok=True)
        if action == "copy":
            # cp -Rc: APFS-Clone (sofort, kein Extra-Platz, sparse-sicher)
            subprocess.run(["cp", "-Rc", str(src), str(dst)], check=True)
        elif action == "move":
            subprocess.run(["mv", str(src), str(dst)], check=True)

    # --- Ordner ---
    manifest.append("## Ordner")
    for child in sorted(DESKTOP.iterdir()):
        if not child.is_dir() or child.name.startswith("."):
            continue
        rule = FOLDER_RULES_NORM.get(norm(child.name))
        if rule is None:
            sz = dir_size(child)
            if sz == 0:
                manifest.append(f"- SKIP (0B / Symlinks): `{child.name}`")
                stats["skip"] += 1
            else:
                manifest.append(f"- OFFEN (keine Regel, {human(sz)}): `{child.name}` "
                                f"→ später entscheiden")
            continue
        dst, action = rule
        if dir_size(child) == 0:
            manifest.append(f"- SKIP (0B / Symlinks): `{child.name}`")
            stats["skip"] += 1
            continue
        do(child, dst, action)
        stats[action] += 1

    # --- Lose Dateien ---
    manifest.append("")
    manifest.append("## Lose Dateien")
    for f in sorted(DESKTOP.iterdir()):
        if not f.is_file() or f.name.startswith("."):
            continue
        target_dir = classify_loose(f)
        dst = target_dir / f.name
        if dst.exists():
            manifest.append(f"- SKIP (existiert): `{f.name}`")
            stats["skip"] += 1
            continue
        manifest.append(f"- COPY: `{f.name}` → `{target_dir.relative_to(W)}`")
        stats["loose"] += 1
        if not dry:
            target_dir.mkdir(parents=True, exist_ok=True)
            subprocess.run(["cp", "-c", str(f), str(dst)], check=True)

    # --- Manifest schreiben ---
    manifest += ["", "## Zusammenfassung",
                 f"- Ordner kopiert: {stats['copy']}",
                 f"- Ordner verschoben: {stats['move']}",
                 f"- Lose Dateien kopiert: {stats['loose']}",
                 f"- Übersprungen: {stats['skip']}"]
    out = "\n".join(manifest)
    print(out if dry else out[-800:])
    if not dry:
        log = W / "01_EINGANG" / "02_SCHREIBTISCH_PRUEFEN" / f"_KONSOLIDIERUNG_{datetime.now():%Y%m%d_%H%M}.md"
        log.parent.mkdir(parents=True, exist_ok=True)
        log.write_text(out, encoding="utf-8")
        print(f"\nManifest: {log}")
    else:
        print("\n(dry-run: nichts geschrieben)")


if __name__ == "__main__":
    main()
