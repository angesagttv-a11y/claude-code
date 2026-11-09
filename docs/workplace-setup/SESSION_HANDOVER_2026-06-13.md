# Projekt-Kontext: Graphify + Obsidian + Claude Code im Workplace
**Datum der Sitzung:** 2026-06-13

---

## 1. Übergeordnetes Ziel

Graphify (Wissensgraph-Tool), Obsidian (kuratiertes "zweites Gehirn") und Claude Code sollen im bestehenden, organisch gewachsenen Workplace (`/Users/jessenikoi/Workplace`, macOS) kombiniert werden — **ohne** den Workplace zu einem Graphify-Monorepo zu machen und **ohne** bestehende Strukturen (Projektanker in `10_AKTIV/`, kuratierter Obsidian-Vault, private/finanzielle/rechtliche/Medien-Bereiche) zu stören.

Endzustand: Pro echtem Code-Root (Git-Repo unter `60_DEV_AGENTEN_TOOLS/`) kann `/graphify .` einen lokalen Wissensgraphen (`graphify-out/`) erzeugen, der Claude Code (und Codex, Manus etc.) als Kontext dient. Der Obsidian-Vault bekommt nur kuratierte/verdichtete Inhalte. Alle dafür nötigen Werkzeuge/Doku liegen versioniert in `angesagttv-a11y/claude-code` (Branch `claude/graphify-install-setup-5y5u3r`) als privater Backup-/Sync-Mechanismus.

---

## 2. Zusammenfassung dieser Sitzung

Chronologisch (diese Sitzung, 2026-06-13):

1. **SESSION_HANDOVER.md (vom 2026-06-10) gelesen** — vollständiger Kontext der Vorarbeit aufgenommen. Repo war bereits geklont und vorhanden.

2. **Prüfung des vorgeschlagenen Code-Roots** `10_AKTIV/01_Campus_Sparbuch/06_WP_LISTINGPRO_REVIEW_24C`:
   - Ergebnis: kein `.git`-Ordner, keine Code-Dateien (PHP/JS/CSS etc.)
   - Enthält nur zwei Desktop-Ordner (`Desktop_Campus_Sparbuch_2026`, `Desktop_Schreibtisch_aufräumen_01.02.2025`)
   - **→ Nicht geeignet.**

3. **Suche nach Git-Repos** im gesamten Workplace (`60_DEV_AGENTEN_TOOLS/`, `10_AKTIV/`):
   - Einziger Treffer: `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`
   - `10_AKTIV/` enthält keinerlei Git-Repos.

4. **Nutzer-Entscheidung:** `60_DEV_AGENTEN_TOOLS/02_Claude/claude-code` als ersten Graphify-Code-Root verwenden (so wie Manus/Dokument A/B es vorgeschlagen hatte — Offene Frage 1 aus dem vorherigen Handover damit beantwortet).

5. **Dry-Run von `scripts/setup-graphify-workplace.sh`** mit allen Parametern:
   ```bash
   ./scripts/setup-graphify-workplace.sh \
     --workspace-root "/Users/jessenikoi/Workplace" \
     --vault "/Users/jessenikoi/Workplace/Obsidian" \
     --code-root "/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code" \
     --platform claude --platform codex \
     --dry-run
   ```
   - Ergebnis: ✅ sauber, keine Fehler, alle erwarteten Aktionen korrekt angezeigt.

6. **Echter Lauf von `scripts/setup-graphify-workplace.sh`** (ohne `--dry-run`):
   - `graphify` war bereits installiert (`/Users/jessenikoi/.local/bin/graphify`).
   - `graphify install --project --platform claude`: `.claude/skills/graphify/` und `references/` installiert, `CLAUDE.md` bereits registriert (kein Change), PreToolUse-Hooks in `.claude/settings.json` registriert. ✅
   - `graphify install --project --platform codex`: `.codex/skills/graphify/` und `references/` installiert, `AGENTS.md` bereits registriert (kein Change), `.codex/hooks.json` angelegt. ✅
   - Exit-Code 1 (harmlos): kam vom Codex-Hook-Check — `codex` ist nicht im PATH auf diesem Mac, der Check schlägt fehl, aber die Installation selbst war erfolgreich.
   - `.graphifyignore` war bereits vorhanden → übersprungen.
   - Obsidian-Skills bereits vorhanden → übersprungen.

