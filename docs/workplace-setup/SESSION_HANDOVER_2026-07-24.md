# Projekt-Kontext: Graphify + Obsidian + Claude Code im Workplace
**Datum der Sitzung:** 2026-07-24

---

## 1. Übergeordnetes Ziel

Graphify (Wissensgraph-Tool), Obsidian (kuratiertes "zweites Gehirn") und
Claude Code sollen im bestehenden, organisch gewachsenen Workplace
(`/Users/jessenikoi/Workplace`, macOS, Rechner `Mac-mini-von-Jesse-4`)
kombiniert werden — **ohne** den Workplace zu einem Graphify-Monorepo zu
machen und **ohne** bestehende Strukturen (Projektanker in `10_AKTIV/`,
kuratierter Obsidian-Vault, private/finanzielle/rechtliche/Medien-Bereiche)
zu stören.

Endzustand: Pro echtem Code-Root (Git-Repo unter `70_DEV_TOOLS/`, früher
`60_DEV_AGENTEN_TOOLS/`) kann `/graphify .` einen lokalen Wissensgraphen
(`graphify-out/`) erzeugen, der Claude Code als Kontext dient und optional
kuratiert in den Vault gespiegelt wird (`--obsidian-dir`). Claude Code soll
zusätzlich **auf User-Ebene** (nicht nur projektlokal) mit
Obsidian-spezifischen Skills ausgestattet sein, damit es Vault-Dateien
(Markdown, Bases, Canvas) korrekt lesen/schreiben kann — das ist inzwischen
**per Screenshot bewiesen funktionsfähig** (siehe Abschnitt 2/4). Externe
Wissensquellen (Plaud-Transkripte, WhatsApp-Exporte) sollen perspektivisch
kuratiert in den Vault einfließen, ohne ihn mit Rohdaten zu fluten. Alles
Tooling liegt versioniert in `angesagttv-a11y/claude-code`
(Branch `claude/graphify-install-setup-5y5u3r`) als privater
Backup-/Sync-Mechanismus — bewusst ohne PR.

---

## 2. Zusammenfassung dieser Sitzung

Diese Sitzung schließt an `SESSION_HANDOVER_2026-07-19.md` an (das Dokument
selbst wuchs im Lauf des 19. auf 9 Abschnitte an; die hier beschriebenen
Ereignisse vom 23./24. setzen das fort). Chronologisch:

1. **Kandidaten-Recherche & Empfehlung (fortgesetzt vom 19.):** Drei
   Obsidian-Skill-Repos verglichen (`breferrari/obsidian-mind`,
   `kepano/obsidian-skills`, `eugeniughelbur/obsidian-second-brain`).
   `kepano/obsidian-skills` aktiv empfohlen (offiziell, minimal, kein
   Code-Execution-Risiko); die anderen beiden bewusst zurückgestellt.
2. **Erster Installationsversuch scheiterte:** `/plugin install
   obsidian@obsidian-skills` lief ohne den vorgeschalteten `marketplace
   add`-Schritt und/oder in der falschen Umgebung → Fehler "isn't
   available in this environment".
3. **Manuelle Fallback-Installation** (`git clone` + `cp -r` nach
   `~/.claude/skills/`) auf dem Mac ausgeführt — lief fehlerfrei durch.
4. **Widerspruch entdeckt:** Eine später gemeldete Skill-Tool-Liste (17
   Einträge) enthielt die 5 Obsidian-Skills nicht; Nutzeraussage, auf der
   Platte läge angeblich nur `session-start-hook`. Ursache zunächst unklar.
5. **Diagnose in der Cloud-Sandbox:** `ls -la ~/.claude/skills/` und `ls
   /Users/jessenikoi/Workplace/` versehentlich in DIESER Sandbox statt auf
   dem Mac ausgeführt — zeigte ein komplett anderes, riesiges
   Cowork-Skill-Set (Marketing, Caveman, GSD, ...), das zufällig ähnliche
   Namen enthält. Bestätigte: es gibt mehrere komplett getrennte
   "Umgebungen" (diese Sandbox, der echte Mac, evtl. Claude.ai/Cowork), die
   nicht verwechselt werden dürfen.
