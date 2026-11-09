# Übersicht: Graphify + Obsidian + Claude Code im Workplace

Diese Datei fasst alles zusammen, was in diesem Repo für die Kombination
**Graphify (Wissensgraph)** + **Obsidian (kuratiertes "zweites Gehirn")** +
**Claude Code (aktiver Agent)** in deinem bestehenden, nummerierten
Workplace (`/Users/jessenikoi/Workplace`, anonymisiert als
`<WORKSPACE_ROOT>`) erstellt wurde - inklusive Status, Use-Case und
Gebrauchsanleitung.

## 0. Status: Was ist umgesetzt - und was nicht?

*(Letzter Abgleich: 2026-07-24, siehe `SESSION_HANDOVER_2026-07-24.md` für den vollständigen, konsolidierten Verlauf seit dem 19. Juli. Diese Sitzungsreihe war bewusst Stabilisierung statt Tool-Ausbau.)*

> ⚠️ **Warnhinweis (neu, 2026-07-19):** Graphify darf **niemals** direkt auf
> `10_AKTIV` (oder Umbenennungen davon) laufen — `10_AKTIV` ist reine
> Projektsteuerung/Aktenlandkarte, kein Scan-Root. Der Safety Guard im
> Skript blockt das technisch bereits (siehe Abschnitt 5), aber auch
> **manuell/außerhalb des Skripts niemals `/graphify 10_AKTIV/...` aufrufen.**
> Falls in `10_AKTIV/.../graphify-out/` bereits Alt-Artefakte aus früheren,
> ungeregelten Läufen liegen: **nicht löschen**, nur als Alt-Artefakte
> behandeln und nicht mehr aktualisieren.

| Was | Status | Wo |
|---|---|---|
| Konzept/Hybridmodell dokumentiert | ✅ erledigt | `docs/workplace-graphify-obsidian-setup.md` |
| Entscheidungstabelle "wo kommt was hin" | ✅ erledigt | `docs/workplace-graphify-obsidian-setup.md` (Abschnitt 4) |
| Multi-Agent-Plan (Claude/Codex/Manus) | ✅ erledigt | `docs/workplace-graphify-obsidian-setup.md` (Abschnitt 7) |
| Lauffähiges Setup-Skript | ✅ erledigt | `scripts/setup-graphify-workplace.sh` |
| Templates (`.graphifyignore`, `PROJEKT.md`, Vault-Übersicht) | ✅ erledigt | `docs/workplace-setup/templates/` |
| Erweiterter Safety Guard (6 gesperrte Bereiche + Workspace-Root) | ✅ erledigt | `scripts/setup-graphify-workplace.sh` (`guard_forbidden_path`) |
| Skript getestet (Syntax, Dry-Run, erweiterter Guard, Idempotenz) | ✅ erledigt | in der Sandbox |
| Skript real ausgeführt (erster Code-Root) | ✅ erledigt (2026-06-13) | `60_DEV_AGENTEN_TOOLS/02_Claude/claude-code` |
| Graphify auf Code-Root gelaufen (`/graphify .`) | ✅ erledigt (2026-06-13) | 1.062 Nodes, 1.383 Edges, 116 Communities |
| Graphify-Skill installiert (claude + codex) | ✅ erledigt (2026-06-13) | `.claude/skills/graphify/`, `.codex/skills/graphify/` |
| `graphify-out/` aus Git ausgeschlossen | ✅ erledigt | `.gitignore` |
| Obsidian-Vault in Obsidian geöffnet/initialisiert (`.obsidian/`) | ✅ **bestätigt (2026-06-13/14, per Screenshot)** | Vault ist aktiv geladen, voll ausgebaute Struktur vorhanden |
| Obsidian-Skills — praktischer Funktionstest im echten Vault | ✅ **bestanden, per Screenshot verifiziert (2026-07-23)** | `00_INBOX/test-skill-check.md` — Properties, Wikilink und Callout korrekt gerendert in der echten Obsidian-App |
| `graphify-out/` nicht versioniert, Repo sauber | ✅ **bestätigt (2026-07-19)** | `.gitignore` enthält `graphify-out/`, keine getrackten Graphify-Dateien im Repo |
| Safety Guard an reale Workplace-Struktur angepasst | ✅ **bereinigt & verifiziert (2026-07-23)** | `scripts/setup-graphify-workplace.sh` — echte Ordnernamen bestätigt, Alt-Namen entfernt |
| Obsidian-Backup-Strategie geklärt (offizielle Doku ausgewertet) | ✅ **Empfehlung fertig (2026-07-19), Ausführung auf dem Mac noch offen** | siehe Abschnitt 6, `templates/obsidian-vault.gitignore.template` |
| Plaud per MCP anbinden | ✅ **offizieller Weg recherchiert (2026-07-19), Einrichtung noch offen** | siehe Abschnitt 7 — offizieller Plaud-MCP-Server existiert |
| WhatsApp-Import in Vault ("Mozepp") | ✅ **Workflow fertig (2026-07-19), Ausführung auf dem Mac noch offen** | bereits manuell exportierte Chats → `80_ARCHIV/Chat-Archiv/WhatsApp/`, Prompt in `SESSION_HANDOVER_2026-07-19.md` Abschnitt 9 |
| Zweiter Code-Root (echtes Arbeitsprojekt) | ❌ noch offen | `10_AKTIV/` enthält aktuell keine Git-Repos |
| Obsidian mobile Sync (iPhone) | ⏸️ **bewusst zurückgestellt** | Nutzer-Entscheidung 2026-06-13 |
| Zusatz-Skills `qmd` (semantische Suche) und `obsidian-second-brain` | ⏸️ **bewusst zurückgestellt** | `qmd` braucht globales npm-Paket + Vault-Indexing; `obsidian-second-brain` installiert per `curl \| bash` von ungeprüftem Drittanbieter-Repo — beides erst nach expliziter Freigabe |
| PR auf GitHub erstellt | ⏸️ bewusst nicht gemacht | Repo bleibt privater Backup-/Sync-Mechanismus |

