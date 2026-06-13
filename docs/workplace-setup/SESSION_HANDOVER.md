# Projekt-Kontext: Graphify + Obsidian + Claude Code im Workplace
**Datum der Sitzung:** 2026-06-13 (2. Update; ursprünglich 2026-06-10)

**TL;DR für die nächste Sitzung:** Der erste Graphify-Lauf war heute
**erfolgreich** (auf dem `claude-code`-Tooling-Repo selbst, da kein anderes
Git-Repo im Workplace existiert). Pipeline funktioniert komplett. Morgen:
**Praxistest** — Obsidian-Export ausprobieren, Graph als Kontext nutzen,
ggf. ein echtes Projekt als zweites Git-Repo anlegen. Siehe Abschnitt 5.

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

**Erweitertes/langfristiges Ziel (neu, 2026-06-13):** Jesse möchte seinen Mac
grundsätzlich in zwei klar getrennte Bereiche aufteilen:

- **`Workplace`** = der "reine Arbeitsbereich" für KI-Modelle und deren
  Tools/Software (Claude Code, Codex, Graphify, Obsidian-Vault,
  Erinnerungen/Memory-Dateien, Projektanker etc.). Alles, was KI-Agenten
  lesen/schreiben/strukturieren sollen, soll langfristig **nur** hier
  liegen.
- **Restlicher Mac** = privat/getrennt davon. Dazu zählt explizit auch die
  App **"Local"** (WordPress-Staging, Sites unter `~/Local Sites/...`) —
  diese bleibt **außerhalb** von `Workplace` und wird **nicht** angefasst
  oder dorthin verschoben (siehe Abschnitt 3, Festlegungen).

Dieses Handover-Dokument ist explizit dafür gedacht, den Kontext aus der
Cloud-Sandbox in eine **lokale** Claude-Code-Session auf dem Mac zu
übergeben, da diese Sandbox keinen Zugriff auf `/Users/jessenikoi/...` hat.

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
13. Nutzer beantwortete offene Frage 1 (aus der vorherigen Version dieses
    Dokuments): Der **erste** Graphify-Test soll **nicht** über dieses
    Tooling-Repo selbst laufen, sondern über ein **echtes Arbeitsprojekt**.
14. Nutzer zeigte per Screenshots seine reale Mac-Ordnerstruktur
    (Finder: `Workplace`, `10_AKTIV/01_Campus_Sparbuch/06_WP_LISTINGPRO_REVIEW_24C`,
    Codex-Projektliste, "Local Sites"-Ordner) und fragte, ob/wie
    `graphify-out/` angelegt wird und wo was liegt.
15. Geklärt: `graphify-out/` wird **automatisch** durch `/graphify .`
    erzeugt, nichts muss vorab angelegt werden. Vorschlag: Kandidat für den
    ersten Code-Root ist `10_AKTIV/01_Campus_Sparbuch/06_WP_LISTINGPRO_REVIEW_24C`
    (vermutlich der individuelle Theme-/Plugin-Code, getrennt von der
    WordPress-Grundinstallation) — **noch nicht vom Nutzer verifiziert**
    (Code-Dateien + `.git` vorhanden?).
16. Nutzer zeigte per Screenshot, dass Codex auf `handball-campus-local`
    unter `~/Local Sites/handball-campus-local` zeigt (Git-Repo, Branch
    `main`) — verwaltet von der App "Local" (WordPress-Staging). Nutzer
    äußerte das (richtige) Bauchgefühl, dass dieser Ordner nicht der
    richtige Ort für unser Graphify/Obsidian-Setup ist.
17. Bestätigt: `~/Local Sites/...` bleibt unverändert (von "Local"
    verwaltet, nicht verschieben — sonst verliert "Local" die
    Site-Registrierung). Stattdessen: individueller Code (falls als
    separates Git-Repo im Workplace vorhanden, z.B.
    `06_WP_LISTINGPRO_REVIEW_24C`) als Code-Root verwenden — **kein
    Verschieben von Dateien nötig**.
