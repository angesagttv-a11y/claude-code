# Übersicht: Graphify + Obsidian + Claude Code im Workplace

Diese Datei fasst alles zusammen, was in diesem Repo für die Kombination
**Graphify (Wissensgraph)** + **Obsidian (kuratiertes "zweites Gehirn")** +
**Claude Code (aktiver Agent)** in deinem bestehenden, nummerierten
Workplace (`/Users/jessenikoi/Workplace`, anonymisiert als
`<WORKSPACE_ROOT>`) erstellt wurde - inklusive Status, Use-Case und
Gebrauchsanleitung.

## 0. Status: Was ist umgesetzt - und was nicht?

| Was | Status | Wo |
|---|---|---|
| Konzept/Hybridmodell dokumentiert | ✅ erledigt | `docs/workplace-graphify-obsidian-setup.md` |
| Entscheidungstabelle "wo kommt was hin" | ✅ erledigt | `docs/workplace-graphify-obsidian-setup.md` (Abschnitt 4) |
| Multi-Agent-Plan (Claude/Codex/Manus) | ✅ erledigt | `docs/workplace-graphify-obsidian-setup.md` (Abschnitt 7) |
| Lauffähiges Setup-Skript | ✅ erledigt | `scripts/setup-graphify-workplace.sh` |
| Templates (`.graphifyignore`, `PROJEKT.md`, Vault-Übersicht) | ✅ erledigt | `docs/workplace-setup/templates/` |
| Erweiterter Safety Guard (6 gesperrte Bereiche + Workspace-Root) | ✅ erledigt | `scripts/setup-graphify-workplace.sh` (`guard_forbidden_path`) |
| Skript getestet (Syntax, Dry-Run, erweiterter Guard, Idempotenz) | ✅ erledigt | in dieser Sandbox |
| **Ausführung auf deinem echten Mac/Workplace** | ❌ **noch offen** | siehe Abschnitt 4 |
| Graphify tatsächlich auf einen Code-Root laufen lassen (`/graphify .`) | ❌ noch offen | dein Mac |
| Obsidian-Vault in Obsidian geöffnet/initialisiert (`.obsidian/`) | ❌ noch offen | dein Mac |
| Obsidian-Skills im Vault installiert | ❌ noch offen | dein Mac |
| PR auf GitHub erstellt | ⏸️ bewusst nicht gemacht | Repo bleibt privater Backup-/Sync-Mechanismus |

**Kurz gesagt:** Die Planung, Doku und das Werkzeug sind fertig und liegen
im Branch `claude/graphify-install-setup-5y5u3r`. Die eigentliche
**Ausführung in deinem echten `Workplace`-Ordner** ist noch nicht passiert -
das kann ich von hier aus nicht (isolierte Sandbox, kein Zugriff auf deinen
Mac). Das ist der letzte Schritt, den du (oder eine lokale Claude-Code-Session
auf deinem Mac) noch machen musst (siehe Abschnitt 4).

## 1. Use-Case: Wofür ist das Ganze?

Du hast einen organisch gewachsenen, nummerierten Workplace
(`00_..`, `10_AKTIV`, `20_..`, ..., `60_DEV_AGENTEN_TOOLS`, `Obsidian/`, ...)
mit:

- **Projektankern** in `10_AKTIV/<Projekt_X>/` (operative Landkarten mit
  `PROJEKT.md`, `00_Eingang/`, Reviews) - **keine** Code-Repos.
- Einem **Obsidian-Vault** unter `Obsidian/` für kuratiertes Dauer-Wissen
  (`10_PROJEKTE`, `40_ENTSCHEIDUNGEN`, `50_OFFENE_FRAGEN`, `60_PROZESSE_SOPS`, ...).
- Einem **Dev-Bereich** `60_DEV_AGENTEN_TOOLS/`, in dem echte Code-Repos für
  verschiedene Agenten (Claude, Codex, Manus, ...) liegen oder verlinkt sind.

**Ziel:** Diese drei Werkzeuge sinnvoll verzahnen, ohne die bestehende
Struktur zu zerstören oder alles in ein "Graphify-Monorepo" zu verwandeln:

- **Graphify** baut pro Code-Root einen Wissensgraphen (`graph.html`,
  `GRAPH_REPORT.md`, `graph.json`) - hilft Claude Code (und anderen Agenten),
  große Codebasen schnell zu verstehen, statt alles zu grep'en.
