# Projekt-Kontext: Graphify + Obsidian + Claude Code im Workplace
**Datum der Sitzung:** 2026-07-19

---

## 1. Übergeordnetes Ziel

Graphify (Wissensgraph-Tool), Obsidian (kuratiertes "zweites Gehirn") und Claude
Code sollen im bestehenden, organisch gewachsenen Workplace
(`/Users/jessenikoi/Workplace`, macOS, Rechner `Mac-mini-von-Jesse-4`) kombiniert
werden — **ohne** den Workplace zu einem Graphify-Monorepo zu machen und
**ohne** bestehende Strukturen (Projektanker in `10_AKTIV/`, kuratierter
Obsidian-Vault, private/finanzielle/rechtliche/Medien-Bereiche) zu stören.

Endzustand: Pro echtem Code-Root (Git-Repo unter `60_DEV_AGENTEN_TOOLS/`) kann
`/graphify .` einen lokalen Wissensgraphen (`graphify-out/`) erzeugen, der
Claude Code (und Codex, Manus etc.) als Kontext dient. Der Obsidian-Vault
bekommt nur kuratierte/verdichtete Inhalte. Zusätzlich soll Claude Code
**projektübergreifend** (auf User-Ebene, "auf allen Ebenen nutzbar") mit
Obsidian-spezifischen Skills ausgestattet werden, damit es Markdown/Bases/
Canvas-Dateien im Vault-Format korrekt lesen und schreiben kann. Alle dafür
nötigen Werkzeuge/Doku liegen versioniert in `angesagttv-a11y/claude-code`
(Branch `claude/graphify-install-setup-5y5u3r`) als privater Backup-/
Sync-Mechanismus — bewusst ohne PR, keine öffentliche Sichtbarkeit nötig.

---

## 2. Zusammenfassung dieser Sitzung

Diese Sitzung schließt an `SESSION_HANDOVER_2026-06-13.md` an. Fokus war
**nicht** Graphify selbst, sondern die Ausstattung von Claude Code mit
**Obsidian-spezifischen Skills** auf User-Ebene.

1. **Kandidaten-Recherche:** Der Nutzer brachte drei Kandidaten-Repos für
   Obsidian-Skills ein, die ich der Reihe nach per `WebFetch` geprüft habe:
   - `breferrari/obsidian-mind` — Vault-Template, bündelt das kepano-Skill-Set
     plus einen zusätzlichen `qmd`-Skill (semantische Suche).
   - `kepano/obsidian-skills` — offizielles, schlankes Bundle mit 5
     Einzel-Skills (`obsidian-markdown`, `obsidian-bases`, `json-canvas`,
     `obsidian-cli`, `defuddle`), MIT-lizenziert, folgt der offenen
     "Agent Skills"-Spezifikation.
   - `eugeniughelbur/obsidian-second-brain` — sehr großes 44-Kommando-System,
     offizieller Installer ist ein `curl | bash` von einem ungeprüften
     Drittanbieter-Repo.

2. **Bewertung & Empfehlung:** Ich habe die drei Optionen tabellarisch
   verglichen und aktiv **`kepano/obsidian-skills`** empfohlen (offiziell,
   minimal, kein Code-Execution-Risiko, deckt die relevanten Fähigkeiten ab).
   `qmd` und `obsidian-second-brain` habe ich bewusst **nicht** automatisch
   installiert, sondern als risikobehaftet zurückgestellt (globale
   npm-Installation bzw. ungeprüftes Bash-Skript von Drittanbieter) und dem
   Nutzer zur expliziten Freigabe vorgelegt.

3. **Erster Installationsversuch — offizieller Marketplace-Weg:** Der Nutzer
   hat `/plugin install obsidian@obsidian-skills` ausgeführt. Ergebnis:
   `"/plugin isn't available in this environment."` Ich habe zwei mögliche
   Ursachen benannt: (a) der vorgeschaltete Schritt
   `/plugin marketplace add kepano/obsidian-skills` fehlte, (b) der Befehl
   wurde eventuell nicht in einer lokalen Claude-Code-Sitzung auf dem Mac,
   sondern in dieser Cloud-Sandbox eingegeben.