18. Nutzer formulierte das langfristige Strukturziel (siehe Abschnitt 1,
    "Erweitertes/langfristiges Ziel"): `Workplace` = reiner KI-/Tooling-
    Arbeitsbereich (inkl. "Erinnerungen"/Memory), Rest des Mac (inkl.
    "Local") bleibt getrennt/privat. Bat um Vorbereitung einer
    Session-Übergabe für die lokale Mac-Umgebung — dieses Dokument wurde
    entsprechend aktualisiert.
19. **Lokale Mac-Session durchgeführt** (Claude Code v2.1.87, Sonnet 4.6):
    - Repo erfolgreich nach
      `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`
      geklont, Branch `claude/graphify-install-setup-5y5u3r` ausgecheckt.
    - `10_AKTIV/01_Campus_Sparbuch/06_WP_LISTINGPRO_REVIEW_24C` geprüft:
      **kein** `.git`, keine Code-Dateien (nur zwei Desktop-Sammelordner) →
      ungeeignet als Code-Root.
    - Git-Repo-Suche unter `60_DEV_AGENTEN_TOOLS/` und `10_AKTIV/`: einziger
      Treffer im gesamten Workplace ist
      `60_DEV_AGENTEN_TOOLS/02_Claude/claude-code` selbst.
    - Nutzer entschied (pragmatisch, von mir empfohlen): ersten Test mit
      diesem Repo als Code-Root durchführen (so wie ursprünglich von
      Dokument A/B vorgeschlagen — die "Ausweich"-Idee aus Schritt 13/15
      ließ sich nicht umsetzen, da kein zweites Git-Repo existiert).
    - **Dry-Run** ✅, **echter Lauf** ✅ (`graphify install` für `claude` +
      `codex`, `.graphifyignore` war schon vorhanden).
    - **`/graphify .`** vollständig durchgelaufen: 245 Dateien (82 neu, 162
      aus Cache), 4 parallele Extraktions-Subagenten, Ergebnis:
      **1.062 Nodes, 1.383 Edges, 116 Communities**. `graph.html`,
      `GRAPH_REPORT.md`, `graph.json` aktualisiert unter
      `60_DEV_AGENTEN_TOOLS/02_Claude/claude-code/graphify-out/` (nur lokal,
      nicht im Git-Repo — by design).
    - Hinweis erhalten: lokale Session zeigt wiederholt
      `PostToolUse:*: hook error` nach Tool-Aufrufen — wirkt nicht
      blockierend, Ursache (vermutlich ein Hook in `.claude/settings.json`)
      noch nicht untersucht.
    - Schritte 9/10 (lokale Übersichtsdatei, Abnahmeprotokoll) bewusst auf
      morgen verschoben — Kernziel (Pipeline funktioniert end-to-end) ist
      erreicht.

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

**Fakten (neu, aus der lokalen Sitzung vom 2026-06-13):**
- Repo ist geklont unter
  `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`,
  Branch `claude/graphify-install-setup-5y5u3r`, läuft lokal mit
  Claude Code v2.1.87 (Sonnet 4.6).
- `graphify` ist installiert (`/Users/jessenikoi/.local/bin/graphify`),
  `graphify install` für `claude` + `codex` ausgeführt.
- **Im gesamten Workplace existiert aktuell nur EIN Git-Repo:**
  `60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`. Weder unter `10_AKTIV/` noch
  sonst irgendwo wurde ein `.git`-Ordner gefunden (Stand 2026-06-13).
- `/graphify .` auf diesem Repo ergab: 1.062 Nodes, 1.383 Edges,
  116 Communities; `graphify-out/{graph.html,GRAPH_REPORT.md,graph.json}`
  liegen lokal vor (nicht im Git-Repo, by design).

