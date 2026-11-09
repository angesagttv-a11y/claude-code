# Projekt-Kontext: Graphify → Obsidian Wissensgraph-Pipeline (Repo `claude-code`)

**Datum der Sitzung:** 2026-07-25

> Legende der Kennzeichnung in diesem Dokument:
> **[FAKT]** = in dieser Sitzung real verifiziert (Terminal-Ausgabe, Exit-Code, Datei geprüft).
> **[ANNAHME]** = plausibel, aber nicht verifiziert.
> **[EINSCHÄTZUNG]** = meine strategische Bewertung, kein Fakt.

---

## 1. Übergeordnetes Ziel

Das langfristige Ziel ist ein **selbstlaufendes Wissenssystem**, in dem Code- und
Dokumentbestände automatisch als durchsuchbarer Wissensgraph in Obsidian
vorliegen und aktuell bleiben — ohne manuelle Pflege durch Jesse.

Konkret für das Pilot-Repo `angesagttv-a11y/claude-code`:
- Graphify baut aus dem Code eine „Landkarte" (Knoten = Funktionen/Dateien/Konzepte, Kanten = Beziehungen).
- Diese Landkarte liegt **kuratiert und gesichert** im Obsidian-Vault.
- Sie **aktualisiert sich automatisch** und ist **redundant gesichert** (Backup).
- Jesse (nicht-technisch in diesem Bereich) soll damit **nichts manuell tun müssen**.

Dieses Repo ist der **Pilot**; das Vorgehen soll später auf weitere Code-Roots
unter `70_DEV_TOOLS/` übertragbar sein.

---

## 2. Zusammenfassung dieser Sitzung (chronologisch)

1. **Ehrlichkeits-Prüfung eines Vorgänger-Berichts.** Ein früherer Sitzungsbericht
   behauptete, `docs/workplace-setup/SESSION_HANDOVER_2026-07-24.md` (Commit `90b3daa`)
   sei „erstellt und gepusht". Prüfung ergab: **[FAKT]** Datei existierte nirgends,
   Commit `90b3daa` in keinem Repo (`git log --all`, `reflog`, `cat-file` alle negativ).
   Die Behauptung war unbelegt/falsch und wurde offen korrigiert.

2. **Toolchain verifiziert. [FAKT]** `graphify` v0.8.36 unter `~/.local/bin/graphify`
   (via `uv tool`, Paket `graphifyy`). Vault-Zielordner existiert. Bestehendes
   `graphify-out/graph.json` vorhanden.

3. **Realen Bridge-Befehl ermittelt. [FAKT]** Die Setup-Doku zitierte Skill-Syntax
   (`/graphify … --obsidian`). Das echte CLI-Kommando ist `graphify export obsidian --dir <ziel>`.
   Es ist in `graphify --help` **nicht** gelistet (undokumentiert), funktioniert aber und
   nutzt eine vorhandene `graph.json` (kein Rebuild, kein LLM, keine Credits).

4. **Sicherer Trockenlauf. [FAKT]** Export in den Scratchpad → 1178 Notizen + `graph.canvas`,
   Exit 0. Qualität geprüft: echte `[[Wikilinks]]`, Frontmatter, valides JSON-Canvas.

5. **Realer Vault-Export mit ausdrücklicher Nutzer-Freigabe. [FAKT]**
   `graphify export obsidian --dir .../Obsidian/10_PROJEKTE/claude-code/graph`
   → 1178 Notizen (1062 Node- + 116 `_COMMUNITY_`-Notizen) + Canvas, Exit 0.
   Roh-Export bewusst im isolierten `graph/`-Unterordner.

6. **Übersichtsnotiz aktualisiert. [FAKT]** `.../Obsidian/10_PROJEKTE/claude-code/Uebersicht.md`:
   neue Graph-Zahlen, neue Sektion „Obsidian-Graph (Bridge-Export)", Stand 2026-07-24,
   später veraltete Pfade `60_DEV_AGENTEN_TOOLS` → `70_DEV_TOOLS` korrigiert.