4. **Fallback — manuelle Installation:** Ich habe eine versionsunabhängige
   manuelle Methode vorgeschlagen (Repo klonen, `skills/`-Unterordner nach
   `~/.claude/skills/` kopieren — User-Ebene statt Projekt-Ebene, damit es
   "auf allen Ebenen" verfügbar ist). Der Nutzer hat dies **lokal auf dem Mac**
   (`Mac-mini-von-Jesse-4`, zsh-Shell) ausgeführt:
   ```bash
   mkdir -p ~/.claude/skills
   git clone --depth 1 https://github.com/kepano/obsidian-skills.git /tmp/obsidian-skills-src
   cp -r /tmp/obsidian-skills-src/skills/* ~/.claude/skills/
   rm -rf /tmp/obsidian-skills-src
   ```
   Alle vier Befehle liefen laut Terminal-Ausgabe **ohne Fehler** durch
   (Clone: 26 Objekte, 20,41 KiB).

5. **Dokumentation & Commit:** Ich habe `docs/workplace-setup/UEBERSICHT.md`
   um die neue Status-Zeile sowie einen Detailabschnitt zur
   Obsidian-Skill-Installation ergänzt (inkl. der bewusst zurückgestellten
   Optionen) und gepusht (Commit `7a9078b`).

6. **Widerspruch entdeckt (noch ungelöst):** Ich bat den Nutzer, in einer
   neuen lokalen Sitzung zu prüfen, ob die 5 Skills im Skill-Tool sichtbar
   sind. Der Nutzer meldete stattdessen eine Liste von 17 Skills
   (`session-start-hook`, `listingpro-wordpress-portal-master`,
   `commit-push-pr`, `dedupe`, `triage-issue`, `update-config`,
   `keybindings-help`, `verify`, `code-review`, `simplify`,
   `fewer-permission-prompts`, `loop`, `claude-api`, `run`, `init`, `review`,
   `security-review`) — **keiner der 5 Obsidian-Skills war darunter** — und
   merkte an, dass auf der Festplatte in `~/.claude/skills/` angeblich nur
   `session-start-hook` liegt.
   - Ich habe die reale Ordnerstruktur von `kepano/obsidian-skills` per
     `WebFetch` gegengeprüft: `skills/{defuddle, json-canvas, obsidian-bases,
     obsidian-cli, obsidian-markdown}` — der Pfad, den der `cp`-Befehl
     verwendet hat, war korrekt.
   - Ich habe den Nutzer gebeten, `ls -la ~/.claude/skills/` **frisch**
     auszuführen, zu bestätigen, ob Claude Code seit dem `cp`-Befehl
     **vollständig neu gestartet** wurde, und notfalls den Kopiervorgang mit
     `cp -v` (verbose) zu wiederholen, um zu sehen, ob wirklich Dateien
     ankommen. **Diese Antwort steht noch aus** (siehe Abschnitt 5).

7. **Sitzungsabschluss:** Der Nutzer bat darum, den Stand zu prüfen und dann
   zu stoppen. Ich habe `git status` / `git log` verifiziert (sauber,
   vollständig gepusht) und eine Abschluss-Zusammenfassung gegeben. Danach
   wurde dieses Handover-Dokument angefordert.

---

## 3. Wichtige Entscheidungen & Festlegungen

### Fakten (in dieser Sitzung verifiziert)

- **Repo-/Branch-Zustand:** `claude/graphify-install-setup-5y5u3r` ist
  identisch mit `origin/claude/graphify-install-setup-5y5u3r`, Commit
  `7a9078b91f235bcdeb1385a6703e5abd7305e0f0`, Working Tree sauber.