**Kurz gesagt:** Planung, Doku, Werkzeug, der erste echte Graphify-Durchlauf
UND jetzt auch der praktische Funktionstest im echten Vault sind erledigt.
Der Vault ist nachweislich initialisiert und bereits deutlich ausgebaut
(siehe "Bestätigte reale Vault-Struktur" unten). **Diese Sitzung
(2026-07-19/23) war bewusst Stabilisierung statt Ausbau:** Repo-Hygiene
geprüft (sauber), Safety Guard defensiv erweitert und dann gegen die reale
Struktur bereinigt, Doku korrigiert, Obsidian-Skill-Funktion real im Vault
bewiesen. Übrig bleiben nur noch kleine, nicht blockierende Detailfragen
(siehe Warnhinweis) sowie: zweiter Code-Root, Obsidian-Git-Strategie
ausführen, optionale Zusatz-Skills.

> ⚠️ **Warnhinweis (Stand 2026-07-23) — Obsidian-Skill-Frage vollständig
> abgeschlossen:**
> 1. **Obsidian-Skill-Funktion: zweifelsfrei bewiesen, per Screenshot.** Der
>    Nutzer hat die echte Obsidian-App gezeigt: die Test-Notiz
>    `00_INBOX/test-skill-check.md` rendert korrekt getypte Properties
>    (`date` als echtes Datumsfeld, `tags` als Tag-Pill), einen echten
>    klickbaren Wikilink und einen grün gerenderten Callout mit
>    Häkchen-Icon. Das ist direkter visueller Beweis, unabhängig davon,
>    welche App/welcher Mechanismus die Datei geschrieben hat — die
>    vorherige Detailfrage (Claude Code vs. Claude-Desktop-App) ist damit
>    gegenstandslos.
>    **Neu entdeckt (nicht dringend, nur zur Kenntnis):** `00_INBOX`
>    enthält bereits einen Ordner `WhatsApp_Extrakte/`, `01_DAILY_NOTES`
>    bereits `Plaud_Transkripte/` — beide Integrationen scheinen in
>    irgendeiner Form schon vorbereitet/genutzt zu werden, anders als der
>    Stand in Abschnitt 7 vermuten ließ. Bei Gelegenheit mit dem Nutzer
>    klären, was dort bereits liegt.
> 2. **Workplace-Umbenennung: bestätigt und bereinigt (2026-07-23).** `ls
>    /Users/jessenikoi/Workplace/` auf dem echten Mac zeigt die reale,
>    aktuelle Struktur:
>    ```text
>    00_INBOX  02_KONTEXT_SITZUNGEN  10_AKTIV  20_WISSEN  30_AGENTS
>    40_KUNDEN_PARTNER  50_FIRMEN_FINANZEN_RECHT  55_PRIVAT
>    60_MEDIA_INDEX  70_DEV_TOOLS  80_ARCHIV  99_SYSTEM
>    AGENTS.md  Daily  Obsidian  README.md
>    ```
>    Die neuen Namen aus dem externen Plan waren korrekt, die alten
>    (`20_FIRMEN_FINANZEN_RECHT`, `30_PRIVAT`, `50_MEDIEN_ASSETS`,
>    `70_ARCHIV_INDEX`, `60_DEV_AGENTEN_TOOLS`) existieren nicht mehr — der
>    Workplace wurde tatsächlich umbenannt/neu strukturiert. Safety Guard in
>    `scripts/setup-graphify-workplace.sh` ist entsprechend bereinigt (siehe
>    Abschnitt 5). **Eine Behauptung aus dem externen Plan war falsch:**
>    Obsidian liegt direkt unter `Workplace/Obsidian` (Top-Level), **nicht**
>    unter `20_WISSEN/Obsidian` wie dort vermutet.
>    **Neu und noch nicht eingeordnet:** `00_INBOX`, `02_KONTEXT_SITZUNGEN`,
>    `20_WISSEN`, `30_AGENTS`, `40_KUNDEN_PARTNER`, `99_SYSTEM`, `Daily`,
>    `AGENTS.md`, `README.md` — existieren jetzt zusätzlich, waren in keiner
>    bisherigen Doku beschrieben. Offene Rückfrage unten.
> 3. **Offene Rückfragen an den Nutzer — beide jetzt beantwortet
>    (Stand 2026-11-08):**
>    ~~Ist `40_KUNDEN_PARTNER` schützenswert und gehört in den Safety
>    Guard?~~ → **Ja, bestätigt (2026-10-10).** `40_KUNDEN_PARTNER` ist
>    Teil der `FORBIDDEN_BASENAMES`-Liste, getestet (Dry-Run blockt
>    korrekt). ~~Unter welchem genauen Unterpfad liegt der
>    `claude-code`-Code-Root jetzt unter `70_DEV_TOOLS/`?~~ → **Bestätigt
>    (2026-11-08, per Manus verifiziert):**
>    `/Users/jessenikoi/Workplace/70_DEV_TOOLS/02_Claude/claude-code` —
>    Remote und Branch gegengeprüft, stimmen exakt
>    (`github.com/angesagttv-a11y/claude-code`,
>    `claude/graphify-install-setup-5y5u3r`).

