# Übersicht: Graphify + Obsidian + Claude Code im Workplace

Diese Datei fasst alles zusammen, was in diesem Repo für die Kombination
**Graphify (Wissensgraph)** + **Obsidian (kuratiertes "zweites Gehirn")** +
**Claude Code (aktiver Agent)** in deinem bestehenden, nummerierten
Workplace (`/Users/jessenikoi/Workplace`, anonymisiert als
`<WORKSPACE_ROOT>`) erstellt wurde - inklusive Status, Use-Case und
Gebrauchsanleitung.

## 0. Status: Was ist umgesetzt - und was nicht?

*(Letzter Abgleich: 2026-07-19, siehe `SESSION_HANDOVER_2026-07-19.md` für Details. Diese Sitzung war bewusst eine Stabilisierungs-Runde, kein weiterer Tool-Ausbau.)*

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
| Obsidian-Skills (`kepano/obsidian-skills`, 5 Skills) global installiert | ⚠️ **kopiert (2026-06-14), Erkennung durch Claude Code lokal auf dem Mac noch nicht sauber verifiziert** | manuell nach `~/.claude/skills/` kopiert (User-Ebene) — siehe Warnhinweis unten |
| `graphify-out/` nicht versioniert, Repo sauber | ✅ **bestätigt (2026-07-19)** | `.gitignore` enthält `graphify-out/`, keine getrackten Graphify-Dateien im Repo |
| Safety Guard an gemeldete Umbenennung angepasst (Superset, unverifiziert) | ✅ **erledigt (2026-07-19)** | `scripts/setup-graphify-workplace.sh` — siehe Warnhinweis unten |
| Zweiter Code-Root (echtes Arbeitsprojekt) | ❌ noch offen | `10_AKTIV/` enthält aktuell keine Git-Repos |
| Obsidian mobile Sync (iPhone) | ⏸️ **bewusst zurückgestellt** | Nutzer-Entscheidung 2026-06-13 |
| Zusatz-Skills `qmd` (semantische Suche) und `obsidian-second-brain` | ⏸️ **bewusst zurückgestellt** | `qmd` braucht globales npm-Paket + Vault-Indexing; `obsidian-second-brain` installiert per `curl \| bash` von ungeprüftem Drittanbieter-Repo — beides erst nach expliziter Freigabe |
| PR auf GitHub erstellt | ⏸️ bewusst nicht gemacht | Repo bleibt privater Backup-/Sync-Mechanismus |

**Kurz gesagt:** Planung, Doku, Werkzeug und der erste echte Graphify-
Durchlauf sind erledigt. Der Vault ist nachweislich initialisiert und
bereits deutlich ausgebaut (siehe "Bestätigte reale Vault-Struktur" unten).
**Diese Sitzung (2026-07-19) war bewusst Stabilisierung statt Ausbau:**
Repo-Hygiene geprüft (sauber), Safety Guard defensiv erweitert, Doku
korrigiert. Weiterhin offen und **priorisiert vor jedem weiteren Schritt**:
die Obsidian-Skill-Erkennung lokal verifizieren (siehe Warnhinweis) und die
gemeldete Workplace-Umbenennung gegen die reale Mac-Struktur bestätigen.
Danach erst: zweiter Code-Root, Obsidian-Git-Strategie, optionale
Zusatz-Skills.