7. **`/graphify .`** auf `60_DEV_AGENTEN_TOOLS/02_Claude/claude-code` (vollständiger Rebuild):
   - **Corpus:** 245 Dateien, ~664k Wörter (87 Code, 157 Docs, 1 Image)
   - **Cache:** 162 Dateien aus Cache, 82 neu zu extrahieren
   - **AST-Extraktion (Part A):** 677 Nodes, 1.045 Edges aus Code-Dateien
   - **Semantische Extraktion (Part B):** 4 Subagenten parallel (Chunks à ~21 Dateien)
     - Chunk 1: Config, DevContainer, ListingPro-Toolkit, Beispiel-Settings (21 Dateien)
     - Chunk 2: Plugin-Manifeste, hookify-Python-Package (21 Dateien)
     - Chunk 3: learning-output-style, plugin-dev-Skills, ralph-wiggum (21 Dateien)
     - Chunk 4: security-guidance-Plugin, utility-Scripts, SESSION_HANDOVER.md (19 Dateien)
     - **Hinweis:** Subagenten hatten keinen Write-Zugriff → JSON inline zurückgegeben, von Haupt-Session manuell geschrieben.
   - **Merge:** 1.078 Nodes, 1.585 Edges (AST + Semantik)
   - **Graph:** 1.062 Nodes, 1.383 Edges, **116 Communities**
   - **Outputs erstellt:** `graphify-out/graph.html`, `graphify-out/GRAPH_REPORT.md`, `graphify-out/graph.json`
   - **Kosten dieser Extraktion:** 31.000 Input-Tokens, 7.000 Output-Tokens

---

## 3. Wichtige Entscheidungen & Festlegungen

### Fakten (verifiziert in dieser Sitzung)

- **Repo-Pfad (lokal, bestätigt):** `/Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code`
- **Branch:** `claude/graphify-install-setup-5y5u3r`
- **Graphify installiert:** `/Users/jessenikoi/.local/bin/graphify` (via `uv tool install graphifyy`)
- **Python-Interpreter für Graphify:** `/Users/jessenikoi/.local/share/uv/tools/graphifyy/bin/python`
- **Kein PR erstellt** (Entscheidung aus vorheriger Sitzung, weiterhin gültig).
- **`10_AKTIV/` enthält keine Git-Repos** — bestätigt durch vollständige Suche in dieser Sitzung.
- **Erster (und derzeit einziger) Graphify-Code-Root:** `60_DEV_AGENTEN_TOOLS/02_Claude/claude-code` (das Setup-/Tooling-Repo selbst).

### Entscheidungen (aus vorherigen Sitzungen, unverändert gültig)

- **Hybridmodell statt Monorepo:** `10_AKTIV/<Projekt_X>/` bleibt operative Projektlandkarte, kein Graphify direkt darauf. `graphify-out/` immer projektlokal im jeweiligen Code-Root unter `60_DEV_AGENTEN_TOOLS/`.
- **Safety Guard:** `FORBIDDEN_BASENAMES = 30_PRIVAT, PRIVAT, 20_FIRMEN_FINANZEN_RECHT, 50_MEDIEN_ASSETS, 70_ARCHIV_INDEX, 10_AKTIV` — als exakter Basename und als übergeordneter Pfadbestandteil gesperrt.
- **`--workspace-root`-Parameter** blockiert Workspace-Root selbst als Ziel.
- **Anonymisierung in Doku:** Platzhalter statt echter Firmen-/Projektnamen in committeten Dateien.
- **Repo ist privates Backup/Sync-Tool** — kein PR, keine öffentliche Sichtbarkeit nötig.

### Graph-Ergebnisse (Stand 2026-06-13)

| Metrik | Wert |
|--------|------|
| Nodes | 1.062 |
| Edges | 1.383 |
| Communities | 116 |
| God Node #1 | `debug_log()` (26 Edges) |
| God Node #2 | `main()` (26 Edges) |
| God Node #3 | `Graphify Skill (/graphify)` (26 Edges) |
| God Node #4 | `handle_push_sweep_posttooluse()` (24 Edges) |
| God Node #5 | `with_locked_state()` (22 Edges) |

**Top-Communities (benannt):**

| ID | Name | Größe |
|----|------|-------|
| C0 | Hookify Rule Engine | 50 |
| C1 | MCP & OAuth Reference Docs | 35 |
| C2 | DevContainer Environment | 35 |
| C3 | Security Hook Base Layer | 35 |
| C4 | ListingPro Bulk Import Addon | 30 |
| C5 | Git Diff & Review Pipeline | 30 |
| C6 | Security LLM Review Core | 29 |
| C7 | Plugin Manifest & Commands | 26 |
| C8 | GitHub Actions & Issue Scripts | 25 |
| C18 | Graphify & Workplace Setup | 19 |