- **`kepano/obsidian-skills`-Repostruktur** (per `WebFetch` direkt von
  GitHub gelesen): Root enthält `.claude-plugin/`, `skills/`, `LICENSE`,
  `README.md`. `skills/` enthält exakt fünf Unterordner: `defuddle`,
  `json-canvas`, `obsidian-bases`, `obsidian-cli`, `obsidian-markdown`.
- **Offizielle Installationswege laut README** (verifiziert per
  `WebFetch` auf `raw.githubusercontent.com/.../README.md`):
  1. Marketplace: **zwei** Befehle nötig —
     `/plugin marketplace add kepano/obsidian-skills` **dann**
     `/plugin install obsidian@obsidian-skills`.
  2. `npx skills add https://github.com/kepano/obsidian-skills`
  3. Manuell für Claude Code: Repo-Inhalt nach `.claude` (im Vault-Root oder
     global) kopieren.
  4. Manuell für OpenCode: volles Repo nach `~/.opencode/skills/...` klonen.
- **Terminal-Lauf auf dem Mac** (`Mac-mini-von-Jesse-4`, zsh) für den
  manuellen Installationsweg (`mkdir`, `git clone`, `cp -r`, `rm -rf`) endete
  **ohne sichtbare Fehlermeldung**.
- **Später gemeldete Skill-Tool-Liste** (17 Einträge, siehe Abschnitt 2,
  Punkt 6) enthält **keinen** der 5 Obsidian-Skill-Namen.
- **Nutzeraussage zum Festplattenstand:** In `~/.claude/skills/` liege nach
  eigener Prüfung nur `session-start-hook` — diese Aussage steht in direktem
  Widerspruch zum fehlerfreien `cp`-Lauf und ist **nicht** durch eine frisch
  eingefügte, vollständige `ls -la`-Ausgabe in diesem Chat belegt.

### Annahmen / Einschätzungen (nicht verifiziert — als solche markiert)

- **Hypothese zur Skill-Erkennung:** Das Skill-Tool liest die verfügbaren
  Skills vermutlich **beim Sitzungsstart** ein (Built-ins + projektlokale
  `.claude/skills/`) und aktualisiert sich nicht live, wenn währenddessen
  Dateien auf der Platte hinzukommen. Diese Annahme stützt sich auf
  Beobachtung (`listingpro-wordpress-portal-master` erscheint korrekt, weil
  `.claude/skills/listingpro-wordpress-portal-master/SKILL.md` real im
  Projekt-Repo liegt), ist aber **nicht offiziell bestätigt** — insbesondere
  ist unklar, ob **User-globale** `~/.claude/skills/`-Ordner überhaupt
  automatisch gescannt werden oder ob dafür ein anderer Registrierungsschritt
  (z. B. über den Plugin-Marketplace-Mechanismus) nötig ist.
- **Hypothese zum `/plugin`-Fehler:** Entweder fehlte der vorgeschaltete
  `marketplace add`-Schritt, oder der Befehl wurde versehentlich in der
  Cloud-Sandbox statt lokal eingegeben. Beides ist plausibel, aber ungeklärt.
- **Hypothese zum Festplatten-Widerspruch:** Möglich ist ein reiner
  Zwischenstand-Bericht (Nutzer prüfte ggf. vor dem `cp`-Lauf oder erinnerte
  sich an einen älteren Zustand) statt eines aktuellen, exakten Befehlsergebnisses.
  Eine echte Fehlkopie (z. B. durch einen Tippfehler im Pfad) ist ebenfalls
  nicht ausgeschlossen.

### Entscheidungen (aus vorherigen Sitzungen, unverändert gültig)

- Hybridmodell statt Monorepo (`10_AKTIV/` bleibt Projektlandkarte, kein
  Graphify direkt darauf).
- Safety Guard mit gesperrten Basenamen (`30_PRIVAT`, `PRIVAT`,
  `20_FIRMEN_FINANZEN_RECHT`, `50_MEDIEN_ASSETS`, `70_ARCHIV_INDEX`,
  `10_AKTIV`).