- **Obsidian** bleibt der Ort für **verdichtetes** Wissen (Entscheidungen,
  Projektstände, SOPs) - kein Rohablageort für jeden Graphify-Lauf.
- **Claude Code** (und Codex, Manus, ...) arbeiten in den Code-Roots, nutzen
  Graphify-Output als Kontext und verlinken wichtige Erkenntnisse zurück in
  den Vault.

**Faustregeln (immer gültig):**
- `graphify-out/` bleibt **immer projektlokal** im jeweiligen Code-Root.
- Graphify läuft **pro Code-Root**, niemals über den ganzen Workspace.
- `30_PRIVAT/` und ähnliche sensible Bereiche bleiben außen vor.
- `10_AKTIV/<Projekt_X>/PROJEKT.md` bleibt unverändert - kein Graphify direkt
  darauf.

## 2. Dateien in diesem Repo (Branch `claude/graphify-install-setup-5y5u3r`)

```text
docs/
├── workplace-graphify-obsidian-setup.md   # Konzept-Doku (Hybridmodell, Entscheidungsbaum, Multi-Agent-Plan)
└── workplace-setup/
    ├── README.md                          # Kurzanleitung zum Skript
    ├── UEBERSICHT.md                      # diese Datei
    └── templates/
        ├── graphifyignore.template        # Vorlage für .graphifyignore
        ├── PROJEKT.md                     # Vorlage für Projektanker (10_AKTIV/<Projekt_X>/)
        └── projekt-uebersicht.md          # Vorlage für Vault-Notiz (Obsidian/10_PROJEKTE/<Projekt_X>/)
scripts/
└── setup-graphify-workplace.sh            # ausführbares Setup-Skript
```

| Datei | Zweck |
|---|---|
| `docs/workplace-graphify-obsidian-setup.md` | **Konzept**: Hybridmodell-Diagramm, Entscheidungstabelle, Schritt-für-Schritt pro Projekt, Leitplanken, Multi-Agent-Plan (Claude/Codex/Manus) |
| `docs/workplace-setup/README.md` | Kurzanleitung speziell für das Skript |
| `scripts/setup-graphify-workplace.sh` | Installiert Graphify (+ ggf. Codex/andere Plattformen), legt `.graphifyignore` an, installiert Obsidian-Skills im Vault - idempotent, mit `--dry-run` |
| `docs/workplace-setup/templates/*.md` | Vorlagen zum Kopieren in `10_AKTIV/...` bzw. `Obsidian/10_PROJEKTE/...` |

## 3. Gebrauchsanleitung

### Schritt 1: Repo auf deinen Mac holen

```bash
git clone <repo-url> ~/dev/claude-code   # falls noch nicht vorhanden
cd ~/dev/claude-code
git checkout claude/graphify-install-setup-5y5u3r
git pull
```

### Schritt 2: Vault einmal in Obsidian öffnen (falls noch nicht geschehen)

Obsidian öffnen → "Open folder as vault" → `<WORKSPACE_ROOT>/Obsidian`
auswählen. Dadurch entsteht `.obsidian/` automatisch. **Das muss vor dem
Skript passieren**, sonst bricht das Skript beim Vault-Schritt ab.

### Schritt 3: Dry-Run gegen einen Code-Root

Wähle ein Projekt aus `60_DEV_AGENTEN_TOOLS/`, z.B. dein Codex-Projekt.
Mit `--workspace-root` aktivierst du zusätzlich den Schutz "Workspace-Root
selbst darf kein Ziel sein" (siehe Abschnitt 5):

```bash
./scripts/setup-graphify-workplace.sh \
    --workspace-root "$HOME/Workplace" \
    --vault     "$HOME/Workplace/Obsidian" \
    --code-root "$HOME/Workplace/60_DEV_AGENTEN_TOOLS/<dein-projekt>" \
    --platform claude --platform codex \
    --dry-run
```

Prüfe die Ausgabe - sie zeigt jeden Schritt, ohne etwas zu schreiben. Zeigt
`--code-root` oder `--vault` auf einen gesperrten Bereich (siehe Abschnitt 5),
bricht das Skript sofort mit `ABBRUCH: ...` ab.

### Schritt 4: Echt ausführen

```bash
./scripts/setup-graphify-workplace.sh \
    --workspace-root "$HOME/Workplace" \
    --vault     "$HOME/Workplace/Obsidian" \
    --code-root "$HOME/Workplace/60_DEV_AGENTEN_TOOLS/<dein-projekt>" \
    --platform claude --platform codex
```