### Obsidian-Skills — Installationsdetails (2026-06-14)

Installiert per manuellem Kopieren (robuste, versionsunabhängige Methode,
nachdem `/plugin install` in einer falschen Umgebung fehlschlug):

```bash
mkdir -p ~/.claude/skills
git clone --depth 1 https://github.com/kepano/obsidian-skills.git /tmp/obsidian-skills-src
cp -r /tmp/obsidian-skills-src/skills/* ~/.claude/skills/
rm -rf /tmp/obsidian-skills-src
```

→ liegt jetzt in `~/.claude/skills/{obsidian-markdown,obsidian-bases,json-canvas,obsidian-cli,defuddle}`
(**User-Ebene**, nicht projekt-lokal) - Claude Code erkennt sie in jedem
Projekt nach einem Neustart der Sitzung.

**Bewusst NICHT installiert:**
- `qmd` (aus `breferrari/obsidian-mind`) - semantische Vault-Suche, würde ein
  globales `npm install -g @tobilu/qmd` plus einen Bootstrap-Indexierungslauf
  über den ganzen Vault erfordern.
- `eugeniughelbur/obsidian-second-brain` - 44-Kommando-System, offizieller
  Installer ist ein `curl | bash` von einem ungeprüften Drittanbieter-Repo.

Beides nur nach expliziter Freigabe nachrüsten.

### Bestätigte reale Vault-Struktur (2026-06-13/14, per Screenshot verifiziert)

Der Vault ist bereits deutlich reifer als die generischen Templates
angenommen hatten:

```text
00_INBOX/
01_DAILY_NOTES/
10_PROJEKTE/
├── claude-code/              # Notiz zum ersten Graphify-Code-Root existiert bereits
└── KI_Output_System/
    └── 2026-06-14_notebooklm_projekt...
20_BEREICHE/
30_RESSOURCEN/
40_ENTSCHEIDUNGEN/
50_OFFENE_FRAGEN/
60_PROZESSE_SOPS/
70_AGENTEN_MEMORY/             # geteiltes KI-Gedächtnis über alle Agenten hinweg
80_ARCHIV/
└── Chat-Archiv/
    ├── ChatGPT/_ANLEITUNG
    ├── Claude-Code/
    ├── Claude-Web/_ANLEITUNG
    ├── Codex/
    ├── Manus/
    ├── WhatsApp/
    ├── INDEX
    └── README
90_TEMPLATES/
99_SYSTEM/
00_START_HIER
```

Das deckt sich gut mit unserem Konzept (`10_PROJEKTE/<Projekt>` für
Vault-Übersichtsnotizen, siehe `templates/projekt-uebersicht.md`) und
erfüllt bereits das langfristige Ziel eines geteilten Gedächtnisses
(`70_AGENTEN_MEMORY/`, `80_ARCHIV/Chat-Archiv/<Tool>/`). Für neue Projekte
reicht es, `templates/projekt-uebersicht.md` nach `10_PROJEKTE/<Projekt_X>/`
zu kopieren und dort mit dem jeweiligen Code-Root/Graphify-Output zu verlinken.

## 1. Use-Case: Wofür ist das Ganze?

Du hast einen organisch gewachsenen, nummerierten Workplace
(`00_..`, `10_AKTIV`, `20_..`, ..., `70_DEV_TOOLS`, `Obsidian/`, ...)
mit:

- **Projektankern** in `10_AKTIV/<Projekt_X>/` (operative Landkarten mit
  `PROJEKT.md`, `00_Eingang/`, Reviews) - **keine** Code-Repos.
- Einem **Obsidian-Vault** unter `Obsidian/` für kuratiertes Dauer-Wissen
  (`10_PROJEKTE`, `40_ENTSCHEIDUNGEN`, `50_OFFENE_FRAGEN`, `60_PROZESSE_SOPS`, ...).
- Einem **Dev-Bereich** `70_DEV_TOOLS/`, in dem echte Code-Repos für
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

Wähle ein Projekt aus `70_DEV_TOOLS/`, z.B. dein Codex-Projekt.
Mit `--workspace-root` aktivierst du zusätzlich den Schutz "Workspace-Root
selbst darf kein Ziel sein" (siehe Abschnitt 5):