**Annahmen / unbestätigt (Stand letzter Audit, evtl. veraltet):**
- `.obsidian/` existiert in `Obsidian/` noch nicht (zuletzt geprüft: nicht
  vorhanden) — muss vor Vault-Skill-Installation einmal in Obsidian-App
  geöffnet werden. **In der heutigen Sitzung nicht erneut geprüft.**
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
- **(Überholt durch Schritt 13, dann durch Schritt 19 final entschieden)**
  Dokument A/B schlug ursprünglich vor, den ersten Test-Code-Root auf dieses
  Setup-Repo selbst (`60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`) zu legen.
  Schritt 13 wollte stattdessen ein echtes Arbeitsprojekt verwenden — aber
  da im gesamten Workplace kein zweites Git-Repo existiert (siehe Fakten
  oben), wurde **final doch dieses Repo als erster Code-Root verwendet**,
  mit Erfolg (1.062 Nodes / 1.383 Edges).
- **Erledigt:**
  `/Users/jessenikoi/Workplace/10_AKTIV/01_Campus_Sparbuch/06_WP_LISTINGPRO_REVIEW_24C`
  wurde geprüft — **kein** `.git`, keine Code-Dateien. Ungeeignet, kein
  weiterer Bedarf, diesen Pfad zu prüfen.
- **`~/Local Sites/...` (App "Local", WordPress-Staging) bleibt
  unangetastet** — wird nicht verschoben, nicht als Code-Root verwendet,
  nicht Teil von `Workplace`. Grund: "Local" verwaltet seine Site-Pfade
  über eine eigene Konfiguration/Datenbank; manuelles Verschieben würde die
  Site-Registrierung zerstören.
- **Langfristiges Strukturziel (neu):** `Workplace` soll der einzige Ort
  sein, an dem KI-Tools (Claude Code, Codex, Graphify, Obsidian, Memory-
  Dateien) operieren. Übrige Mac-Bereiche (inkl. "Local") bleiben getrennt.
  Für die aktuelle Aufgabe (ersten Graphify-Lauf durchführen) ist dafür
  **kein Verschieben von Dateien nötig** — der gewählte Code-Root
  (`06_WP_LISTINGPRO_REVIEW_24C`, falls verifiziert) liegt bereits innerhalb
  von `Workplace`.

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

**Auf dem Mac erledigt (Sitzung vom 2026-06-13):**
- ✅ Repo geklont nach `60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`, Branch
  ausgecheckt.
- ✅ `graphify` installiert, `command -v graphify` funktioniert.
- ✅ Dry-Run von `setup-graphify-workplace.sh` erfolgreich.
- ✅ Echter Lauf erfolgreich (`graphify install` für `claude` + `codex`).
- ✅ `/graphify .` erfolgreich: 1.062 Nodes, 1.383 Edges, 116 Communities,
  `graphify-out/{graph.html,GRAPH_REPORT.md,graph.json}` vorhanden.

**Noch NICHT erledigt:**
- `.obsidian/` im Vault initialisiert — Status unbekannt, nicht in dieser
  Sitzung geprüft.
- `AGENTS.md` / `00_STEUERUNG/HAUPTINDEX.md` im Workplace-Root gelesen —
  noch nicht geschehen (Schritt 2 aus Abschnitt 5, alte Zählung).
- Optionaler Obsidian-Export (`--obsidian --obsidian-dir ...`) — offen,
  geplant für morgigen Praxistest.
- Lokale Übersichtsdatei
  `60_DEV_AGENTEN_TOOLS/02_Claude/Graphify_Obsidian_Setup/UEBERSICHT_GRAPHIFY_OBSIDIAN.md`
  (laut Dokument A/B Abschnitt 15) — bewusst auf morgen verschoben.
- Abnahmeprotokoll (Dokument B Abschnitt 16) — bewusst auf morgen
  verschoben.
- Untersuchung der wiederholten `PostToolUse:*: hook error`-Meldungen in
  der lokalen Session — nicht blockierend, aber noch nicht angeschaut.
- Zweites Git-Repo für ein "echtes" Arbeitsprojekt anlegen/initialisieren
  (falls für den Praxistest gewünscht) — offen.

## 5. Nächste Schritte (Praxistest, geplant für die nächste Sitzung)

