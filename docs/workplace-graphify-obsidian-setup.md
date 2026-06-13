# Graphify + Obsidian + Claude Code in einem bestehenden Workplace

Dieser Leitfaden beschreibt, wie sich **Graphify** (Knowledge-Graph-Tool),
**Obsidian** (kuratiertes "zweites Gehirn") und **Claude Code** kombinieren
lassen, wenn bereits ein strukturierter, nummerierter Workspace existiert
(z.B. nach einem PARA-ähnlichen Schema mit `00_..`, `10_..`, `20_..` usw.)
und dieser **nicht** als leerer Entwickler-Ordner behandelt werden soll.

Alle Pfade/Namen unten sind Platzhalter. Ersetze sie durch die tatsächlichen
Ordnernamen in deinem Workspace.

## 1. Die drei Komponenten

- **Claude Code**: der aktive Agent. Führt Aufgaben aus, beantwortet Fragen,
  nutzt vorhandene Wissensgraphen/Vaults als Kontext.
- **Graphify**: liest einen Ordner (Code, Docs, PDFs, Bilder, Video) und baut
  daraus einen Knowledge Graph (`graph.html`, `GRAPH_REPORT.md`, `graph.json`).
  Erkennt Konzepte, Beziehungen und Communities.
- **Obsidian**: Speicherort für **kuratiertes** Dauer-Wissen (Entscheidungen,
  Projektstände, SOPs, offene Fragen) - kein Rohablageort für jeden
  Graphify-Lauf.

## 2. Grundprinzip: Hybridmodell statt Monorepo

Ein bestehender, organisch gewachsener Workspace hat meist:

- **Projektanker** (z.B. `10_AKTIV/<Projekt_X>/` mit `PROJEKT.md`,
  `00_Eingang/`, Review-Ordnern) - das sind **keine** Code-Repos, sondern
  operative Projektlandkarten.
- Einen **kuratierten Obsidian-Vault** (z.B. `Obsidian/` mit `00_INBOX`,
  `10_PROJEKTE`, `40_ENTSCHEIDUNGEN`, `50_OFFENE_FRAGEN`, `60_PROZESSE_SOPS`, ...).
- Einen **Dev-/Tools-Bereich** (z.B. `60_DEV_AGENTEN_TOOLS/`), wo tatsächliche
  Code-Repos (Git) liegen oder verlinkt werden.

**Empfehlung:** Diesen bestehenden Workspace NICHT pauschal zu einem
Graphify-Monorepo machen. Stattdessen:

```text
<WORKSPACE_ROOT>/
├── 10_AKTIV/<Projekt_X>/
│   ├── PROJEKT.md                  # strategischer Projektanker (bleibt wie es ist)
│   ├── 00_Eingang/                 # Kontext/Importquellen (bleibt wie es ist)
│   └── <code-root>/                # NUR falls hier wirklich Code liegt
│       ├── .git/
│       ├── .graphifyignore
│       └── graphify-out/           # von /graphify erzeugt - projektlokal!
│           ├── graph.html
│           ├── GRAPH_REPORT.md
│           ├── graph.json
│           └── cache/
├── 60_DEV_AGENTEN_TOOLS/
│   └── <Code-Repos / GitHub-Clones>/
└── Obsidian/                        # kuratierter Master-Vault (bleibt wie es ist)
    ├── 10_PROJEKTE/                  # verdichtete Projektstände
    ├── 40_ENTSCHEIDUNGEN/
    ├── 50_OFFENE_FRAGEN/
    └── 60_PROZESSE_SOPS/
```

Faustregeln:
- `graphify-out/` gehört **immer** in den jeweiligen Code-Root, niemals in
  den Obsidian-Vault oder in `10_AKTIV` direkt.
- Graphify läuft **pro Code-Root**, nicht über den gesamten Workspace
  (sonst landen Finanz-, Privat-, Medien- und Archivbereiche unnötig im Graph).
- Der Obsidian-Vault bekommt nur **verdichtete** Ergebnisse (Entscheidungen,
  Zusammenfassungen), nicht den rohen Graphify-Export.

## 3. Installation

```bash
# Graphify (Python-Tool + Claude-Skill)
uv tool install graphifyy && graphify install

# Obsidian-Skills für Claude Code (optional, für Vault-Bearbeitung)
# In den .claude-Ordner IM VAULT-ROOT kopieren:
git clone https://github.com/kepano/obsidian-skills /tmp/obsidian-skills
mkdir -p <VAULT_ROOT>/.claude/skills
cp -r /tmp/obsidian-skills/skills/* <VAULT_ROOT>/.claude/skills/
```