Das Skript:
1. installiert `graphifyy` via `uv` (falls nicht vorhanden),
2. registriert den Graphify-Skill projektlokal für `claude` und `codex`,
3. legt `.graphifyignore` im Code-Root an (Vorlage anpassen!),
4. installiert die Obsidian-Skills (kepano/obsidian-skills) **nur** im Vault
   unter `Obsidian/.claude/skills/`.

### Schritt 5: Wissensgraph erzeugen

Im Code-Root, mit Claude Code:

```bash
cd "$HOME/Workplace/60_DEV_AGENTEN_TOOLS/<dein-projekt>"
/graphify .
```

→ erzeugt `graphify-out/{graph.html, GRAPH_REPORT.md, graph.json, cache/}`.

### Schritt 6 (optional): Export in den Vault

Für eine kuratierte Spiegelung im Vault:

```bash
/graphify . --obsidian --obsidian-dir "$HOME/Workplace/Obsidian/10_PROJEKTE/<Projekt_X>/graph"
```

### Schritt 7: Templates verwenden

- **Neuer Projektanker** (`10_AKTIV/<Projekt_X>/PROJEKT.md`):
  Kopiere `docs/workplace-setup/templates/PROJEKT.md` und fülle es aus.
- **Vault-Übersicht** (`Obsidian/10_PROJEKTE/<Projekt_X>/`):
  Kopiere `docs/workplace-setup/templates/projekt-uebersicht.md`, verlinke
  auf `graph/` (aus Schritt 6) und auf den Projektanker aus `10_AKTIV/`.

### Wiederholen für weitere Projekte

Schritte 3-7 pro Code-Root wiederholen. Das Skript ist idempotent - mehrfaches
Ausführen überschreibt nichts Bestehendes.

## 4. Was als Nächstes ansteht (auf deinem Mac, nicht hier)

1. Repo pullen, Vault in Obsidian öffnen.
2. Skript einmal mit `--dry-run` gegen ein erstes Projekt aus
   `60_DEV_AGENTEN_TOOLS/` laufen lassen, Ausgabe prüfen.
3. Echt ausführen, `.graphifyignore` ggf. anpassen.
4. `/graphify .` im Code-Root ausführen.
5. Vault-Übersichtsnotiz aus dem Template anlegen und verlinken.
6. Bei Bedarf für weitere Projekte/Code-Roots wiederholen.

Details und Hintergründe stehen in
[`../workplace-graphify-obsidian-setup.md`](../workplace-graphify-obsidian-setup.md).

## 5. Harte Regeln (Safety Guard im Skript)

`scripts/setup-graphify-workplace.sh` lehnt `--code-root`, `--vault` und
`--workspace-root` automatisch ab, wenn der Pfad einem dieser Ordnernamen
entspricht oder darunter liegt - egal an welcher Stelle im Baum:

```text
30_PRIVAT
PRIVAT
20_FIRMEN_FINANZEN_RECHT
50_MEDIEN_ASSETS
70_ARCHIV_INDEX
10_AKTIV
```

Zusätzlich: Wird `--workspace-root <pfad>` gesetzt (empfohlen, siehe Schritt 3),
lehnt das Skript auch den Workspace-Root selbst als Ziel-/Scan-Root ab.

Damit gilt technisch erzwungen:
- Kein Scan auf den gesamten Workspace.
- Kein Scan auf `10_AKTIV` (Projektanker sind keine Code-Roots).
- Keine Schreibvorgänge in `30_PRIVAT`, `20_FIRMEN_FINANZEN_RECHT`,
  `50_MEDIEN_ASSETS`, `70_ARCHIV_INDEX`.
- `graphify-out/` bleibt projektlokal im jeweiligen Code-Root.
- Obsidian erhält nur kuratierte Inhalte bzw. kontrollierte Exporte in
  explizit angegebene Zielordner (`--obsidian-dir`).

Getestet (in dieser Sandbox, mit anonymisierter Beispielstruktur): erlaubter
Code-Root läuft im Dry-Run durch; alle acht gesperrten Pfade
(Workspace-Root, `10_AKTIV`, `30_PRIVAT`, `30_PRIVAT/Test`,
`20_FIRMEN_FINANZEN_RECHT`, `20_FIRMEN_FINANZEN_RECHT/Test`,
`50_MEDIEN_ASSETS`, `70_ARCHIV_INDEX`) brechen mit `ABBRUCH: ...` ab.