Die technische Grundinstallation ist **abgeschlossen und erfolgreich
getestet** (siehe Abschnitt 2, Schritt 19, und Abschnitt 4). Die nächste
Sitzung ist ein **Praxistest**: funktioniert das Setup auch im echten
Alltag (Obsidian, mehrere Tools, echtes Projekt)?

**Empfohlene Reihenfolge für die nächste (lokale) Sitzung:**

1. **Graph anschauen:** `graphify-out/graph.html` im Browser öffnen,
   `GRAPH_REPORT.md` von Claude zusammenfassen lassen — macht der Graph
   inhaltlich Sinn?
2. **`.obsidian/`-Status klären:** prüfen, ob `Obsidian/.obsidian/`
   existiert. Falls nicht: Vault einmal in der Obsidian-App öffnen, dann
   `--skip-obsidian-skills` weglassen und das Setup-Skript erneut laufen
   lassen (idempotent — bestehende Dateien werden nicht überschrieben).
3. **Optionaler Obsidian-Export testen:**
   `/graphify . --obsidian --obsidian-dir <Vault>/10_PROJEKTE/<Projekt>`
   (genauen Parameter-Namen vorher mit `graphify --help` / Skill-Doku
   gegenprüfen) — prüfen, ob kuratierte Notizen im Vault ankommen.
4. **`AGENTS.md` / `00_STEUERUNG/HAUPTINDEX.md`** im Workplace-Root lesen
   lassen (noch offen aus der Erstanleitung).
5. **Zweites Repo / echtes Projekt (optional):** Falls Jesse ein echtes
   Arbeitsprojekt als Code-Root nutzen will, muss dafür zuerst ein
   `.git`-Repo angelegt/initialisiert werden (`git init` in einem
   Projektordner unter `60_DEV_AGENTEN_TOOLS/`). Dann denselben Ablauf
   (Dry-Run → echter Lauf → `/graphify .`) mit `--code-root <neuer Pfad>`
   wiederholen.
6. **Hook-Fehler untersuchen (optional, niedrige Priorität):**
   `.claude/settings.json` auf PostToolUse-Hooks prüfen, die die
   wiederholten `hook error`-Meldungen verursachen.
7. **Abschluss-Doku (Schritte 9/10 aus der vorherigen Zählung):** lokale
   Übersichtsdatei + Abnahmeprotokoll — falls gewünscht, am Ende der
   nächsten Sitzung.

**Meine Empfehlung:** Schritt 1+2 zuerst (kurz, klärt ob Obsidian-Teil
überhaupt nötig ist), dann je nach Ergebnis Schritt 3. Schritt 5 (echtes
Projekt als zweites Repo) nur, wenn Jesse das explizit will — ist kein
Blocker für "funktioniert das Setup grundsätzlich".

**Offene Rückfragen an Jesse:**

1. **Echtes Projekt als zweiter Code-Root:** Gibt es ein Arbeitsprojekt,
   das Jesse als Git-Repo unter `60_DEV_AGENTEN_TOOLS/` anlegen möchte, um
   Graphify darauf laufen zu lassen? Oder reicht für jetzt das
   `claude-code`-Repo als Dauer-Testobjekt?
2. **`--platform codex`:** Soll Codex tatsächlich denselben Code-Root
   verwenden wie Claude, oder arbeitet Codex an einem anderen Projekt
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

### Dry-Run-Befehl (Schritt 6, nach erfolgreichem Klon + Verifikation, im Repo-Verzeichnis)

Hinweis: `--code-root` zeigt hier auf den **verifizierten Projekt-Code-Root**
(Schritt 3), NICHT auf den Klon-Pfad des Setup-Repos selbst. Beispiel mit dem
aktuellen Kandidaten:

```bash
chmod +x scripts/setup-graphify-workplace.sh

./scripts/setup-graphify-workplace.sh \
  --workspace-root "/Users/jessenikoi/Workplace" \
  --vault "/Users/jessenikoi/Workplace/Obsidian" \
  --code-root "/Users/jessenikoi/Workplace/10_AKTIV/01_Campus_Sparbuch/06_WP_LISTINGPRO_REVIEW_24C" \
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