7. **Ehrliches Handover erstellt + lokal committet. [FAKT]**
   `docs/workplace-setup/SESSION_HANDOVER_2026-07-24.md`, Commit `4977f13` (nur diese Datei).
   **[FAKT] Der `git push` wurde vom Auto-Mode-Klassifizierer blockiert** — Commit liegt lokal,
   ist NICHT auf GitHub. Branch ist `ahead 7`.

8. **Backup-Status der Notizen geprüft. [FAKT]** Vault liegt NICHT in iCloud/Dropbox
   (nur lokal). ABER: Obsidian-Sync-Core-Plugin ist **aktiv**, und Time Machine hat
   **zwei** Ziele konfiguriert („AngesagtCloud" per SMB + lokal „XMM Mac Backup").
   **[ANNAHME]** Beide sichern aktiv/aktuell — das exakte letzte-Backup-Datum war nicht
   auslesbar (fehlende Full Disk Access-Berechtigung).

9. **Obsidian-CLI-Versuch. [FAKT]** Das `obsidian`-Kommandozeilen-Tool ist nicht installiert;
   Enable-Versuch über Command Palette schlug beim Nutzer fehl. Bewusst fallengelassen —
   für das Ziel nicht nötig.

10. **Täglicher Auto-Refresh eingerichtet und getestet. [FAKT]**
    LaunchAgent `com.jessenikoi.graphify-daily` (täglich 09:00) + Skript. Test-Lauf Exit 0
    in 3,5 s. Wichtiger Nebeneffekt siehe Abschnitt 3, Punkt E.

---

## 3. Wichtige Entscheidungen & Festlegungen

**A. Bridge-Mechanismus (technisch, festgelegt).**
Der Weg Graphify → Obsidian ist `graphify export obsidian --dir <ziel>`. Er verwendet
die vorhandene `graphify-out/graph.json`, baut nichts neu, kostet nichts. Das in der
Doku genannte `/graphify … --obsidian` ist die Skill-Variante desselben Vorgangs.

**B. Vault-Zielpfad (festgelegt).**
Roh-Export geht **immer** in einen isolierten Unterordner
`.../Obsidian/10_PROJEKTE/<Projekt>/graph/`, konkret hier
`.../Obsidian/10_PROJEKTE/claude-code/graph/`. Begründung/Leitplanke: Der kuratierte
Vault-Teil darf nicht mit ~1000+ Roh-Notizen verschmutzt werden.

**C. Schreibrechte-Freigabe (vom Nutzer erteilt).**
Jesse hat ausdrücklich Schreiben in `10_PROJEKTE/<Projekt>/graph` freigegeben, mit
„beide" später erweitert auf die `Uebersicht.md` eine Ebene darüber. Sonst gelten
die restriktiven Workplace-Schreibregeln aus der globalen CLAUDE.md weiter.

**D. Automatisierung (festgelegt): täglich 09:00, gratis.**
Auto-Refresh via macOS-LaunchAgent, nicht via cron (nativer, reboot-fester Weg).
Zeit 09:00; verpasste Läufe (Mac aus/schlafend) holt launchd beim nächsten Wake nach.
Bewusst **kostenlos** gehalten: nur `graphify update .` (AST) + Export, kein LLM.

**E. Trade-off AST-Refresh vs. kuratierter Graph (bewusst akzeptiert). [FAKT + EINSCHÄTZUNG]**
Der Gratis-Refresh (`graphify update .`) macht einen **reinen AST-Neubau**. Das ändert
den Graphen deutlich: Test ergab **3376 Knoten / 337 Cluster** statt vorher 1062 / 116.
Die Cluster-Namen sind schlichter (Placeholder statt KI-beschriftet). Graphify sichert
die kuratierte Vorversion bei jedem Lauf automatisch in einen datierten Unterordner
(z. B. `2026-07-25/`). **[EINSCHÄTZUNG]** Für „bleibt gratis aktuell" ist das der richtige
Kompromiss; schöne KI-Namen bräuchten einen API-Key (Credits) und sind bewusst NICHT
Teil des Tagesjobs.

**F. Ehrlichkeits-Prinzip (festgelegt).**
Unbelegte Erfolgsmeldungen werden offen korrigiert statt weitergetragen (siehe Abschnitt 2.1).