`graphify install` registriert den Skill global unter `~/.claude/skills/graphify`
und trägt `/graphify` in `~/.claude/CLAUDE.md` ein. Die Obsidian-Skills werden
**vault-lokal** installiert (`<VAULT_ROOT>/.claude/skills/`), damit sie nur
greifen, wenn Claude Code im Vault arbeitet.

## 4. Entscheidungsbaum: Wo kommt was hin?

| Frage | Antwort | Konsequenz |
|---|---|---|
| Ist es Quellcode/Repo eines Projekts? | Ja | Eigener Code-Root mit `.git`, `.graphifyignore`, `graphify-out/` |
| Ist es eine Doku-/Notizsammlung zu einem Thema? | Ja | `/graphify <pfad> --obsidian --obsidian-dir <VAULT_ROOT>/10_PROJEKTE/<projekt>/graph` |
| Ist es eine fertige Entscheidung/ein SOP? | Ja | Manuell (oder per Claude) als Markdown in `Obsidian/40_ENTSCHEIDUNGEN/` bzw. `60_PROZESSE_SOPS/` |
| Ist es ein Projektanker mit `PROJEKT.md`? | Ja | Bleibt unverändert in `10_AKTIV/`, KEIN Graphify direkt darauf |
| Offene Frage/unklarer Punkt? | Ja | `Obsidian/50_OFFENE_FRAGEN/` |

## 5. Schritt-für-Schritt für ein Projekt

1. Code-Root identifizieren oder anlegen (z.B. unter `60_DEV_AGENTEN_TOOLS/<Projekt_X>/`).
2. `.graphifyignore` anlegen (vendor/, node_modules/, dist/, Medien-Ordner ausschließen).
3. Im Code-Root: `/graphify .` → erzeugt `graphify-out/`.
4. Für den Vault-Export mit eigenem Zielordner:
   ```
   /graphify . --obsidian --obsidian-dir <VAULT_ROOT>/10_PROJEKTE/<Projekt_X>/graph
   ```
5. Im Vault unter `10_PROJEKTE/<Projekt_X>/` eine kurze Übersichtsnotiz
   anlegen, die auf `graph/` verlinkt und den `PROJEKT.md`-Anker aus
   `10_AKTIV/<Projekt_X>/` referenziert (Brücke zwischen Projektlandkarte
   und Vault, ohne Daten zu duplizieren).

## 6. Wichtige Leitplanken

- **Keine** globale `CLAUDE.md` oder `.claude`-Konfiguration ungefragt in
  privaten/sensiblen Bereichen (z.B. einem `30_PRIVAT`-Ordner) ablegen oder
  von dort ableiten.
- Vor dem ersten Graphify-Lauf: bestehende Root-Regeln (z.B. eine
  `AGENTS.md` oder ein Masterindex im Workspace-Root) lesen und beachten.
- Obsidian-Vault erst öffnen/initialisieren (Ordner in Obsidian als Vault
  hinzufügen, `.obsidian/` entsteht dabei automatisch), bevor weitere
  Vault-Automatisierung (Skills, Templates) aufgesetzt wird.
- Graphify niemals über den kompletten Workspace laufen lassen - immer auf
  einen begrenzten Code-Root zeigen.

### Technisch erzwungener Safety Guard (`scripts/setup-graphify-workplace.sh`)

`guard_forbidden_path()` im Setup-Skript lehnt `--code-root`, `--vault` und
`--workspace-root` automatisch ab, wenn der (normalisierte) Pfad einem dieser
Ordnernamen entspricht oder darunter liegt:

```text
30_PRIVAT
PRIVAT
20_FIRMEN_FINANZEN_RECHT
50_MEDIEN_ASSETS
70_ARCHIV_INDEX
10_AKTIV
```

Wird zusätzlich `--workspace-root <pfad>` (oder die Umgebungsvariable
`GRAPHIFY_WORKSPACE_ROOT`) gesetzt, lehnt der Guard auch den Workspace-Root
selbst als Ziel-/Scan-Root ab - so kann Graphify nicht versehentlich über den
gesamten Workspace laufen. `10_AKTIV` ist als Sammelordner für Projektanker
ebenfalls gesperrt (Projektanker sind keine Code-Roots, siehe Abschnitt 4).

