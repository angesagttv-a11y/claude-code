# Projekt-Kontext: Graphify + Obsidian + Claude Code im Workplace
**Datum der Sitzung:** 2026-06-10

## 1. Übergeordnetes Ziel

Graphify (Wissensgraph-Tool), Obsidian (kuratiertes "zweites Gehirn") und
Claude Code sollen im bestehenden, organisch gewachsenen Workplace
(`/Users/jessenikoi/Workplace`, macOS) kombiniert werden — **ohne** den
Workplace zu einem Graphify-Monorepo zu machen und **ohne** bestehende
Strukturen (Projektanker in `10_AKTIV/`, kuratierter Obsidian-Vault,
private/finanzielle/rechtliche/Medien-Bereiche) zu stören.

Endzustand: Pro echtem Code-Root (Git-Repo unter `60_DEV_AGENTEN_TOOLS/`)
kann `/graphify .` einen lokalen Wissensgraphen (`graphify-out/`) erzeugen,
der Claude Code (und Codex, Manus etc.) als Kontext dient. Der
Obsidian-Vault bekommt nur kuratierte/verdichtete Inhalte. Alle dafür
nötigen Werkzeuge/Doku liegen versioniert in
`angesagttv-a11y/claude-code` (Branch `claude/graphify-install-setup-5y5u3r`)
als privater Backup-/Sync-Mechanismus zwischen Manus, Codex und Claude.

## 2. Zusammenfassung dieser Sitzung

Chronologisch (diese und vorherige, zusammengefasste Sitzung):

1. Nutzer wollte Graphify (`uv tool install graphifyy`) installieren und von
   Anfang an die richtige Ordnerstruktur im Workplace anlegen.
2. Nutzer erklärte den Graphify+Obsidian+Claude-Code-Workflow ("Cheat Code")
   anhand eines YouTube-Videos; Ziel: Claude Code als aktiver Agent,
   Graphify als Wissensgraph-Generator, Obsidian als kuratiertes
   Langzeitgedächtnis.
3. Nutzer stellte klar: das Repo `angesagttv-a11y/claude-code` ist **nur ein
   privates Backup/Sync-Tool** zwischen Manus, Codex und Claude — muss
   **nicht** öffentlich/PR-pflichtig sein.
4. Nutzer lieferte ein "WorkspaceAudit"-Dokument (von Manus erstellt) mit der
   echten Struktur von `/Users/jessenikoi/Workplace` (siehe Abschnitt 3).
5. Auf Nachfrage entschied der Nutzer: finale Doku **anonymisiert in diesem
   Repo** dokumentieren (Platzhalter statt echter Projekt-/Firmennamen).
6. Erstellt: `docs/workplace-graphify-obsidian-setup.md` — Hybridmodell,
   Entscheidungstabelle, Schritt-für-Schritt-Anleitung, Leitplanken.
7. Auf erneute Anweisung (per `/plan` + erneutem Audit-Upload + drei
   `__main__.py`-Quelldateien des Graphify-CLI): Abschnitt 7
   "Multi-Agent-Plan (Claude/Codex/Manus)" ergänzt — basierend auf der
   `_PLATFORM_CONFIG`-Struktur aus dem Graphify-Quellcode (`graphify install
   --project --platform <name>`).
8. Auf Anweisung "setzt das jetzt bitte alles so um" (GSD/Superpower-Skill
   angefragt, aber **nicht installiert** — nur `graphify`,
   `session-start-hook`, `listingpro-wordpress-portal-master` vorhanden):
   lauffähiges Toolkit erstellt:
   - `scripts/setup-graphify-workplace.sh` (idempotentes Bootstrap-Skript)
   - `docs/workplace-setup/templates/{graphifyignore.template, PROJEKT.md,
     projekt-uebersicht.md}`
   - `docs/workplace-setup/README.md`
   - Getestet: Syntax-Check, Dry-Run, alter Privacy-Guard (`30_PRIVAT`),
     Idempotenz — alle ✅.
9. Auf Anfrage "ist alles umgesetzt? schreib mir Übersicht": erstellt
   `docs/workplace-setup/UEBERSICHT.md` mit Status-Tabelle, Use-Case,
   Datei-Übersicht, Schritt-für-Schritt-Anleitung, "nächste Schritte".