---

## 4. Aktueller Status (Erreichtes)

### Im Branch `claude/graphify-install-setup-5y5u3r` (gepusht, kein PR):

| Datei | Inhalt/Zweck | Status |
|-------|-------------|--------|
| `docs/workplace-graphify-obsidian-setup.md` | Konzept: Hybridmodell, Entscheidungsbaum, Leitplanken (inkl. Safety-Guard-Beschreibung), Multi-Agent-Plan | ✅ fertig |
| `docs/workplace-setup/README.md` | Kurzanleitung zum Skript | ✅ fertig |
| `docs/workplace-setup/UEBERSICHT.md` | Status-Tabelle, Use-Case, Datei-Übersicht, Gebrauchsanleitung, Safety-Guard-Sektion | ✅ fertig |
| `docs/workplace-setup/SESSION_HANDOVER.md` | Handover vom 2026-06-10 | ✅ archiviert |
| `docs/workplace-setup/SESSION_HANDOVER_2026-06-13.md` | Dieses Dokument | ✅ neu erstellt |
| `docs/workplace-setup/templates/graphifyignore.template` | Vorlage `.graphifyignore` | ✅ fertig |
| `docs/workplace-setup/templates/PROJEKT.md` | Vorlage Projektanker | ✅ fertig |
| `docs/workplace-setup/templates/projekt-uebersicht.md` | Vorlage Vault-Notiz | ✅ fertig |
| `scripts/setup-graphify-workplace.sh` | Idempotentes Setup-Skript mit Safety Guard, `--workspace-root`, `--dry-run` | ✅ lokal getestet + echter Lauf ✅ |
| `.claude/skills/graphify/` | Graphify-Skill für Claude Code (inkl. references/) | ✅ installiert via `graphify install` |
| `.codex/skills/graphify/` | Graphify-Skill für Codex | ✅ installiert |
| `.codex/hooks.json` | Codex PreToolUse-Hook für graphify | ✅ neu in dieser Sitzung |
| `graphify-out/graph.json` | Wissensgraph (1.062 Nodes, 1.383 Edges, 116 Communities) | ✅ neu in dieser Sitzung |
| `graphify-out/graph.html` | Interaktiver Graph (Browser) | ✅ neu in dieser Sitzung |
| `graphify-out/GRAPH_REPORT.md` | Audit-Report mit God Nodes, Surprising Connections, Suggested Questions | ✅ neu in dieser Sitzung |
| `graphify-out/.graphify_labels.json` | Community-Labels | ✅ neu in dieser Sitzung |
| `graphify-out/.graphify_root` | Scan-Root-Pointer | ✅ neu |
| `graphify-out/.graphify_python` | Interpreter-Pointer | ✅ neu |

### Noch NICHT erledigt:
- **Lokale Übersichtsdatei** `60_DEV_AGENTEN_TOOLS/02_Claude/Graphify_Obsidian_Setup/UEBERSICHT_GRAPHIFY_OBSIDIAN.md` (laut Dokument A/B Abschnitt 15) — offen
- **Abnahmeprotokoll** (Tabelle aus Dokument B Abschnitt 16) — offen
- **Obsidian-Vault-Status** (`.obsidian/` initialisiert?) — unbekannt/ungeprüft
- **Obsidian-Export** (`graphify export obsidian`) — optional, noch nicht gemacht
- **Commit + Push** der neuen Dateien (`.codex/hooks.json`, `graphify-out/`, dieses Handover-Dokument) — steht aus

---

## 5. Nächste Schritte (Offene Punkte)

**Empfohlene konkrete Reihenfolge für die nächste Sitzung:**

1. **Neuen Graphify-Stand committen und pushen:**
   ```bash
   cd /Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code
   git add .codex/hooks.json graphify-out/.graphify_labels.json docs/workplace-setup/SESSION_HANDOVER_2026-06-13.md
   git commit -m "feat: graphify first run on claude-code — 1062 nodes, 116 communities"
   git push origin claude/graphify-install-setup-5y5u3r
   ```
   *(Note: `graphify-out/graph.json`, `graph.html`, `GRAPH_REPORT.md` sind wahrscheinlich in `.gitignore` — prüfen.)*

2. **Lokale Übersichtsdatei anlegen** (Dokument A/B Abschnitt 15):
   ```
   60_DEV_AGENTEN_TOOLS/02_Claude/Graphify_Obsidian_Setup/UEBERSICHT_GRAPHIFY_OBSIDIAN.md
   ```
   Inhalt: Überblick über installierten Stack, Code-Roots, Vault-Pfad, nächste Schritte.