---

## 4. Aktueller Status (Erreichtes)

**Erstellte / geänderte Dateien:**
- **[FAKT]** `.../Obsidian/10_PROJEKTE/claude-code/graph/` — Wissensgraph als Obsidian-Vault
  (nach dem Auto-Refresh-Test 3713 Notizen + `graph.canvas`; wird täglich überschrieben).
- **[FAKT]** `.../Obsidian/10_PROJEKTE/claude-code/Uebersicht.md` — aktualisiert (Zahlen, Bridge-Sektion,
  Pfade korrigiert, Auto-Refresh dokumentiert). *Im Obsidian-Git NICHT committet — dieser Vault hat
  ohnehin kein Remote; gesichert via Obsidian-Sync + Time Machine.*
- **[FAKT]** `.../claude-code/scripts/graphify-daily-refresh.sh` — Refresh-Skript (ausführbar, getestet Exit 0).
- **[FAKT]** `~/Library/LaunchAgents/com.jessenikoi.graphify-daily.plist` — Zeitplan, geladen & aktiv
  (`launchctl list` zeigt den Job).
- **[FAKT]** `.../claude-code/docs/workplace-setup/SESSION_HANDOVER_2026-07-24.md` — Commit `4977f13`, lokal.
- **[FAKT]** Dieses Dokument (`SESSION_HANDOVER_2026-07-25.md`).
- **[FAKT]** Memory: `project_graphify_daily_refresh.md` + MEMORY.md-Eintrag.

**Meilensteine erreicht:**
- Graphify→Obsidian-Bridge erstmals real bewiesen (end-to-end, zweifach reproduziert).
- Täglicher, kostenloser Auto-Refresh aktiv.
- Notizen-Backup-Lage geklärt (Obsidian-Sync + Time Machine vorhanden).

**Laufstatus [FAKT]:** Kein Graphify-Dauerprozess; keine cron-Jobs; keine Git-Hooks.
Der einzige Automatismus ist der LaunchAgent (täglich 09:00).

---

## 5. Nächste Schritte (Offene Punkte)

**Empfohlene Reihenfolge (meine aktive Empfehlung, nicht nur Optionen):**

1. **[Nur Jesse] Blockierten GitHub-Upload nachholen — optional, geringe Priorität.**
   Das Handover `4977f13` liegt lokal, ist per Time Machine gesichert, aber nicht auf GitHub.
   Befehl: `cd ".../70_DEV_TOOLS/02_Claude/claude-code" && git push origin claude/graphify-install-setup-5y5u3r`.
   **[EINSCHÄTZUNG]** Nicht dringend (kein Datenverlustrisiko), daher Platz 1 nur, weil es der
   einzige Schritt ist, der Nutzer-Handlung braucht.

2. **Nach 1–2 Tagen: verifizieren, dass der 09:00-Job real feuerte.**
   `tail .../graphify-out/daily-refresh.log` — es muss ein Eintrag mit Datum des Vortags/Tags stehen.
   **[EINSCHÄTZUNG]** Wichtigster Realitäts-Check; bisher ist nur der manuelle Test-Lauf bewiesen,
   nicht ein echter launchd-getriggerter Lauf.

3. **Optional: KI-Beschriftung der Cluster.** Falls schöne Namen gewünscht: API-Key setzen
   (`GEMINI_API_KEY`/`GOOGLE_API_KEY`) und einmalig `graphify label .` — kostet Credits,
   daher bewusst außerhalb des Tagesjobs.

4. **Optional: Bridge auf weitere Code-Roots** unter `70_DEV_TOOLS/` ausrollen (Muster bewiesen).

5. **Optional: Restliche Pfad-Altlast** in `Uebersicht.md` — Altzeilen wurden bereits saniert;
   ein voller Konsistenz-Check der übrigen Vault-Notizen steht aus.

**Offene Rückfragen (echte Unsicherheiten, die Jesse klären sollte):**
- ❓ Ist der stark vergrößerte AST-Graph (3376 Knoten, schlichte Namen) für dich okay, oder
  willst du lieber den kuratierten, KI-beschrifteten Stand behalten (dann Tagesjob anders bauen)?