6. **Externer Stabilisierungsplan ("ultraplan") erhalten und umgesetzt:**
   Nutzer bestätigte "Ja" zu einem priorisierten Plan (Stabilisierung statt
   Tool-Ausbau). Umgesetzt: Safety Guard defensiv um gemeldete neue
   Ordnernamen erweitert (als Superset, da unverifiziert), Repo-Hygiene
   geprüft (war bereits sauber), Warnhinweis "kein Graphify auf `10_AKTIV`"
   in die Doku aufgenommen.
7. **Offizielle Obsidian-Doku ausgewertet** (`github.com/obsidianmd/
   obsidian-help`, da die gerenderte Seite `obsidian.md/help` HTTP 403
   liefert): Backup-Strategie-Entscheidung getroffen (eigenes privates
   Vault-Git-Repo), `.gitignore`-Template für den Vault erstellt,
   Klarstellung dass die installierten Skills (inkl. `obsidian-bases`)
   unabhängig vom Obsidian-eigenen Plugin-System sind.
8. **Plaud- und WhatsApp-Recherche:** Offizieller Plaud-MCP-Server
   gefunden und empfohlen. Für WhatsApp zunächst (fälschlich) von einer
   gewünschten Live-MCP-Anbindung ausgegangen — Risiko-Recherche ergab:
   kein offizieller Weg für Privatpersonen, inoffizielle MCP-Bridges
   (Baileys) tragen dokumentiertes Risiko dauerhafter Account-Sperren.
9. **Korrektur durch den Nutzer:** WhatsApp-Chats waren bereits manuell
   exportiert, lagen als Dateien auf dem Mac — es ging nur um Import in
   den Vault, nicht um eine Live-Anbindung. Doku korrigiert, konkreter
   Umwandlungs-Prompt für eine lokale Claude-Code-Sitzung erstellt.
10. **Gesamtstatus-Check auf Nutzeranfrage:** Ehrliche Matrix erstellt
    (verifiziert vs. nur dokumentiert). Zwei echte offene Verifikationen
    identifiziert: (a) Skill-Erkennung durch Claude Code, (b) reale
    Workplace-Ordnernamen.
11. **Verifikation (a) — Skill-Dateien:** Echtes `ls -la
    ~/.claude/skills/` auf dem Mac (Terminal, `Mac-mini-von-Jesse-4`)
    bestätigte: alle 5 Ordner (`defuddle`, `json-canvas`, `obsidian-bases`,
    `obsidian-cli`, `obsidian-markdown`) sind real vorhanden, plus
    vorbestehende `higgsfield-*`-Symlinks. Der `cp`-Befehl vom 14.6. hatte
    also funktioniert.