- Anonymisierung in Doku (Platzhalter statt echter Firmen-/Projektnamen).
- Repo ist privates Backup/Sync-Tool — kein PR.

---

## 4. Aktueller Status (Erreichtes)

| Bereich | Status |
|---|---|
| Konzept + Setup-Skript + Safety Guard | ✅ fertig (aus Vorsitzung) |
| Erster Graphify-Lauf (`claude-code`-Repo) | ✅ fertig (aus Vorsitzung) — 1.062 Nodes, 1.383 Edges, 116 Communities |
| Obsidian-Vault initialisiert (`.obsidian/`) | ✅ bestätigt (aus Vorsitzung) |
| **Kandidaten-Repos für Obsidian-Skills bewertet** | ✅ **neu in dieser Sitzung** — 3 Repos verglichen, Empfehlung dokumentiert |
| **`kepano/obsidian-skills` nach `~/.claude/skills/` kopiert** | ⚠️ **neu in dieser Sitzung, Ausführung ohne Fehler — Erkennung durch Claude Code aber unbestätigt/widersprüchlich** |
| `UEBERSICHT.md` aktualisiert (Status + Installationsdetails) | ✅ neu in dieser Sitzung, Commit `7a9078b` |
| Dieses Handover-Dokument | ✅ neu erstellt |
| `qmd` / `obsidian-second-brain` | ⏸️ weiterhin bewusst zurückgestellt |
| Zweiter Code-Root (echtes Arbeitsprojekt) | ❌ weiterhin offen |
| Mobile Obsidian-Sync | ⏸️ weiterhin bewusst zurückgestellt |
| PR auf GitHub | ⏸️ weiterhin bewusst nicht gemacht |

**Geänderte/erstellte Dateien in dieser Sitzung:**
- `docs/workplace-setup/UEBERSICHT.md` (Status-Tabelle + neuer Abschnitt
  "Obsidian-Skills — Installationsdetails (2026-06-14)")
- `docs/workplace-setup/SESSION_HANDOVER_2026-07-19.md` (dieses Dokument)

Repo-Zustand: Branch `claude/graphify-install-setup-5y5u3r`, lokal und
remote identisch auf Commit `7a9078b`, Working Tree sauber.

---

## 5. Nächste Schritte (Offene Punkte)

**Meine aktive Empfehlung — genau diese Reihenfolge für die nächste Sitzung:**

1. **Zuerst den Widerspruch aus Punkt 2.6 auflösen**, bevor irgendetwas
   anderes angefasst wird — sonst bauen wir möglicherweise auf einer falschen
   Annahme weiter. Konkret auf dem Mac ausführen und mir die **vollständige,
   ungekürzte Ausgabe** schicken:
   ```bash
   ls -la ~/.claude/skills/
   ```
   Falls die 5 Obsidian-Ordner **fehlen**, dann Schritt-für-Schritt mit
   Zwischenprüfung neu versuchen:
   ```bash
   git clone --depth 1 https://github.com/kepano/obsidian-skills.git /tmp/obsidian-skills-src
   ls -la /tmp/obsidian-skills-src/skills/
   cp -rv /tmp/obsidian-skills-src/skills/* ~/.claude/skills/
   ls -la ~/.claude/skills/
   ```
2. **Claude Code vollständig neu starten** (App/Terminal wirklich beenden,
   nicht nur neue Nachricht) und danach erneut prüfen, ob die 5 Skills im
   Skill-Tool auftauchen.
3. Falls die manuelle Methode weiterhin nicht erkannt wird: den offiziellen
   Marketplace-Weg **korrekt mit beiden Befehlen** probieren:
   ```
   /plugin marketplace add kepano/obsidian-skills
   /plugin install obsidian@obsidian-skills
   ```
   — explizit in einer lokalen Claude-Code-Sitzung auf dem Mac, nicht in der
   Cloud-Sandbox.
4. Erst danach: Entscheidung zu `qmd` und `obsidian-second-brain` treffen
   (aktuell weiterhin zurückgestellt).