10. Nutzer lieferte zwei detaillierte, von einer anderen KI (vermutlich
    Manus) erstellte Arbeitsanweisungen für "Claude Code auf Jesses lokalem
    Mac" (`/Users/jessenikoi/Workplace`):
    - Dokument A: allgemeine Umsetzungsanweisung (Repo klonen, Vault
      initialisieren, Graphify installieren, sicheren Code-Root wählen,
      Skript dry-run/echt ausführen, `/graphify .`, optionaler
      Obsidian-Export, lokale Übersicht anlegen, Abnahmeprotokoll).
    - Dokument B: zusätzliche Vorbedingung — **erst** den Safety Guard im
      Skript erweitern und testen, **dann erst** lokal gegen den echten
      Workplace ausführen. Enthält konkrete Forbidden-Path-Liste mit echten
      Pfaden (`/Users/jessenikoi/Workplace`, `/Users/jessenikoi/Workplace/10_AKTIV`,
      `/Users/jessenikoi/Workplace/30_PRIVAT`, `.../20_FIRMEN_FINANZEN_RECHT`,
      `.../50_MEDIEN_ASSETS`, `.../70_ARCHIV_INDEX`) und einen Testblock mit
      erwarteten Ergebnissen.
11. Da diese Sandbox **keinen Zugriff auf den Mac** hat, wurde **nur der
    Skript-/Doku-Teil** umgesetzt (Abschnitte 4–7 von Dokument B):
    - `guard_private` → `guard_forbidden_path` (generischere, basename-
      basierte Implementierung statt hartcodierter `/Users/jessenikoi/...`-
      Pfade — Begründung: Anonymisierungs-Entscheidung aus Schritt 5
      respektieren).
    - Neuer `--workspace-root`-Parameter / `GRAPHIFY_WORKSPACE_ROOT`-Env-Var:
      blockiert den Workspace-Root selbst als Ziel.
    - `FORBIDDEN_BASENAMES`: `30_PRIVAT`, `PRIVAT`, `20_FIRMEN_FINANZEN_RECHT`,
      `50_MEDIEN_ASSETS`, `70_ARCHIV_INDEX`, `10_AKTIV` — als exakter
      Basename **und** als übergeordneter Pfad-Bestandteil gesperrt.
    - Getestet mit anonymisierter Beispielstruktur in `/tmp/`: 1 erlaubter
      Pfad + 8 gesperrte Pfade — alle Ergebnisse exakt wie in Dokument B
      Abschnitt 5.2 spezifiziert (✅ alle 9/9 bestanden).
    - Doku aktualisiert: `docs/workplace-graphify-obsidian-setup.md`
      (neuer Unterabschnitt unter "6. Wichtige Leitplanken") und
      `docs/workplace-setup/UEBERSICHT.md` (neue Sektion "5. Harte Regeln
      (Safety Guard im Skript)").
    - Committed & gepusht (kein PR).
12. Nutzer führte den Dry-Run-Befehl lokal aus, **bevor** das Repo geklont
    war → Fehler "Skript existiert nicht". Klargestellt: Repo muss erst nach
    `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`
    geklont werden (Befehl dafür bereitgestellt), danach funktioniert der
    Befehl mit `./scripts/...` relativ zu diesem Verzeichnis.

## 3. Wichtige Entscheidungen & Festlegungen

**Fakten** (verifiziert/gegeben):
- Repo: `angesagttv-a11y/claude-code`, Arbeits-Branch:
  `claude/graphify-install-setup-5y5u3r`. Kein PR erstellt.
- Workplace-Root (real, vom Nutzer/Manus-Audit bestätigt):
  `/Users/jessenikoi/Workplace` (macOS, Nutzer `jessenikoi`).
- Workplace-Struktur (Top-Level, aus Dokument B bestätigt):
  `AGENTS.md`, `00_STEUERUNG/HAUPTINDEX.md`, `10_AKTIV/`,
  `20_FIRMEN_FINANZEN_RECHT/`, `30_PRIVAT/`, `50_MEDIEN_ASSETS/`,
  `60_DEV_AGENTEN_TOOLS/`, `70_ARCHIV_INDEX/`, `Daily/`, `Obsidian/`.
- `uv` ist auf dem Mac vorhanden unter `/Users/jessenikoi/.local/bin/uv`.
- Graphify-CLI: Paketname **`graphifyy`**, CLI-Befehl **`graphify`**
  (`uv tool install graphifyy && graphify install`).
- Vorgesehener lokaler Klon-Pfad für dieses Repo:
  `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`.
- In dieser Sandbox sind **keine** GSD-/Superpower-Skills installiert, nur
  `graphify`, `session-start-hook`, `listingpro-wordpress-portal-master`.
- Diese Sandbox hat **keinen Zugriff** auf `/Users/jessenikoi/Workplace`
  (isolierte Cloud-Umgebung).

**Annahmen / unbestätigt (Stand letzter Audit, evtl. veraltet):**
- `.obsidian/` existiert in `Obsidian/` noch nicht (zuletzt geprüft: nicht
  vorhanden) — muss vor Vault-Skill-Installation einmal in Obsidian-App
  geöffnet werden.
- Es wurden zuletzt keine `graphify-out/`, `graph.html`, `GRAPH_REPORT.md`,
  `graph.json` irgendwo im Workplace gefunden.
- Nur ein `.claude`-Ordner gefunden, unter `30_PRIVAT/.claude/` — explizit
  **nicht** als globaler Standard verwenden.

**Festlegungen / Entscheidungen (vom Nutzer getroffen oder von mir
vorgeschlagen und nicht widersprochen):**
- Hybridmodell statt Monorepo: `10_AKTIV/<Projekt_X>/` bleibt operative
  Projektlandkarte (kein Code-Root, kein Graphify direkt darauf).
  `graphify-out/` immer projektlokal im jeweiligen Code-Root unter
  `60_DEV_AGENTEN_TOOLS/`. Obsidian-Vault bekommt nur kuratierte Inhalte.
- Repo ist privates Backup-/Sync-Tool — **kein PR**, sofern nicht explizit
  gewünscht.
- Doku in diesem Repo ist **anonymisiert** (Platzhalter `<WORKSPACE_ROOT>`,
  `<VAULT_ROOT>`, `<Projekt_X>` etc.) — bewusste Entscheidung gegen Klartext
  mit echten Firmen-/Projektnamen.
- Safety-Guard-Implementierung: **basename-/musterbasiert** statt
  hartcodierter absoluter `/Users/jessenikoi/...`-Pfade — um o.g.
  Anonymisierungsentscheidung nicht zu unterlaufen, aber denselben
  Schutzumfang zu erreichen (alle Testfälle aus Dokument B bestehen).
- `FORBIDDEN_BASENAMES` (technisch erzwungen):
  `30_PRIVAT`, `PRIVAT`, `20_FIRMEN_FINANZEN_RECHT`, `50_MEDIEN_ASSETS`,
  `70_ARCHIV_INDEX`, `10_AKTIV` — als exakter Ordnername **und** als
  übergeordneter Pfadbestandteil gesperrt für `--code-root`, `--vault`,
  `--workspace-root`.
- Neuer optionaler Parameter `--workspace-root` / Env `GRAPHIFY_WORKSPACE_ROOT`:
  blockiert den Workspace-Root selbst als Ziel/Scan-Root.
- Erster empfohlener Test-Code-Root laut Dokument A/B:
  `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`
  (= dieses Setup-Repo selbst). **Hinweis:** Das bedeutet, Graphify würde
  zuerst auf das Tooling-Repo selbst angewendet, nicht auf ein
  "richtiges" Projekt — siehe Abschnitt 5, offene Frage 1.

## 4. Aktueller Status (Erreichtes)

Im Branch `claude/graphify-install-setup-5y5u3r` (gepusht, kein PR):

| Datei | Inhalt/Zweck | Status |
|---|---|---|
| `docs/workplace-graphify-obsidian-setup.md` | Konzept: Hybridmodell, Entscheidungsbaum, Schritt-für-Schritt, Leitplanken (inkl. Safety-Guard-Beschreibung), Multi-Agent-Plan (Abschnitt 7) | ✅ fertig |
| `docs/workplace-setup/README.md` | Kurzanleitung zum Skript | ✅ fertig |
| `docs/workplace-setup/UEBERSICHT.md` | Status-Tabelle, Use-Case, Datei-Übersicht, Gebrauchsanleitung, Safety-Guard-Sektion (5) | ✅ fertig |
| `docs/workplace-setup/templates/graphifyignore.template` | Vorlage `.graphifyignore` | ✅ fertig |
| `docs/workplace-setup/templates/PROJEKT.md` | Vorlage Projektanker (`10_AKTIV/<Projekt_X>/PROJEKT.md`) | ✅ fertig |
| `docs/workplace-setup/templates/projekt-uebersicht.md` | Vorlage Vault-Notiz (`Obsidian/10_PROJEKTE/<Projekt_X>/`) | ✅ fertig |
| `scripts/setup-graphify-workplace.sh` | Idempotentes Setup-Skript mit gehärtetem `guard_forbidden_path`, `--workspace-root`, `--dry-run` | ✅ fertig, in Sandbox getestet |

**In Sandbox getestet (nicht auf echtem Mac):**
- `bash -n` Syntax-Check ✅
- Dry-Run Standardablauf ✅
- Idempotenz (zweiter Lauf überspringt vorhandene Dateien) ✅
- Guard: 1 erlaubter Pfad + 8 gesperrte Pfade (Workspace-Root, `10_AKTIV`,
  `30_PRIVAT`, `30_PRIVAT/Test`, `20_FIRMEN_FINANZEN_RECHT`,
  `20_FIRMEN_FINANZEN_RECHT/Test`, `50_MEDIEN_ASSETS`, `70_ARCHIV_INDEX`) —
  alle 9/9 wie erwartet ✅

**Noch NICHT erledigt (alles auf dem Mac, Stand: gerade erst begonnen):**
- Repo nach `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`
  geklont — **noch nicht passiert** (letzter Versuch des Nutzers schlug
  fehl, weil Klon-Schritt übersprungen wurde; Klon-Befehl wurde
  bereitgestellt, aber Ausführung nicht bestätigt).
- `graphify` auf dem Mac installiert (`uv tool install graphifyy`) —
  unbekannt/offen.
- `.obsidian/` im Vault initialisiert — unbekannt/offen.
- Erster `--dry-run` lokal erfolgreich durchgeführt — offen.
- Echter Lauf des Setup-Skripts — offen.
- `/graphify .` in einem Code-Root — offen.
- Optionaler Obsidian-Export — offen.
- Lokale Übersichtsdatei
  `60_DEV_AGENTEN_TOOLS/02_Claude/Graphify_Obsidian_Setup/UEBERSICHT_GRAPHIFY_OBSIDIAN.md`
  (laut Dokument A/B Abschnitt 15) — offen.

## 5. Nächste Schritte (Offene Punkte)

**Empfohlene konkrete Reihenfolge für die nächste (lokale) Sitzung:**

1. **Repo klonen** (Befehl liegt bereit, siehe Abschnitt 6) nach
   `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`,
   Branch `claude/graphify-install-setup-5y5u3r` auschecken.
2. `AGENTS.md` und `00_STEUERUNG/HAUPTINDEX.md` im Workplace-Root lesen
   (Dokument A/B, Abschnitt 1/2 — noch nicht geschehen).
3. `.obsidian/` prüfen; falls fehlend, Nutzer bittet, den Vault einmal in
   der Obsidian-App zu öffnen.
4. `uv --version` und `command -v graphify` prüfen; falls fehlend,
   `uv tool install graphifyy`.
5. Dry-Run des gehärteten Skripts mit `--workspace-root` ausführen (Befehl
   in Abschnitt 6), Ausgabe prüfen.
6. Bei sauberem Dry-Run: echten Lauf ausführen.
7. `/graphify .` im gewählten Code-Root ausführen, `graphify-out/` prüfen.
8. Lokale Übersichtsdatei gemäß Dokument A/B Abschnitt 15 anlegen.
9. Abnahmeprotokoll (Tabelle aus Dokument B Abschnitt 16) an Jesse
   zurückmelden.

**Meine Empfehlung (aktive Handlungsempfehlung, keine bloße Option):**
Schritt 1 (Repo klonen) zuerst und isoliert ausführen lassen, **bevor**
irgendetwas anderes versucht wird — das war der Fehler im letzten Versuch.
Erst danach Schritt 5/6 (Dry-Run/echter Lauf) angehen.

**Offene Rückfragen an Jesse (Unsicherheiten, die ich nicht selbst auflösen
kann):**

1. **Erster Code-Root:** Soll wirklich dieses Setup-Repo selbst
   (`60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`) der erste Graphify-
   Test-Code-Root sein (so von Manus/Dokument A/B vorgeschlagen), oder soll
   stattdessen ein "echtes" Arbeitsprojekt aus `60_DEV_AGENTEN_TOOLS/`
   genommen werden? Beides ist technisch möglich, aber inhaltlich ein
   Unterschied (Wissensgraph über das Tooling vs. über ein Arbeitsprojekt).
2. **Aktueller Stand `.obsidian/`:** Ist der Vault inzwischen in Obsidian
   geöffnet worden (seit dem letzten Audit)? Falls ja, kann Schritt 3 in
   Abschnitt 5 übersprungen werden.
3. **`--platform codex`:** Soll Codex tatsächlich denselben Code-Root
   verwenden wie Claude (dann macht `--platform claude --platform codex`
   im selben Lauf Sinn), oder arbeitet Codex an einem anderen Projekt
   (dann separater Lauf mit eigenem `--code-root` sinnvoller)?

## 6. Relevanter Code / Rohdaten

### Klon-Befehl (für die nächste lokale Sitzung, Schritt 1)

```bash
BASE="/Users/jessenikoi/Workplace"
REPO_DIR="$BASE/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code"

mkdir -p "$(dirname "$REPO_DIR")"

if [ -d "$REPO_DIR/.git" ]; then
  cd "$REPO_DIR"
  git fetch origin
  git checkout claude/graphify-install-setup-5y5u3r
  git pull origin claude/graphify-install-setup-5y5u3r
else
  git clone https://github.com/angesagttv-a11y/claude-code "$REPO_DIR"
  cd "$REPO_DIR"
  git checkout claude/graphify-install-setup-5y5u3r
fi

ls -la docs/workplace-setup/UEBERSICHT.md scripts/setup-graphify-workplace.sh docs/workplace-setup/templates/
```

### Dry-Run-Befehl (Schritt 5, nach erfolgreichem Klon, im Repo-Verzeichnis)

```bash
chmod +x scripts/setup-graphify-workplace.sh

./scripts/setup-graphify-workplace.sh \
  --workspace-root "/Users/jessenikoi/Workplace" \
  --vault "/Users/jessenikoi/Workplace/Obsidian" \
  --code-root "/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code" \
  --platform claude --platform codex \
  --dry-run
```

### Kern der gehärteten Guard-Funktion (`scripts/setup-graphify-workplace.sh`)

```bash
FORBIDDEN_BASENAMES=(
  "30_PRIVAT"
  "PRIVAT"
  "20_FIRMEN_FINANZEN_RECHT"
  "50_MEDIEN_ASSETS"
  "70_ARCHIV_INDEX"
  "10_AKTIV"
)

guard_forbidden_path() {
  local p="$1"
  if [[ -z "$p" ]]; then
    echo "ABBRUCH: leerer Pfad ist nicht erlaubt." >&2
    exit 1
  fi

  local normalized
  normalized="$(_normalize_path "$p")"

  if [[ -n "$WORKSPACE_ROOT" ]]; then
    local ws_normalized
    ws_normalized="$(_normalize_path "$WORKSPACE_ROOT")"
    if [[ "$normalized" == "$ws_normalized" ]]; then
      echo "ABBRUCH: Workspace-Root selbst darf nicht als Ziel-/Scan-Root verwendet werden: $normalized" >&2
      exit 1
    fi
  fi

  local base
  base="$(basename "$normalized")"
  for forbidden in "${FORBIDDEN_BASENAMES[@]}"; do
    if [[ "$base" == "$forbidden" ]]; then
      echo "ABBRUCH: Pfad zeigt auf einen gesperrten Bereich ('$forbidden'): $normalized" >&2
      exit 1
    fi
  done

  case "$normalized" in
    */30_PRIVAT/*|*/PRIVAT/*|*/20_FIRMEN_FINANZEN_RECHT/*|*/50_MEDIEN_ASSETS/*|*/70_ARCHIV_INDEX/*|*/10_AKTIV/*)
      echo "ABBRUCH: Pfad liegt innerhalb eines gesperrten Bereichs: $normalized" >&2
      exit 1
      ;;
  esac
}
```

### Quelldokumente (in dieser Sitzung hochgeladen, im Repo nicht gespeichert)

- `WorkspaceAudit_fu_r_Claude_Code_Workplace_Obsidian_und_Graphify.md` —
  Manus-Audit der echten Workplace-Struktur (4x identisch hochgeladen).
- Drei `__main__.py`-Dateien (~4642 Zeilen, Graphify-CLI-Quellcode,
  identisch) — Quelle für `_PLATFORM_CONFIG`.
- `ClaudeCodeAnweisung_Graphify_Obsidian_final_im_Workplace_umsetzen.md`
  (Dokument A) — Schritt-für-Schritt-Anweisung für lokale Mac-Session.
- `ClaudeCodeAnweisung_Safety_Guard_erweitern_und_danach_...md`
  (Dokument B) — wie A, aber mit vorgeschalteter Guard-Härtung +
  Forbidden-Path-Testmatrix.

Diese vier Dokumente liegen **nicht** in diesem Repo, sondern nur als
Uploads in dieser Konversation. Falls die nächste Sitzung sie braucht,
müssen sie erneut bereitgestellt werden — oder dieses Handover-Dokument
referenziert die relevanten Inhalte bereits (siehe Abschnitte 2–5).