12. **Verifikation (b) — reale Ordnernamen:** Nach einem ersten
    missglückten Versuch (Terminal-Ausgabe wurde versehentlich als
    Befehl zurück ins Terminal gepastet, inkl. eines fehlgeschlagenen
    `chsh`-Passwort-Prompts — harmlos, aber als Hinweis "Ausgabe nicht
    zurück ins Terminal pasten" vermerkt) lieferte ein sauberer Rerun die
    echte Struktur: `00_INBOX`, `02_KONTEXT_SITZUNGEN`, `10_AKTIV`,
    `20_WISSEN`, `30_AGENTS`, `40_KUNDEN_PARTNER`,
    `50_FIRMEN_FINANZEN_RECHT`, `55_PRIVAT`, `60_MEDIA_INDEX`,
    `70_DEV_TOOLS`, `80_ARCHIV`, `99_SYSTEM`, `AGENTS.md`, `Daily`,
    `Obsidian`, `README.md`. Die neuen Namen aus dem externen Plan waren
    korrekt; die alten existieren nicht mehr.
13. **Safety Guard bereinigt und neu getestet:** Alte Namen entfernt,
    echte Namen als finale Liste gesetzt. `bash -n` plus drei gezielte
    Dry-Runs (echter gesperrter Name blockt, nicht mehr existierender
    Alt-Name blockt zu Recht nicht mehr, echter erlaubter Code-Root unter
    `70_DEV_TOOLS/` läuft durch) — alle bestanden.
14. **Praktischer Skill-Funktionstest, Runde 1 (unklar/verdächtig):** Ein
    erster Bericht einer lokalen Sitzung behauptete, den
    `obsidian-markdown`-Skill genutzt zu haben, nannte aber den Pfad
    `20_WISSEN/Obsidian/00_INBOX/` (widerspricht der gerade verifizierten
    echten Struktur — Obsidian liegt Top-Level) und eine verdächtige URL
    (`claude.ai/epitaxy/...`). Als möglicher Cowork-/Browser-Vorgang statt
    echtem Mac-Terminal geflaggt, nicht akzeptiert.
15. **Klärung + Beweis:** Nutzer bestätigte, es sei die "Desktop-App"
    gewesen, und dass die Datei in der echten Obsidian-App sichtbar sei.
    Zur endgültigen Absicherung ein **echter Screenshot** der Obsidian-App
    angefordert und erhalten: `00_INBOX/test-skill-check.md` mit korrekt
    getypten Properties (`date` als Datumsfeld, `tags` als Pill), einem
    echten klickbaren Wikilink und einem grün gerenderten Callout —
    **zweifelsfreier visueller Beweis**, unabhängig davon, welche App
    geschrieben hat.
16. **Neue Beobachtung aus dem Screenshot:** Der Vault enthält bereits
    `00_INBOX/WhatsApp_Extrakte/` und `01_DAILY_NOTES/Plaud_Transkripte/`
    — beide Integrationen scheinen in irgendeiner Form schon vorbereitet
    oder genutzt zu werden, anders als der bisherige Dokumentationsstand
    vermuten ließ. Inhalt/Reifegrad dieser Ordner ist **nicht geprüft**.
17. Alle Erkenntnisse laufend in `UEBERSICHT.md` und Commits festgehalten
    (siehe Abschnitt 4 für die vollständige Commit-Liste).

---

## 3. Wichtige Entscheidungen & Festlegungen

### Fakten (in dieser Sitzung direkt verifiziert)

- **`kepano/obsidian-skills`-Repostruktur:** `skills/{defuddle,
  json-canvas, obsidian-bases, obsidian-cli, obsidian-markdown}` — per
  `WebFetch` direkt gegen GitHub geprüft.
- **Offizielle Obsidian-Doku-Fakten** (Quelle: `github.com/obsidianmd/
  obsidian-help`, Ordner `en/`, da `obsidian.md/help` HTTP 403 liefert):
  - "Syncing ist kein Backup" ("Back up your Obsidian files"); Community
    nutzt dafür die (nicht offiziell unterstützten) Plugins "Obsidian Git"
    und "Local Backup".
  - `.obsidian/workspace.json` und `.obsidian/workspaces.json` sollen bei
    Git-Nutzung explizit ignoriert werden ("How Obsidian stores data").
  - Obsidian Sync warnt ausdrücklich vor Parallelbetrieb mit einem anderen
    Sync-Mechanismus auf demselben Vault (Konfliktrisiko, FAQ-Seite).
  - **Bases ist ein Core Plugin**, unabhängig vom gleichnamigen
    Claude-Code-Skill — der Skill taucht nirgendwo in der Obsidian-App
    selbst auf und braucht dort nichts Aktiviertes.
- **Terminal-Lauf auf dem Mac** (`ls -la ~/.claude/skills/`, 2026-07-23):
  alle 5 Skill-Ordner real vorhanden, Zeitstempel "1. Juli" (vor dieser
  Sitzung), plus vorbestehende `higgsfield-*`-Symlinks nach
  `../../.agents/skills/`.
- **Terminal-Lauf auf dem Mac** (`ls /Users/jessenikoi/Workplace/`,
  2026-07-23): reale Struktur siehe Abschnitt 2, Punkt 12. Damit
  **zweifelsfrei widerlegt**: die Vermutung aus dem externen Plan, Obsidian
  läge unter `20_WISSEN/Obsidian` — es liegt Top-Level unter `Workplace/
  Obsidian`.
- **Safety-Guard-Tests nach Bereinigung** (2026-07-23, in dieser Sandbox):
  `bash -n` grün; echter gesperrter Name blockt; obsoleter Alt-Name blockt
  nicht mehr; echter erlaubter `70_DEV_TOOLS/`-Pfad läuft durch.
- **Screenshot-Beweis** (2026-07-24): `00_INBOX/test-skill-check.md` in
  der echten Obsidian-App zeigt korrekt getypte Properties, funktionierenden
  Wikilink, korrekt gerenderten Callout — **die Obsidian-Skill-Frage ist
  damit abschließend positiv beantwortet.**
- **Plaud** hat einen offiziellen MCP-Server + CLI (plaud.ai-Blog,
  support.plaud.ai, docs.plaud.ai — per Recherche-Agent mit Quellen
  bestätigt).
- **WhatsApp:** kein offizieller Weg für Privatpersonen, eigene
  Chat-Historie programmatisch abzurufen; inoffizielle MCP-Bridges
  (Baileys-basiert) mit dokumentiertem Sperr-Risiko (GitHub-Issues als
  Belege, nicht nur Vermutung).
- **Vault enthält bereits** `00_INBOX/WhatsApp_Extrakte/` und
  `01_DAILY_NOTES/Plaud_Transkripte/` (per Screenshot gesehen) —
  **Inhalt/Reifegrad nicht geprüft**, nur Existenz der Ordner bestätigt.

### Annahmen / Einschätzungen (ausdrücklich NICHT verifiziert)

- Ob `40_KUNDEN_PARTNER` schützenswert ist und in den Safety Guard gehört
  — reine Vermutung meinerseits (Analogie zu `FIRMEN_FINANZEN_RECHT`),
  **nicht vom Nutzer bestätigt.**
- Der genaue Unterpfad, unter dem das `claude-code`-Repo jetzt in
  `70_DEV_TOOLS/` liegt — **unbekannt**, nur dass `70_DEV_TOOLS/` der neue
  Oberordner ist, ist bestätigt.
- Ob die Ordner `WhatsApp_Extrakte/` und `Plaud_Transkripte/` bereits
  echten, kuratierten Inhalt enthalten oder nur als leere Struktur
  angelegt wurden — **nicht geprüft.**
- Welche exakte App (Claude Code CLI vs. allgemeine Claude.ai-Desktop-App)
  den Skill-Test in Runde 1 geschrieben hat — durch den Screenshot-Beweis
  **gegenstandslos geworden**, aber nie eindeutig geklärt.

### Entscheidungen (getroffen, teils noch nicht auf dem Mac ausgeführt)

- **Obsidian-Skills:** nur `kepano/obsidian-skills` (5 Skills) installiert;
  `qmd` und `obsidian-second-brain` bewusst zurückgestellt, nur nach
  expliziter Freigabe nachrüsten.
- **Obsidian-Vault-Backup:** eigenes, separates, privates Git-Repo für den
  Vault (nicht im `claude-code`-Repo), mit `templates/
  obsidian-vault.gitignore.template` — **Entscheidung getroffen, `git
  init` auf dem Mac aber noch nicht ausgeführt.**
- **Plaud:** offiziellen MCP-Server nutzen, sobald lokal/interaktiv
  eingerichtet — **noch nicht eingerichtet.**
- **WhatsApp:** risikoarmer manueller Workflow (bereits exportierte
  Dateien → Claude Code mit `obsidian-markdown`-Skill konvertieren lassen
  → `80_ARCHIV/Chat-Archiv/WhatsApp/`), **kein** Live-MCP-Bridge-Weg.
- **Safety Guard:** finale, bereinigte Liste (`PRIVAT`, `55_PRIVAT`,
  `50_FIRMEN_FINANZEN_RECHT`, `60_MEDIA_INDEX`, `80_ARCHIV`, `10_AKTIV`) —
  siehe Abschnitt 6 für den exakten Code-Stand.
- **Kein PR, kein GitHub-Sync-Zwang** für dieses Setup-Repo — unverändert
  gültige Entscheidung aus früheren Sitzungen.

---

## 4. Aktueller Status (Erreichtes)

| Bereich | Status |
|---|---|
| Konzept + Setup-Skript + Safety Guard | ✅ fertig, bereinigt auf reale Struktur |
| Graphify installiert + einmal real gelaufen | ✅ (2026-06-13, 1.062 Nodes/1.383 Edges/116 Communities) |
| `graphify-out/` sauber aus Git ausgeschlossen | ✅ verifiziert |
| Obsidian-Vault initialisiert | ✅ bestätigt |
| **Obsidian-Skills — Dateien auf der Platte** | ✅ verifiziert (echtes `ls -la`) |
| **Obsidian-Skills — Funktionstest im echten Vault** | ✅ **verifiziert per Screenshot (2026-07-24)** |
| **Reale Workplace-Ordnernamen** | ✅ verifiziert (echtes `ls`), Safety Guard entsprechend bereinigt |
| Obsidian-Backup-Strategie | ✅ Entscheidung + Template fertig, ⚠️ Ausführung (`git init`) auf dem Mac offen |
| Plaud-MCP-Anbindung | ✅ offizieller Weg recherchiert, ⚠️ Einrichtung offen |
| WhatsApp-Import-Workflow | ✅ Prompt fertig, ⚠️ Ausführung offen, ⚠️ evtl. schon teilweise vorbereitet (`WhatsApp_Extrakte/`) |
| Zweiter Code-Root | ❌ noch offen |
| Graphify→Obsidian-Bridge (`--obsidian-dir`) | ❌ **noch nie ausgeführt/getestet** |
| `qmd` / `obsidian-second-brain` | ⏸️ bewusst zurückgestellt |
| PR auf GitHub | ⏸️ bewusst nicht gemacht |

**Commits dieser gesamten Sitzungsreihe (chronologisch, neueste zuletzt):**

| Commit | Inhalt |
|---|---|
| `7a9078b` | Globale Obsidian-Skills-Installation dokumentiert |
| `73a18ca` | Stabilisierungs-Runde: Safety-Guard-Superset, Doku-Korrekturen |
| `33e93c2` | Offizielle Obsidian-Doku, Plaud-MCP, WhatsApp-Recherche eingearbeitet |
| `bf32667` | Korrektur: WhatsApp-Import lokal, keine MCP-Bridge |
| `122c759` | Skill-Dateien auf der Platte bestätigt |
| `43b72c4` | Safety Guard gegen reale Workplace-Struktur bereinigt |
| `ae13bf9` | Skill-Funktionstest (Runde 1) dokumentiert |
| `26bfef1` | Skill-Verifikation per Screenshot final abgeschlossen |

Repo-Zustand: Branch `claude/graphify-install-setup-5y5u3r`, lokal und
remote identisch, Working Tree sauber (Stand vor diesem Handover-Commit).

---

## 5. Nächste Schritte (Offene Punkte)

**Meine aktive Empfehlung — genau diese Reihenfolge:**

1. **Zuerst die zwei offenen Kurz-Rückfragen beantworten** (geringer
   Aufwand, schließt den Safety Guard endgültig ab):
   - Ist `40_KUNDEN_PARTNER` schützenswert und gehört in den Safety Guard?
   - Unter welchem genauen Unterpfad liegt das `claude-code`-Repo jetzt
     unter `70_DEV_TOOLS/`?
2. **Vault-Git-Backup tatsächlich ausführen** (Entscheidung steht bereits,
   nur Ausführung fehlt):
   ```bash
   cd "$HOME/Workplace/Obsidian"
   git init
   cp <pfad-zu-diesem-repo>/docs/workplace-setup/templates/obsidian-vault.gitignore.template .gitignore
   git add .
   git commit -m "Initial vault backup"
   ```
   Dabei gleich klären: zusätzlich auf GitHub pushen (privat) oder nur
   lokal?
3. **Kurz klären, was in `WhatsApp_Extrakte/` und `Plaud_Transkripte/`
   bereits drin ist** — leere Ordner-Struktur oder schon echter Inhalt?
   Das beeinflusst, ob der in Abschnitt 7 von `UEBERSICHT.md`
   vorgeschlagene Workflow noch gebraucht wird oder nur noch verfeinert
   werden muss.
4. **Die eigentliche Graphify↔Obsidian-Brücke einmal echt testen** — bisher
   nie ausgeführt:
   ```bash
   cd <aktueller-pfad-zu-claude-code-unter-70_DEV_TOOLS>
   /graphify . --obsidian --obsidian-dir "$HOME/Workplace/Obsidian/10_PROJEKTE/claude-code/graph"
   ```
   Das würde als Erstes tatsächlich das komplette Dreieck Graphify ↔
   Obsidian ↔ Claude Code end-to-end beweisen, nicht nur die Einzelteile.
5. Vault-Übersichtsnotiz aus `templates/projekt-uebersicht.md` anlegen.
6. Erst danach: zweiter echter Code-Root unter `70_DEV_TOOLS/`.
7. Erst danach: `qmd`/`obsidian-second-brain` neu bewerten, falls gewünscht.

**Offene Rückfragen, die ich nicht selbst auflösen kann:**
- `40_KUNDEN_PARTNER` — schützenswert oder nicht?
- Exakter `70_DEV_TOOLS/`-Unterpfad des `claude-code`-Repos?
- Vault-Repo zusätzlich auf GitHub (privat) oder nur lokal?
- Sind `WhatsApp_Extrakte/`/`Plaud_Transkripte/` schon befüllt?

---

## 6. Relevanter Code / Rohdaten

### Aktuelle, bereinigte Safety-Guard-Liste (`scripts/setup-graphify-workplace.sh`)

```bash
FORBIDDEN_BASENAMES=(
  "PRIVAT"
  "55_PRIVAT"
  "50_FIRMEN_FINANZEN_RECHT"
  "60_MEDIA_INDEX"
  "80_ARCHIV"
  "10_AKTIV"
)
```

### Reale Workplace-Struktur (verifiziert 2026-07-23)

```text
00_INBOX  02_KONTEXT_SITZUNGEN  10_AKTIV  20_WISSEN  30_AGENTS
40_KUNDEN_PARTNER  50_FIRMEN_FINANZEN_RECHT  55_PRIVAT
60_MEDIA_INDEX  70_DEV_TOOLS  80_ARCHIV  99_SYSTEM
AGENTS.md  Daily  Obsidian  README.md
```

### Reale Vault-interne Struktur (unverändert seit 2026-06-13/14, per Screenshot 2026-07-24 erneut bestätigt — eigene, vom Workplace unabhängige Hierarchie)

```text
00_INBOX/ (enthält bereits: WhatsApp_Extrakte/, test-skill-check.md)
01_DAILY_NOTES/ (enthält bereits: Plaud_Transkripte/)
10_PROJEKTE/ (ANGESAGT, Campus_Sparbuch, claude-code/Uebersicht,
              Crossmedial_Holding, CS_Regionalmarketing,
              Handball_Campus_OWL, KI_Output_System/...)
15_PERSONEN/       # neu gesehen, vorher nicht dokumentiert
16_FIRMEN/         # neu gesehen, vorher nicht dokumentiert
20_BEREICHE/
30_RESSOURCEN/
40_ENTSCHEIDUNGEN/
50_OFFENE_FRAGEN/
60_DEV_AGENTEN_TOOLS/ (NotebookLM/workflows/project_briefing/...)
60_PROZESSE_SOPS/
70_AGENTEN_MEMORY/ (ChatGPT, Claude, graph/GRAPH_REPORT_..., Manus, README)
80_ARCHIV/
```

### Vault-Backup-Befehle (Entscheidung getroffen, Ausführung offen)

```bash
cd "$HOME/Workplace/Obsidian"
git init
cp <pfad-zu-diesem-repo>/docs/workplace-setup/templates/obsidian-vault.gitignore.template .gitignore
git add .
git commit -m "Initial vault backup"
```

### Graphify→Obsidian-Bridge-Befehl (noch nie ausgeführt)

```bash
cd <aktueller-pfad-zu-claude-code-unter-70_DEV_TOOLS>
/graphify . --obsidian --obsidian-dir "$HOME/Workplace/Obsidian/10_PROJEKTE/claude-code/graph"
```

### Plaud-MCP-Quellen

- https://www.plaud.ai/blogs/news/introducing-plaud-mcp-and-cli
- https://support.plaud.ai/hc/en-us/articles/57751078986265-Plaud-MCP
- https://docs.plaud.ai/ , https://dev.plaud.ai/

### WhatsApp-Import-Prompt (für eine lokale Claude-Code-Sitzung, Details/Kontext in `SESSION_HANDOVER_2026-07-19.md` Abschnitt 9)

```text
Ich habe meine WhatsApp-Chats bereits manuell exportiert (.txt-Dateien,
teils mit Medien-Ordnern). Sie liegen in: <PFAD_ZU_DEINEM_EXPORT_ORDNER>

Bitte für jeden Chat/Export in diesem Ordner:
1. Lies die .txt-Datei (Format: Datum, Zeit, Absender, Nachricht).
2. Wandle sie in eine saubere Obsidian-Notiz um (nutze den
   obsidian-markdown-Skill für korrektes Frontmatter/Formatierung).
3. Speichere jede Notiz unter:
   <WORKSPACE_ROOT>/Obsidian/80_ARCHIV/Chat-Archiv/WhatsApp/<Name>.md
4. Erstelle/aktualisiere eine Index-Notiz
   80_ARCHIV/Chat-Archiv/WhatsApp/INDEX.md.
```

---

## Selbstprüfung dieses Dokuments

1. **Fakten vs. Annahmen getrennt?** Ja — Abschnitt 3 trennt explizit
   "Fakten (direkt verifiziert)" von "Annahmen/Einschätzungen (ausdrücklich
   NICHT verifiziert)", inklusive der neuen Beobachtung zu
   `WhatsApp_Extrakte`/`Plaud_Transkripte`, deren Inhalt bewusst nicht als
   bekannt behauptet wird.
2. **Aktive Handlungsempfehlung statt nur Optionen?** Ja — Abschnitt 5 gibt
   eine konkrete, nummerierte Reihenfolge mit klarer Priorität (zuerst die
   zwei schnellen Rückfragen, dann Vault-Backup ausführen, dann die bisher
   nie getestete Graphify-Obsidian-Brücke als eigentlichen Beweis des
   Gesamtsystems).
3. **Rückfragen bei Unsicherheit gestellt?** Ja — vier konkrete offene
   Rückfragen am Ende von Abschnitt 5 sind explizit als unbeantwortet
   markiert statt stillschweigend angenommen; zusätzlich wurde in
   Abschnitt 2, Punkt 14 ein verdächtiger Erstbefund (falscher Pfad,
   ungewöhnliche URL) bewusst nicht akzeptiert, sondern aktiv hinterfragt,
   bevor die Sache durch den Screenshot in Punkt 15 tatsächlich geklärt
   wurde.