5. Danach: zweiter Code-Root, sobald ein echtes Arbeitsprojekt als Git-Repo
   unter `60_DEV_AGENTEN_TOOLS/` existiert.

**Offene Rückfragen, die ich nicht selbst auflösen kann (Antwort steht noch
aus):**
- Wurde `ls -la ~/.claude/skills/` bereits **nach** dem `cp`-Lauf frisch
  ausgeführt, oder bezog sich die Aussage "dort liegt nur `session-start-hook`"
  auf einen älteren Zustand?
- Wurde Claude Code seit dem `cp`-Befehl vollständig neu gestartet?
- War der fehlgeschlagene `/plugin install`-Versuch in der lokalen
  Mac-Sitzung oder in dieser Cloud-Sandbox?

---

## 6. Relevanter Code / Rohdaten

### Manuelle Installation (bereits ausgeführt, Ergebnis unbestätigt)

```bash
mkdir -p ~/.claude/skills
git clone --depth 1 https://github.com/kepano/obsidian-skills.git /tmp/obsidian-skills-src
cp -r /tmp/obsidian-skills-src/skills/* ~/.claude/skills/
rm -rf /tmp/obsidian-skills-src
```

### Verifizierte Repo-Struktur von `kepano/obsidian-skills`

```
kepano/obsidian-skills/
├── .claude-plugin/
├── skills/
│   ├── defuddle/
│   ├── json-canvas/
│   ├── obsidian-bases/
│   ├── obsidian-cli/
│   └── obsidian-markdown/
├── LICENSE
└── README.md
```

### Offizielle Installationswege (aus README, wörtlich übernommen)

```
# Marketplace (zwei Schritte, nicht nur einer!)
/plugin marketplace add kepano/obsidian-skills
/plugin install obsidian@obsidian-skills

# NPX
npx skills add https://github.com/kepano/obsidian-skills

# Manuell (Claude Code)
# Repo-Inhalt nach .claude-Ordner kopieren (Vault-Root oder global)

# Manuell (OpenCode)
git clone https://github.com/kepano/obsidian-skills.git ~/.opencode/skills/obsidian-skills
```

### Diagnose-Befehle für die nächste Sitzung

```bash
ls -la ~/.claude/skills/
git clone --depth 1 https://github.com/kepano/obsidian-skills.git /tmp/obsidian-skills-src
ls -la /tmp/obsidian-skills-src/skills/
cp -rv /tmp/obsidian-skills-src/skills/* ~/.claude/skills/
ls -la ~/.claude/skills/
```

### Bewusst zurückgestellte Alternativen (nicht installiert)

- `breferrari/obsidian-mind` → enthält zusätzlich `qmd`
  (`npm install -g @tobilu/qmd` + Bootstrap-Indexierung über den ganzen
  Vault nötig).
- `eugeniughelbur/obsidian-second-brain` → 44-Kommando-System,
  Installer: `curl -fsSL https://raw.githubusercontent.com/eugeniughelbur/obsidian-second-brain/main/scripts/quick-install.sh | bash`
  (bewusst nicht ausgeführt — ungeprüftes Drittanbieter-Skript mit
  uneingeschränkter Codeausführung).

---

## Selbstprüfung dieses Dokuments

1. **Fakten vs. Annahmen getrennt?** Ja — Abschnitt 3 ist explizit in
   "Fakten (verifiziert)" und "Annahmen/Einschätzungen (nicht verifiziert)"
   unterteilt.
2. **Aktive Handlungsempfehlung statt nur Optionen?** Ja — Abschnitt 5 gibt
   eine konkrete, nummerierte Reihenfolge mit einer klar benannten
   Priorität (zuerst den Widerspruch auflösen, danach erst weitermachen).
3. **Rückfragen bei Unsicherheit gestellt?** Ja — die drei offenen
   Rückfragen am Ende von Abschnitt 5 wurden in der Sitzung gestellt, aber
   noch nicht beantwortet; sie sind bewusst als offen markiert statt
   stillschweigend angenommen.