3. **Abnahmeprotokoll** (Dokument B Abschnitt 16) ausfüllen und an Jesse zurückmelden.

4. **Obsidian-Vault prüfen** (`.obsidian/` unter `/Users/jessenikoi/Workplace/Obsidian/`):
   - Falls nicht vorhanden: Vault einmal in Obsidian-App öffnen.
   - Optional danach: `graphify export obsidian` für Vault-Integration.

5. **Erstes echtes Arbeitsprojekt in `60_DEV_AGENTEN_TOOLS/` anlegen** und Graphify darauf anwenden:
   - Sobald ein zweites Git-Repo unter `60_DEV_AGENTEN_TOOLS/` existiert, ist der nächste Lauf: `cd <neues-repo> && /graphify .`
   - Das Setup-Skript muss dafür nicht erneut laufen (nur einmalig pro Vault/Workspace nötig).

6. **Offene Rückfrage:** Soll Codex tatsächlich denselben Code-Root wie Claude verwenden, oder arbeitet Codex an einem anderen Projekt (dann separater `--code-root`)?

**Meine aktive Empfehlung:**
Schritt 1 (Commit/Push) zuerst — damit der aktuelle Graph-Stand versioniert ist. Danach Schritt 2 (Übersichtsdatei) als Abschluss der Setup-Phase. Erst dann neue Projekte angehen.

**Offene Unsicherheiten (die ich nicht selbst auflösen kann):**
- Ist `.obsidian/` im Vault inzwischen initialisiert? → Jesse muss prüfen.
- Sind `graphify-out/`-Dateien in `.gitignore`? → `git status` zeigt nur `.graphify_labels.json` als untracked — möglicherweise ist der Rest bereits ignoriert.
- Soll der Graph-Report (GRAPH_REPORT.md) in Obsidian eingebunden werden?

---

## 6. Relevanter Code / Rohdaten

### Dry-Run-Befehl (für zukünftige neue Code-Roots)

```bash
cd /Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code

./scripts/setup-graphify-workplace.sh \
  --workspace-root "/Users/jessenikoi/Workplace" \
  --vault "/Users/jessenikoi/Workplace/Obsidian" \
  --code-root "<NEUER_CODE_ROOT_PFAD>" \
  --platform claude --platform codex \
  --dry-run
```

### Graphify-Rebuild-Befehl (im Code-Root ausführen)

```bash
cd /Users/jessenikoi/Workplace/60_DEV_AGENTEN_TOOLS/02_Claude/claude-code
graphify .
```

### Interpreter-Pfad (für manuelle Graphify-Python-Aufrufe)

```
/Users/jessenikoi/.local/share/uv/tools/graphifyy/bin/python
```

### God Nodes & ihre Bedeutung

| Node | Edges | Bedeutung |
|------|-------|-----------|
| `debug_log()` | 26 | Gemeinsame Utility-Funktion quer durch den gesamten Security-Hook-Stack |
| `main()` | 26 | Cross-Community-Bridge; verbindet 9 verschiedene Communities |
| `Graphify Skill (/graphify)` | 26 | Zentrales Skill-Dokument, das alle Graphify-Workflows beschreibt |
| `handle_push_sweep_posttooluse()` | 24 | Haupt-PostToolUse-Handler im Security-Review-System |
| `with_locked_state()` | 22 | Zentrales Locking-Pattern für Session-State (Security-Plugin) |

### Surprising Connections (für zukünftige Graph-Exploration)

- **Handoff Writing Style ↔ Graphify Audit Trail:** Editorische Standards im ListingPro-Skill semantisch ähnlich zur Graphify-Audit-Logik — unerwartete konzeptuelle Verwandtschaft.
- **Claude Settings ↔ Codex Hooks:** Beide implementieren identisch das PreToolUse-Hook-Pattern für Graphify — konsistente Cross-Platform-Implementierung bestätigt.
- **Graphify Skill ↔ ListingPro Master Skill:** Beide sind "Master-Skills" desselben Typs im Repo — strukturelle Ähnlichkeit könnte als Template für zukünftige Skills dienen.

### `.gitignore`-Status (zu prüfen)

`graphify-out/.graphify_labels.json` erscheint als untracked in `git status`. Der Rest von `graphify-out/` wird vermutlich durch `.gitignore` ausgeschlossen. Vor dem Commit prüfen:
```bash
git status
cat .gitignore | grep graphify
```