```bash
./scripts/setup-graphify-workplace.sh \
    --workspace-root "$HOME/Workplace" \
    --vault     "$HOME/Workplace/Obsidian" \
    --code-root "$HOME/Workplace/70_DEV_TOOLS/<dein-projekt>" \
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
    --code-root "$HOME/Workplace/70_DEV_TOOLS/<dein-projekt>" \
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
cd "$HOME/Workplace/70_DEV_TOOLS/<dein-projekt>"
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

Schritte 1-4 (Repo pullen, Skript, `/graphify .`) sind für den ersten
Code-Root bereits erledigt (2026-06-13). **Bestätigter aktueller Pfad
(2026-11-08, per Manus verifiziert):**
`/Users/jessenikoi/Workplace/70_DEV_TOOLS/02_Claude/claude-code`
(Remote `github.com/angesagttv-a11y/claude-code`, Branch
`claude/graphify-install-setup-5y5u3r` — stimmen exakt). Vault ist
initialisiert, Obsidian-Skills sind per Screenshot im echten Vault
funktionsfähig bewiesen (2026-07-24), die reale Workplace-Struktur ist
verifiziert (siehe Abschnitt 0). **Stand 2026-11-08:** Der Safety Guard
ist vollständig, beide offenen Rückfragen aus der Stabilisierungs-Runde
sind beantwortet. Kurzfassung, in dieser Reihenfolge:

1. Obsidian-Git-/Backup-Strategie umsetzen (Empfehlung + Template stehen
   bereits in Abschnitt 6, `git init` im Vault noch nicht ausgeführt).
2. Vault-Übersichtsnotiz aus dem Template anlegen und verlinken.
3. **Die Graphify→Obsidian-Bridge jetzt real testen** — bisher nie
   ausgeführt, Pfad ist jetzt bekannt:
   ```bash
   cd /Users/jessenikoi/Workplace/70_DEV_TOOLS/02_Claude/claude-code
   /graphify . --obsidian --obsidian-dir "$HOME/Workplace/Obsidian/10_PROJEKTE/claude-code/graph"
   ```
4. Erst danach: zweiter echter Code-Root (nicht `10_AKTIV`, sondern ein
   echtes Git-/Dev-Repo unter `70_DEV_TOOLS/`) — Schritte 3-7 aus
   Abschnitt 3 wiederholen.
5. Erst danach: optionale Zusatz-Skills (`qmd`, `obsidian-second-brain`)
   neu bewerten, falls gewünscht.
6. WhatsApp-Import bewusst zurückgestellt (Nutzer-Entscheidung
   2026-11-08) — Workflow bleibt fertig in Abschnitt 7, aber nicht
   priorisiert.

Details und Hintergründe stehen in
[`../workplace-graphify-obsidian-setup.md`](../workplace-graphify-obsidian-setup.md).

## 5. Harte Regeln (Safety Guard im Skript)

`scripts/setup-graphify-workplace.sh` lehnt `--code-root`, `--vault` und
`--workspace-root` automatisch ab, wenn der Pfad einem dieser Ordnernamen
entspricht oder darunter liegt - egal an welcher Stelle im Baum:

```text
PRIVAT
55_PRIVAT
50_FIRMEN_FINANZEN_RECHT
60_MEDIA_INDEX
80_ARCHIV
10_AKTIV
40_KUNDEN_PARTNER
```

*(Stand 2026-10-10: `40_KUNDEN_PARTNER` vom Nutzer bestätigt und
aufgenommen, getestet per Dry-Run. Davor, Stand 2026-07-23: bereinigt und
gegen die reale Workplace-Struktur verifiziert, siehe Warnhinweis in
Abschnitt 0. Die alte Namensgeneration aus der Sitzung vom 2026-06-13
existiert nicht mehr und wurde entfernt. "PRIVAT" bleibt als generischer
Fallback ohne Nummernpräfix.)*

Zusätzlich: Wird `--workspace-root <pfad>` gesetzt (empfohlen, siehe Schritt 3),
lehnt das Skript auch den Workspace-Root selbst als Ziel-/Scan-Root ab.

Damit gilt technisch erzwungen:
- Kein Scan auf den gesamten Workspace.
- Kein Scan auf `10_AKTIV` (Projektanker sind keine Code-Roots) — **auch
  nicht manuell/außerhalb des Skripts, siehe Warnhinweis Abschnitt 0.**
- Keine Schreibvorgänge in den oben gelisteten gesperrten Bereichen.
- `graphify-out/` bleibt projektlokal im jeweiligen Code-Root.
- Obsidian erhält nur kuratierte Inhalte bzw. kontrollierte Exporte in
  explizit angegebene Zielordner (`--obsidian-dir`).

Getestet (2026-06-13, in dieser Sandbox, mit anonymisierter Beispielstruktur,
alte Namensliste): erlaubter Code-Root läuft im Dry-Run durch; alle acht
gesperrten Pfade brechen mit `ABBRUCH: ...` ab.

**Erneut getestet (2026-07-23, nach Bereinigung auf die reale
Namensliste):** ein echter gesperrter Name (`50_FIRMEN_FINANZEN_RECHT`)
blockt korrekt im Dry-Run; ein jetzt nicht mehr existenter Alt-Name
(`20_FIRMEN_FINANZEN_RECHT`) blockt zu Recht nicht mehr; ein echter
erlaubter Code-Root unter `70_DEV_TOOLS/` läuft fehlerfrei durch
(`bash -n` Syntaxcheck zusätzlich grün).

**Erneut getestet (2026-10-10, nach Aufnahme von `40_KUNDEN_PARTNER`):**
`40_KUNDEN_PARTNER` blockt korrekt im Dry-Run; ein weiterhin erlaubter
Testpfad unter `70_DEV_TOOLS/` läuft fehlerfrei durch (`bash -n`
Syntaxcheck zusätzlich grün).

## 6. Obsidian — offizielle Doku-Erkenntnisse & Backup-Entscheidung (2026-07-19)

Ausgewertet direkt aus der Quelle der offiziellen Doku
(`github.com/obsidianmd/obsidian-help`, Ordner `en/`; die gerenderte Seite
`obsidian.md/help` blockt automatisierte Zugriffe mit HTTP 403, deshalb
Auswertung über die Repo-Rohdateien). Jede Aussage ist mit der jeweiligen
Quellseite belegt.

### Fakten (aus der offiziellen Doku, mit Quelle)

- **"Syncing ist kein Backup"** — offizielle Aussage aus "Back up your
  Obsidian files". Die Doku nennt zwei (nicht offiziell unterstützte)
  Community-Plugins als typische Lösungen: **Obsidian Git** (Vault als
  Git-Repo versionieren) und **Local Backup** (lokale Ordnerkopien). Genau
  das haben wir mit diesem Setup-Repo ohnehin vor — bestätigt also unseren
  Ansatz, ist aber kein offiziell "empfohlenes" Feature, sondern
  Community-Praxis.
- **`.obsidian/workspace.json` und `.obsidian/workspaces.json`** speichern
  nur das aktuelle Fenster-/Tab-Layout, ändern sich bei jedem Notiz-Öffnen
  und sollen laut "How Obsidian stores data" bei Git-Nutzung explizit
  ignoriert werden. → Umgesetzt in
  `templates/obsidian-vault.gitignore.template` (neu, siehe unten).
- **Obsidian Sync** (der offizielle, kostenpflichtige Sync-Dienst) synct
  standardmäßig Notizen + Konfigurationsordner; Bilder/Audio/Video/PDF sind
  per Default selektiv synct, alles andere über einen Schalter; einzelne
  Ordner lassen sich ausschließen ("Sync settings and selective syncing").
  Max. Dateigröße 5 MB (Standard) / 200 MB (Plus); Versionshistorie 1 bzw.
  12 Monate ("Frequently asked questions"). **Wichtig:** die Doku warnt
  ausdrücklich davor, Obsidian Sync **gleichzeitig** mit einem anderen
  Sync-Mechanismus (iCloud, OneDrive, Dropbox, Git) auf demselben Vault
  laufen zu lassen — das führt zu Konflikten/doppelten oder korrupten
  Dateien (FAQ-Seite). **Für uns heißt das konkret: falls ihr je Obsidian
  Sync aktiviert, NICHT zusätzlich Git/iCloud auf denselben Vault-Ordner
  ansetzen.**
- **Mehrgeräte-Nutzung ohne Obsidian Sync**: Die Doku listet iCloud,
  OneDrive, Google Drive, Syncthing und Git/Working Copy als Alternativen
  und warnt konkret: iCloud Drive unter Windows kann Dateien duplizieren/
  korrumpieren; OneDrive/Google Drive können Dateien bei "nur online"-
  Einstellungen unbemerkt "leeren" (sehen für Sync wie gelöscht aus); Google
  Drive/OneDrive haben keinen offiziellen iOS-Support; Git erfordert
  manuelles Push/Pull, kein Auto-Sync ("Sync your notes across devices").
  → **relevant für die zurückgestellte Entscheidung "Obsidian mobile Sync
  (iPhone)"**: falls ihr das später angeht, spricht das eher für Obsidian
  Sync (kostenpflichtig, aber für Multi-Device gebaut) als für einen
  iCloud-Hack.
- **Bases ist ein Core Plugin** (in Obsidian selbst eingebaut, keine
  Community-Plugin-Installation nötig) — reine Markdown-Properties als
  Datenbasis, `.base`-Dateien sind normale Dateien im Vault ("Introduction
  to Bases", "Core plugins"). **Wichtige Klarstellung:** Der Claude-Code-
  Skill `obsidian-bases` (den wir am 2026-06-14 installiert haben) ist etwas
  komplett anderes als das Obsidian-eigene Bases-Feature — der Skill bringt
  nur Claude bei, `.base`-Dateien korrekt zu lesen/schreiben. **Er taucht
  nirgendwo in Obsidian selbst auf** (nicht in "Community Plugins", nicht
  in den Einstellungen) und erfordert nichts, das in der App aktiviert
  werden müsste. Das gilt analog für die anderen 4 installierten Skills
  (`obsidian-markdown`, `json-canvas`, `obsidian-cli`, `defuddle`) — alles
  reine Claude-Code-seitige Fähigkeiten, unabhängig vom Obsidian-Plugin-
  System.
- **Community Plugins** (falls ihr später welche installiert, z.B. das oben
  genannte "Obsidian Git"): erben laut "Plugin security" die vollen
  Zugriffsrechte von Obsidian (Dateizugriff, Internet, Programme starten) —
  die Doku empfiehlt, bei sensiblen Daten die Plugin-Quelle selbst zu
  prüfen, trotz automatisierter Sicherheits-Scans.

### Entscheidung (jetzt getroffen, Ausführung auf dem Mac noch offen)

Damit ist Priorität 2, Punkt 6 aus der Stabilisierungs-Runde
(`SESSION_HANDOVER_2026-07-19.md`) inhaltlich entschieden:

**Der Obsidian-Vault bekommt ein eigenes, separates, privates Git-Repo**
(nicht in diesem `claude-code`-Repo) — konsistent mit der offiziellen
"Obsidian Git"-Community-Praxis. Dafür:

```bash
cd "$HOME/Workplace/Obsidian"
git init
cp <pfad-zu-diesem-repo>/docs/workplace-setup/templates/obsidian-vault.gitignore.template .gitignore
git add .
git commit -m "Initial vault backup"
# Danach: privates Remote-Repo anlegen und pushen (z.B. GitHub privat)
```

**Noch offen (deine Entscheidung):** Soll dieses Vault-Repo zusätzlich auf
GitHub gepusht werden (privat), oder reicht ein rein lokales Git-Repo als
Backup? Und: falls ihr Obsidian Sync ohnehin schon nutzt oder erwägt —
dann lieber **nur** Sync ODER Git, nicht beides parallel (siehe Warnung
oben).

## 7. Externe Quellen anbinden: Plaud & WhatsApp (2026-07-19)

### Plaud (Sprachaufnahmen/Transkripte) — empfohlener Weg vorhanden

Plaud (Plaud Note/NotePin) hat einen **offiziellen MCP-Server + CLI**,
gebaut explizit für Claude Code/Claude Desktop, ChatGPT, Cursor u.a. —
Aufnahmen auflisten, Roh-/geglättete Transkripte und KI-Zusammenfassungen
direkt abrufen:
- Ankündigung: https://www.plaud.ai/blogs/news/introducing-plaud-mcp-and-cli
- Support-Doku: https://support.plaud.ai/hc/en-us/articles/57751078986265-Plaud-MCP
- Developer-Plattform (REST-API + Webhooks, falls mehr Kontrolle nötig):
  https://docs.plaud.ai/ , https://dev.plaud.ai/

**Empfehlung:** offiziellen Plaud-MCP-Server zuerst nutzen (kein
Drittanbieter-Vertrauen nötig). **Muss lokal/interaktiv eingerichtet
werden** (OAuth/API-Key) — aus dieser Sandbox nicht möglich, genau wie
schon beim `/plugin install`-Fall. Mach das in einer lokalen Claude-Code-
Sitzung auf dem Mac oder über die claude.ai-Connector-Einstellungen.

Landeplatz im Vault (Vorschlag, analog zur bestehenden Struktur): ein neuer
Ordner z.B. `70_AGENTEN_MEMORY/Plaud/` oder `80_ARCHIV/Plaud-Transkripte/`
für kuratierte Auszüge — **nicht** die komplette Rohaufnahmen-Historie
direkt in den Vault spiegeln (gleiche Faustregel wie bei Graphify: Vault
bekommt nur Verdichtetes).

### WhatsApp ("Mozepp-Backup") — Korrektur (2026-07-19, später am selben Tag)

> ⏸️ **Bewusst zurückgestellt (2026-11-08):** Der Nutzer hat entschieden,
> dieses Thema vorerst nicht weiterzuverfolgen. Workflow/Prompt unten
> bleiben gültig und einsatzbereit, sind aber **nicht priorisiert**.

**Richtigstellung:** Der Nutzer hat seine WhatsApp-Chats bereits manuell
exportiert und liegen als Dateien in einem Ordner auf dem Mac. Es geht
**nicht** um eine Live-Anbindung/MCP-Bridge, sondern nur darum, die
bereits vorhandenen Export-Dateien als saubere Notizen in den Obsidian-
Vault zu bekommen ("Wissenserweiterung"). Die MCP-/ToS-Risiko-Recherche
unten bleibt als Hintergrundwissen stehen (falls später doch mal eine
Live-Anbindung erwogen wird), ist für die aktuelle Aufgabe aber **nicht
relevant** — siehe stattdessen den konkreten Import-Workflow im
Session-Handover, Abschnitt 9.

Ursprüngliche Recherche zur Einordnung (offiziell vs. inoffiziell):

- **Kein offizieller Weg:** Meta bietet keine API, mit der eine
  Privatperson programmatisch auf die eigene Chat-Historie zugreifen kann.
  Die "WhatsApp Business Platform / Cloud API" ist strikt für
  Business-Messaging-Automatisierung gedacht, nicht für persönliche
  Verlaufs-Extraktion — eine Migration der eigenen Nummer dorthin kann
  sogar bestehende Chats verlieren. Die offizielle "Request Account Info"-
  Funktion exportiert nur Metadaten, **keine** Nachrichteninhalte.
- **Manueller offizieller Export:** In-App "Chat exportieren" erzeugt eine
  `.txt`-Datei (+ optional `.zip` mit Medien) — pro Chat, gedeckelt auf
  ca. 40.000 Nachrichten ohne Medien bzw. 10.000 mit Medien; ältere
  Nachrichten werden stillschweigend abgeschnitten.
- **Inoffizielle MCP-Server existieren** (z.B. `jlucaso1/whatsapp-mcp-ts`,
  `ericporres/whatsapp-mcp-server`), basieren aber auf reverse-engineerten
  WhatsApp-Web-Bibliotheken (Baileys) mit einer dauerhaft eingeloggten
  "Linked Device"-Session deines echten Accounts.
- ⚠️ **Echtes Risiko, nicht nur theoretisch:** WhatsApps Nutzungsbedingungen
  (Messaging Guidelines, Business Terms) verbieten explizit "inoffizielle
  Clients". Meta erkennt das automatisiert (nicht nur bei Beschwerden) —
  auf GitHub dokumentierte Fälle zeigen echte Account-Sperr-Warnungen bei
  Baileys/whatsmeow-Nutzern. Sperren sind laut den recherchierten Berichten
  meist **dauerhaft, ohne Widerspruchsmöglichkeit** — auch bei rein
  lesendem, privatem Gebrauch, weil schon die Linked-Device-Session selbst
  das auffällige Verhalten ist.

**Meine aktive Empfehlung:** **Nicht** den inoffiziellen Live-MCP-Bridge-Weg
nehmen — das Risiko (dauerhafte Account-Sperre) steht in keinem Verhältnis
zum Nutzen bei einem reinen Backup-/Archivierungs-Zweck. Stattdessen der
risikoarme Weg, der ohnehin zum bestehenden Vault-Konzept passt:

1. Regelmäßig "Chat exportieren" (.txt/.zip) für die relevanten Chats.
2. Dateien ablegen unter dem **bereits existierenden** Vault-Ordner
   `80_ARCHIV/Chat-Archiv/WhatsApp/` (bestätigt in der Vault-Struktur,
   siehe oben — der Ordner ist offenbar genau dafür angelegt).
3. Optional ein lokales Parse-Tool (z.B. `whatstk` oder
   `obsidian-whatsapp-backup-importer`) nutzen, um die `.txt`-Exporte in
   sauber formatierte Obsidian-Notizen umzuwandeln, statt Rohtext liegen
   zu lassen.
4. Claude Code liest diese Dateien dann ganz normal als Vault-Inhalt (dafür
   braucht es kein MCP — die Datei liegt ja schon im Vault, den Claude über
   die Obsidian-Skills sowieso lesen kann).

**Offene Rückfrage:** Reicht dir der manuelle Export-Workflow (Schritte
1-4), oder ist dir das zu manuell und du willst das Risiko des
Live-Bridge-Wegs bewusst in Kauf nehmen? Das ist deine Entscheidung, nicht
meine — ich empfehle aber klar den risikoarmen Weg.

## 8. Vorfall: Vault-Datenverlust durch Daily-Refresh (2026-11-08/09) — gelöst

**Was passierte:** Eine lokale Sitzung führte statt des vollen
`/graphify .`-Skill-Laufs (der nicht verfügbar war) die leichtgewichtigen
CLI-Befehle `graphify update .` + `graphify export obsidian --dir
.../10_PROJEKTE/claude-code/graph` aus — der gleiche Ablauf wie der
automatisierte tägliche 09:00-Refresh. Der neue, kleinere Export (344
Nodes/473 Edges/27 Communities statt der vollen KI-Extraktion) ersetzte
den bestehenden Export im Vault-Ordner: von 3.672 Dateien auf 27
Community-Notizen + `index.md` + `graph.canvas`.

**Entdeckt dabei (bisher unbekannte Infrastruktur):**
- Ein automatisierter täglicher Refresh existiert bereits:
  Skript `scripts/graphify-daily-refresh.sh`, Zeitplan via
  `~/Library/LaunchAgents/com.jessenikoi.graphify-daily.plist`.
- Der Obsidian-Vault ist **bereits seit Längerem ein eigenes Git-Repo**
  (unabhängig von diesem `claude-code`-Repo), mit eigener Commit-Historie:
  `7395db8` (99_SYSTEM/SETUP-STATUS.md), `6a6710e` ("Graphify Full System
  2026-07-05 — graph.html + GRAPH_REPORT je Projekt und Agenten-System" —
  deutet auf **mehrere** bereits graphifizierte Code-Roots hin, nicht nur
  `claude-code`), `93a18dc` (Daily-Notes/Templates-Config), `29e1071`
  ("GPT-Export-Extrakte (851 Gespräche) + SOP Plaud-Transkript-Workflow" —
  **Plaud hat also schon eine fertige SOP**, nicht nur unsere Recherche von
  Abschnitt 7), `da6370d` ("Initial vault backup").
- **Wichtige Korrektur zu Abschnitt 6:** Die Aussage "Vault-Git-Backup noch
  nicht ausgeführt" war **falsch** — es existierte bereits.

**Lösung (durchgeführt und verifiziert, 2026-11-08/09):**
1. Datenrettung: `git checkout -- 10_PROJEKTE/claude-code/graph/` im
   Vault-Repo — die Löschungen waren nur unstaged, der letzte Commit hatte
   noch alles. Verifiziert: `ls ... | wc -l` → **3700** (3.672 alte + 27
   neue + `index.md`) — **vollständige Wiederherstellung bestätigt.**
2. Automatisierten Refresh pausiert:
   `launchctl unload ~/Library/LaunchAgents/com.jessenikoi.graphify-daily.plist`
   — lief ohne Fehler. **Läuft heute Nacht nicht mehr automatisch.**

**Noch offen:** `99_SYSTEM/SETUP-STATUS.md` im Vault lesen, um den
gesamten unbekannten Entwicklungsstrang (Multi-Projekt-Graphify, GPT-Export,
Plaud-SOP) mit diesem Repo-Stand abzugleichen — unsere Doku hier ist an
mehreren Stellen hinter der Realität auf dem Mac zurück. Danach entscheiden,
ob/wie der Daily-Refresh wieder aktiviert wird (z.B. mit automatischem
Commit nach jedem Lauf, damit sowas nicht nochmal passieren kann, ohne
dass es sofort auffällt).

### `99_SYSTEM/SETUP-STATUS.md` gelesen (2026-11-09) — Ursache gefunden + weiterer Kontext

**Ursache des Vorfalls, bereits im Juni dokumentiert, aber nicht befolgt:**
Die Datei warnt wörtlich: *"Graphify-Gotcha: `graphify update .` ist
AST-only und überschreibt die semantische Ebene → `/graphify . --update`
nutzen oder Graph aus Git wiederherstellen."* Genau `graphify update .`
(statt `/graphify . --update`) wurde beim Vorfall benutzt — der
`scripts/graphify-daily-refresh.sh`-Automatismus macht vermutlich
denselben Fehler jede Nacht. **Weder dieses Skript noch
`scripts/archive_chats.py` existieren in diesem Git-Repo** (per `find`
bestätigt) — beide leben nur lokal auf dem Mac, nie committet, genau wie
vorher schon `.claude/skills/graphify/`.

**Weiterer bisher unbekannter Kontext aus der Datei:**
- **Dritte Memory-Schicht entdeckt:** `claude-mem` unter `~/.claude-mem`
  (22 MB) — automatischer Cross-Session-Recall im Hintergrund
  (`mem-search`). War uns komplett unbekannt, parallel zu Obsidian-Vault
  und Graphify.
- **Zusätzliches Backup bereits vorhanden:** Kopie auf externem Volume
  `/Volumes/AGS/Obsidian_Vault_Backup_2026-06-12` (per `ditto`
  aktualisierbar) — Time Machine nur als 🟡 Zusatznetz markiert, nicht
  vollständig verifiziert.
- **Cloud-Sync war Stand 12.06. bewusst offen gelassen** (GitHub privat,
  Obsidian-Git-Plugin oder Dropbox — noch keine Entscheidung), passt zur
  offenen Rückfrage in Abschnitt 6 dieses Dokuments.
- **Konvention bestätigt:** `70_AGENTEN_MEMORY` nur destillierte Regeln,
  keine Roh-Chats — Roh-Chats gehören nach `80_ARCHIV/Chat-Archiv`, exakt
  wie wir das für WhatsApp in Abschnitt 7 schon vorgeschlagen hatten.
- Verweist auf zwei weitere, hier noch nicht gelesene Dateien:
  `00_START_HIER.md` und
  `02_KONTEXT_SITZUNGEN/TUTORIAL_Graphify-Obsidian-Workflow.md`.

**Nächster Schritt, bevor der Daily-Refresh wieder aktiviert wird:** Inhalt
von `scripts/graphify-daily-refresh.sh` ansehen und bestätigen, ob er
tatsächlich `graphify update .` statt `/graphify . --update` aufruft —
falls ja, korrigieren, bevor `launchctl load` wieder läuft.

### Script-Bug bestätigt und gefixt (2026-11-09)

Bestätigt per `cat` auf dem Mac: Das Skript rief exakt `graphify update .`
gefolgt von `graphify export obsidian --dir ...` auf — bewusst so gebaut,
um täglich keine KI-Credits zu verbrauchen ("nur AST, gratis" laut
Kommentar im Original), aber genau das zerstörte jede Nacht die
semantische Ebene, bevor der Export sie in den Vault schrieb.

**Nebenbefund:** Das Skript zeigt auf `20_WISSEN/Obsidian/...` als
Vault-Pfad und hat dort nachweislich erfolgreich geschrieben — damit ist
geklärt, dass `Workplace/Obsidian` und `Workplace/20_WISSEN/Obsidian`
derselbe Ort sind (vermutlich Symlink). Die frühere Sorge dazu (Abschnitt
0, Skill-Test-Vorfall) ist damit aufgelöst, kein Fehler.

**Fix (fertig, jetzt erstmals versioniert):** `scripts/
graphify-daily-refresh.sh` im Repo macht nur noch den kostenlosen lokalen
AST-Refresh, **kein automatischer Obsidian-Export mehr**. Ein voller,
semantisch reicher Export braucht weiterhin eine interaktive
Claude-Code-Sitzung (`/graphify . --update`, kostet Credits) — bewusst
nicht automatisierbar, muss manuell/bewusst ausgelöst werden.

**Noch zu tun (auf dem Mac):**
1. Korrigierte Fassung vom Repo aufs lokale Skript kopieren (überschreiben).
2. `launchctl load ~/Library/LaunchAgents/com.jessenikoi.graphify-daily.plist`
   — Automatismus wieder aktivieren, jetzt sicher.
3. Optional: `99_SYSTEM/SETUP-STATUS.md` im Vault um den Fix ergänzen,
   damit die dortige Doku nicht erneut hinter der Realität zurückbleibt.