## 7. Umsetzungsplan: Mehrere Agenten (Claude / Codex / Manus) auf demselben Code-Root

Wenn in `60_DEV_AGENTEN_TOOLS/` mehrere Agenten (z.B. Claude Code, Codex,
Manus) am selben Code-Root arbeiten, installiert `graphify install` den
Skill standardmäßig **global** unter `~/.claude/skills/graphify`. Für
projekt-/agentenspezifische Setups gibt es zusätzliche Flags:

```bash
# Skill nur für dieses Projekt installieren (statt global):
graphify install --project

# Skill für eine andere Plattform installieren (z.B. Codex statt Claude):
graphify install --project --platform codex
```

`--platform` unterstützt u.a.: `claude`, `codex`, `windows`, `gemini`,
`cursor`, `antigravity`, `kiro`, `devin`, `opencode`, `aider`, `copilot`,
`amp`, `kilo`, `pi`, `trae`, `trae-cn`, `claw`, `hermes`, `codebuddy`,
`kimi`, `droid`. Jede Plattform bekommt ihre eigene Skill-Datei am
plattformtypischen Pfad (z.B. Codex → `.codex/skills/graphify/SKILL.md`,
Claude → `.claude/skills/graphify/SKILL.md`).

**Manus** ist keine in Graphify hinterlegte Plattform. Für einen Code-Root,
an dem Manus arbeitet, am besten `--platform claude` (Standard) verwenden -
Manus kann die erzeugten Artefakte (`graphify-out/graph.json`,
`GRAPH_REPORT.md`) trotzdem lesen, auch ohne eigenen Skill-Eintrag.

### Empfohlene Reihenfolge pro Code-Root

1. Prüfen, welcher/welche Agent(en) in diesem Code-Root tatsächlich
   arbeiten (Claude, Codex, Manus, ...).
2. `.graphifyignore` anlegen.
3. `graphify install --project` (Standard-Skill für Claude, projektlokal)
   - falls Codex denselben Code-Root nutzt: zusätzlich
     `graphify install --project --platform codex`.
4. `/graphify .` ausführen → erzeugt `graphify-out/`.
5. Bei Bedarf zusätzlichen Obsidian-Export für den Vault (siehe Abschnitt 5).

### Obsidian-Skills im Vault installieren (passend zur bestehenden Struktur)

Die kuratierten Vault-Bereiche (`00_INBOX`, `01_DAILY_NOTES`, `10_PROJEKTE`,
`20_BEREICHE`, `30_RESSOURCEN`, `40_ENTSCHEIDUNGEN`, `50_OFFENE_FRAGEN`,
`60_PROZESSE_SOPS`, `70_AGENTEN_MEMORY/<Agent>`, `80_ARCHIV`, `90_TEMPLATES`,
`99_SYSTEM`) bleiben unverändert. Die Obsidian-Skills (Markdown, Bases, JSON
Canvas, CLI, Defuddle aus `kepano/obsidian-skills`) werden **nur**
vault-lokal installiert:

```bash
git clone https://github.com/kepano/obsidian-skills /tmp/obsidian-skills
mkdir -p <VAULT_ROOT>/.claude/skills
cp -r /tmp/obsidian-skills/skills/* <VAULT_ROOT>/.claude/skills/
```

Damit greifen die Skills nur, wenn Claude Code direkt im Vault-Ordner
arbeitet - kein Einfluss auf Code-Roots oder Projektanker.

### Reihenfolge für den Gesamt-Rollout

1. Vault als Obsidian-Vault öffnen (`.obsidian/` wird automatisch erzeugt),
   bevor Skills/Automatisierung hinzukommen.
2. Bestehende `AGENTS.md`/Masterindex im Workspace-Root respektieren - keine
   Änderungen ohne Bezug darauf.
3. Pro Code-Root in `60_DEV_AGENTEN_TOOLS/` (oder wo Code tatsächlich liegt)
   die Schritte aus "Empfohlene Reihenfolge pro Code-Root" durchgehen.
4. Projektanker in `10_AKTIV/<Projekt_X>/` unverändert lassen - kein
   Graphify direkt darauf, höchstens verdichtete Verlinkung aus
   `Obsidian/10_PROJEKTE/<Projekt_X>/` heraus (siehe Abschnitt 5, Schritt 5).
5. `30_PRIVAT/` und ähnliche sensible Bereiche von Graphify- und
   Skill-Installationen ausnehmen, sofern nicht explizit gewünscht.