> ⚠️ **Warnhinweis (neu, 2026-07-19) — zwei offene Verifikationen:**
> 1. **Obsidian-Skill-Erkennung:** Der `cp`-Befehl vom 2026-06-14 lief ohne
>    Fehler, aber eine später gemeldete Skill-Tool-Liste enthielt die 5
>    Obsidian-Skills nicht, und laut Nutzeraussage lag auf der Platte in
>    `~/.claude/skills/` angeblich nur `session-start-hook`. **Nicht
>    abschließend geklärt** — siehe `SESSION_HANDOVER_2026-07-19.md`,
>    Abschnitt 5, Diagnose-Befehle. **Vor produktivem Obsidian-Einsatz mit
>    Claude Code zwingend auf dem Mac neu verifizieren.**
> 2. **Workplace-Umbenennung:** Ein externes Planungsdokument (2026-07-19)
>    nennt neue Ordnernamen (`50_FIRMEN_FINANZEN_RECHT`, `55_PRIVAT`,
>    `60_MEDIA_INDEX`, `80_ARCHIV`, `70_DEV_TOOLS`, `20_WISSEN/Obsidian`),
>    die von den bisher dokumentierten Namen (`20_FIRMEN_FINANZEN_RECHT`,
>    `30_PRIVAT`, `50_MEDIEN_ASSETS`, `70_ARCHIV_INDEX`,
>    `60_DEV_AGENTEN_TOOLS`) abweichen. **Diese neuen Namen sind nicht gegen
>    die reale Mac-Struktur verifiziert** — der Safety Guard führt seit
>    2026-07-19 vorsorglich beide Namensgenerationen als Superset (sicherer,
>    aber möglicherweise unnötig breit). Auf dem Mac `ls
>    /Users/jessenikoi/Workplace/` ausführen und melden, welche Namen aktuell
>    real existieren, damit die Liste bereinigt werden kann.

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

Schritte 1-4 (Repo pullen, Skript, `/graphify .`) sind für den ersten
Code-Root (`claude-code` selbst) bereits erledigt (2026-06-13). Vault ist
initialisiert, Obsidian-Skills sind kopiert. **Stand 2026-07-19: bewusste
Stabilisierungs-Priorität, siehe `SESSION_HANDOVER_2026-07-19.md` für die
vollständige Reihenfolge.** Kurzfassung, in dieser Reihenfolge:

1. **Zuerst:** Obsidian-Skill-Erkennung lokal verifizieren (Claude Code
   komplett neu starten, dann `ls -la ~/.claude/skills/` UND prüfen, ob die
   5 Skills im Skill-Tool auftauchen — siehe Warnhinweis in Abschnitt 0).
2. **Dann:** Reale Workplace-Ordnernamen bestätigen (`ls
   /Users/jessenikoi/Workplace/`) und den Safety Guard in Abschnitt 5
   entsprechend bereinigen (aktuell bewusst breiter Superset).
3. Obsidian-Git-/Backup-Strategie festlegen (Vault versionieren? Was
   ausschließen — `.obsidian/workspace.json`, Roh-Archive, große Exporte,
   Graphify-HTMLs/Caches?).
4. Vault-Übersichtsnotiz aus dem Template anlegen und verlinken.
5. Erst danach: zweiter echter Code-Root (nicht `10_AKTIV`, sondern ein
   echtes Git-/Dev-Repo) — Schritte 3-7 aus Abschnitt 3 wiederholen.
6. Erst danach: optionale Zusatz-Skills (`qmd`, `obsidian-second-brain`)
   neu bewerten, falls gewünscht.

Details und Hintergründe stehen in
[`../workplace-graphify-obsidian-setup.md`](../workplace-graphify-obsidian-setup.md).

## 5. Harte Regeln (Safety Guard im Skript)

`scripts/setup-graphify-workplace.sh` lehnt `--code-root`, `--vault` und
`--workspace-root` automatisch ab, wenn der Pfad einem dieser Ordnernamen
entspricht oder darunter liegt - egal an welcher Stelle im Baum:

```text
30_PRIVAT
PRIVAT
55_PRIVAT
20_FIRMEN_FINANZEN_RECHT
50_FIRMEN_FINANZEN_RECHT
50_MEDIEN_ASSETS
60_MEDIA_INDEX
70_ARCHIV_INDEX
80_ARCHIV
10_AKTIV
```

*(Stand 2026-07-19: bewusst als Superset aus zwei Namensgenerationen geführt
— alte Namen aus der Sitzung vom 2026-06-13 plus neu gemeldete, noch nicht
gegen die reale Mac-Struktur verifizierte Namen. Siehe Warnhinweis in
Abschnitt 0. Sobald bestätigt, welche Namen aktuell real existieren, kann
die Liste bereinigt werden.)*

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

**Erneut getestet (2026-07-19, nach Erweiterung der Namensliste):** ein neu
hinzugefügter gesperrter Name (`60_MEDIA_INDEX`) blockt korrekt im Dry-Run;
ein weiterhin erlaubter Testpfad läuft weiterhin fehlerfrei durch
(`bash -n` Syntaxcheck zusätzlich grün).