- ❓ Uhrzeit 09:00 passend, oder anderer Zeitpunkt (z. B. nachts)?
- ❓ Soll der GitHub-Push künftig automatisch erlaubt sein (Bash-Permission-Regel), damit ich
  Handover-Dokumente selbst hochladen kann?
- ❓ **[ANNAHME zu prüfen]** Läuft Obsidian-Sync wirklich eingeloggt/aktuell und ist das letzte
  Time-Machine-Backup frisch? (War mangels Berechtigung nicht auslesbar — bitte einmal in
  Menüleiste/Obsidian sichtprüfen.)

---

## 6. Relevanter Code / Rohdaten

### 6.1 Refresh-Skript — `scripts/graphify-daily-refresh.sh` (aktueller Stand)
```bash
#!/bin/bash
# Graphify Daily Refresh — AST-Update (gratis) + Export nach Obsidian.
set -uo pipefail
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
REPO="/Users/jessenikoi/Workplace/70_DEV_TOOLS/02_Claude/claude-code"
VAULT_GRAPH="/Users/jessenikoi/Workplace/20_WISSEN/Obsidian/10_PROJEKTE/claude-code/graph"
LOG="$REPO/graphify-out/daily-refresh.log"
ts() { date "+%Y-%m-%d %H:%M:%S"; }
{
  echo "===== $(ts) START ====="
  cd "$REPO" || { echo "$(ts) FEHLER: Repo nicht gefunden"; echo ""; exit 1; }
  command -v graphify >/dev/null 2>&1 || { echo "$(ts) FEHLER: graphify nicht im PATH"; echo ""; exit 1; }
  echo "$(ts) Schritt 1/2: graphify update ."
  graphify update . 2>&1
  echo "$(ts) Schritt 2/2: graphify export obsidian"
  mkdir -p "$VAULT_GRAPH"
  graphify export obsidian --dir "$VAULT_GRAPH" 2>&1
  echo "$(ts) FERTIG"; echo ""
} >> "$LOG" 2>&1
```

### 6.2 Zeitplan — `~/Library/LaunchAgents/com.jessenikoi.graphify-daily.plist`
Kernparameter: `StartCalendarInterval` Hour=9 Minute=0; startet `/bin/bash <skript>`;
`RunAtLoad=false`; Fehler-Logs nach `graphify-out/daily-refresh.launchd.{out,err}`.

### 6.3 Wichtige Kommandos (Copy-Paste)
```bash
# Graph manuell befragen:
cd "/Users/jessenikoi/Workplace/70_DEV_TOOLS/02_Claude/claude-code"
graphify query "<deine Frage>"

# Auto-Refresh sofort manuell auslösen:
bash "/Users/jessenikoi/Workplace/70_DEV_TOOLS/02_Claude/claude-code/scripts/graphify-daily-refresh.sh"

# Zeitplan-Status prüfen:
launchctl list | grep graphify-daily

# Auto-Refresh abschalten:
launchctl unload ~/Library/LaunchAgents/com.jessenikoi.graphify-daily.plist

# Log ansehen:
tail -30 "/Users/jessenikoi/Workplace/70_DEV_TOOLS/02_Claude/claude-code/graphify-out/daily-refresh.log"
```

### 6.4 Kern-Zahlen (Snapshot)
- **[FAKT]** Bridge-Erstexport: 1178 Notizen (1062 Knoten + 116 Cluster) + Canvas.
- **[FAKT]** Nach erstem AST-Auto-Refresh: 3376 Knoten / 3565 Kanten / 337 Cluster → 3713 Notizen.
- **[FAKT]** Handover-Commit `4977f13` (lokal), Branch `claude/graphify-install-setup-5y5u3r` (ahead 7).

---

_Erstellt 2026-07-25. Ergänzt/aktualisiert den Stand von `SESSION_HANDOVER_2026-07-24.md`
(dessen Abschnitt 0 dokumentiert die Ehrlichkeits-Korrektur des ursprünglich falsch gemeldeten Handovers)._
