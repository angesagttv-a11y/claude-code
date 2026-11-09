#!/bin/bash
# Graphify Daily Refresh
# Aktualisiert NUR den lokalen Wissensgraphen-Cache (AST, gratis — keine
# KI/Credits). Exportiert NICHT mehr automatisch nach Obsidian.
#
# Grund (korrigiert 2026-11-09, siehe docs/workplace-setup/UEBERSICHT.md
# Abschnitt 8): "graphify update ." enthaelt nur die AST-Ebene, nicht die
# semantische Ebene. Ein "graphify export obsidian" direkt danach ersetzt
# den reichhaltigen, semantisch vollen Obsidian-Export (frueher: 3.672
# Dateien) durch einen stark abgemagerten (27 Community-Notizen) — das ist
# am 2026-11-08 tatsaechlich passiert und musste per "git checkout" im
# Vault-Repo wiederhergestellt werden.
#
# Fuer einen vollen, semantisch reichen Export: manuell in einer
# interaktiven Claude-Code-Sitzung "/graphify . --update" ausfuehren
# (braucht KI/Credits, deshalb nicht automatisiert), danach optional
# "graphify export obsidian --dir ...".
#
# Wird taeglich vom LaunchAgent com.jessenikoi.graphify-daily gestartet.
# Manuell testbar: einfach ausfuehren.
set -uo pipefail

export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

REPO="/Users/jessenikoi/Workplace/70_DEV_TOOLS/02_Claude/claude-code"
LOG="$REPO/graphify-out/daily-refresh.log"

ts() { date "+%Y-%m-%d %H:%M:%S"; }

{
  echo "===== $(ts) START ====="
  if ! cd "$REPO"; then
    echo "$(ts) FEHLER: Repo nicht gefunden: $REPO"
    echo ""
    exit 1
  fi
  if ! command -v graphify >/dev/null 2>&1; then
    echo "$(ts) FEHLER: graphify nicht im PATH"
    echo ""
    exit 1
  fi

  echo "$(ts) graphify update . (nur lokaler AST-Cache — kein Obsidian-Export mehr, siehe Kommentar oben)"
  graphify update . 2>&1

  echo "$(ts) FERTIG"
  echo ""
} >> "$LOG" 2>&1
