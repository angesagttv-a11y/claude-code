#!/usr/bin/env bash
#
# setup-graphify-workplace.sh
#
# Idempotenter Bootstrap für die Kombination Graphify + Obsidian + Claude Code
# in einem bestehenden, nummerierten Workplace (PARA-ähnliche Struktur).
#
# Dieses Skript wird LOKAL auf deinem Rechner ausgeführt (nicht im Sandbox-
# Repo). Es nimmt keine Annahmen über echte Ordnernamen vor - alle Pfade
# kommen als Flags rein. Es ist idempotent: erneutes Ausführen überschreibt
# keine bestehenden Dateien, sondern überspringt sie.
#
# Siehe docs/workplace-graphify-obsidian-setup.md für das Gesamtkonzept.
#
# Beispiel:
#   ./scripts/setup-graphify-workplace.sh \
#       --vault   "$HOME/Workplace/Obsidian" \
#       --code-root "$HOME/Workplace/60_DEV_AGENTEN_TOOLS/mein-projekt" \
#       --platform claude --platform codex
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$REPO_ROOT/docs/workplace-setup/templates"

# --- Defaults --------------------------------------------------------------
VAULT_ROOT=""
CODE_ROOT=""
WORKSPACE_ROOT="${GRAPHIFY_WORKSPACE_ROOT:-}"
PLATFORMS=()
DO_INSTALL_GRAPHIFY=1
DO_OBSIDIAN_SKILLS=1
DRY_RUN=0

# Ordnernamen (Basename), die niemals als --code-root oder --vault verwendet
# werden dürfen, egal an welcher Stelle im Workspace sie liegen.
FORBIDDEN_BASENAMES=(
  "30_PRIVAT"
  "PRIVAT"
  "20_FIRMEN_FINANZEN_RECHT"
  "50_MEDIEN_ASSETS"
  "70_ARCHIV_INDEX"
  "10_AKTIV"
)

usage() {
  cat <<'EOF'
Usage: setup-graphify-workplace.sh [Optionen]

  --vault <pfad>         Wurzel des Obsidian-Vaults (z.B. .../Workplace/Obsidian)
  --code-root <pfad>     Code-Root, auf den Graphify zeigen soll (Git-Repo o.ä.)
  --workspace-root <pfad> Wurzel des Gesamt-Workspace (z.B. .../Workplace).
                         Wird selbst als Ziel/Scan-Root abgelehnt. Kann auch
                         über die Umgebungsvariable GRAPHIFY_WORKSPACE_ROOT
                         gesetzt werden.
  --platform <name>      Agenten-Plattform für graphify install (mehrfach erlaubt:
                         claude, codex, gemini, cursor, windows, kiro, devin, ...)
                         Default: claude
  --skip-graphify        'uv tool install graphifyy && graphify install' überspringen
  --skip-obsidian-skills Obsidian-Skills (kepano/obsidian-skills) nicht installieren
  --dry-run              Nur anzeigen, was passieren würde - nichts schreiben
  -h, --help             Diese Hilfe

Sicherheit:
  - Folgende Ordnernamen werden als --code-root/--vault/--workspace-root
    IMMER abgelehnt (egal wo sie im Baum liegen):
      30_PRIVAT, PRIVAT, 20_FIRMEN_FINANZEN_RECHT, 50_MEDIEN_ASSETS,
      70_ARCHIV_INDEX, 10_AKTIV
  - Pfade UNTERHALB von 30_PRIVAT/, 20_FIRMEN_FINANZEN_RECHT/,
    50_MEDIEN_ASSETS/ oder 70_ARCHIV_INDEX/ werden ebenfalls abgelehnt.
  - Wird --workspace-root angegeben, wird zusätzlich der Workspace-Root
    selbst als --code-root/--vault abgelehnt.
  - Bestehende Dateien werden NICHT überschrieben (idempotent).
EOF
}

# --- Argumente parsen ------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault)              VAULT_ROOT="${2:-}"; shift 2 ;;
    --code-root)          CODE_ROOT="${2:-}"; shift 2 ;;
    --workspace-root)     WORKSPACE_ROOT="${2:-}"; shift 2 ;;
    --platform)           PLATFORMS+=("${2:-}"); shift 2 ;;
    --skip-graphify)      DO_INSTALL_GRAPHIFY=0; shift ;;
    --skip-obsidian-skills) DO_OBSIDIAN_SKILLS=0; shift ;;
    --dry-run)            DRY_RUN=1; shift ;;
    -h|--help)            usage; exit 0 ;;
    *) echo "Unbekannte Option: $1" >&2; usage; exit 1 ;;
  esac
done

[[ ${#PLATFORMS[@]} -eq 0 ]] && PLATFORMS=("claude")

# --- Helpers ---------------------------------------------------------------
log()  { printf '  %s\n' "$*"; }
step() { printf '\n==> %s\n' "$*"; }
run()  {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '  [dry-run] %s\n' "$*"
  else
    eval "$*"
  fi
}

# Best-effort absoluter, normalisierter Pfad - auch für (noch) nicht
# existierende Pfade. Fällt auf den Eingabewert zurück, falls python3 fehlt.
_normalize_path() {
  local p="$1"
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$p" <<'PY'
import os, sys
print(os.path.abspath(os.path.expanduser(sys.argv[1])))
PY
  else
    printf '%s\n' "$p"
  fi
}

guard_forbidden_path() {
  # Lehnt gesperrte Bereiche (privat, rechtlich/finanziell, Medien, Archiv,
  # Projektanker-Sammelordner, Workspace-Root) als Ziel-/Scan-Pfad ab.
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

copy_if_absent() {
  # copy_if_absent <quelle> <ziel>
  local src="$1" dst="$2"
  if [[ -e "$dst" ]]; then
    log "vorhanden, übersprungen: $dst"
    return 0
  fi
  run "mkdir -p \"$(dirname "$dst")\""
  run "cp \"$src\" \"$dst\""
  log "angelegt: $dst"
}

# --- 1. Graphify installieren ---------------------------------------------
if [[ "$DO_INSTALL_GRAPHIFY" -eq 1 ]]; then
  step "Graphify installieren"
  if command -v graphify >/dev/null 2>&1; then
    log "graphify ist bereits installiert ($(command -v graphify))"
  else
    if command -v uv >/dev/null 2>&1; then
      run "uv tool install graphifyy"
    else
      log "WARNUNG: 'uv' nicht gefunden. Installiere uv (https://docs.astral.sh/uv/) und führe dann 'uv tool install graphifyy' aus."
    fi
  fi

  for plat in "${PLATFORMS[@]}"; do
    step "graphify install für Plattform: $plat"
    if [[ -n "$CODE_ROOT" ]]; then
      guard_forbidden_path "$CODE_ROOT"
      run "(cd \"$CODE_ROOT\" && graphify install --project --platform \"$plat\")"
    else
      run "graphify install --platform \"$plat\""
    fi
  done
fi

# --- 2. .graphifyignore in den Code-Root ----------------------------------
if [[ -n "$CODE_ROOT" ]]; then
  guard_forbidden_path "$CODE_ROOT"
  step "Code-Root vorbereiten: $CODE_ROOT"
  if [[ ! -d "$CODE_ROOT" ]]; then
    run "mkdir -p \"$CODE_ROOT\""
    log "Code-Root angelegt: $CODE_ROOT"
  fi
  copy_if_absent "$TEMPLATE_DIR/graphifyignore.template" "$CODE_ROOT/.graphifyignore"
  log "Nächster Schritt im Code-Root:  cd \"$CODE_ROOT\" && /graphify ."
fi

# --- 3. Obsidian-Skills in den Vault --------------------------------------
if [[ -n "$VAULT_ROOT" ]]; then
  guard_forbidden_path "$VAULT_ROOT"
  step "Obsidian-Vault vorbereiten: $VAULT_ROOT"
  if [[ ! -d "$VAULT_ROOT" ]]; then
    echo "ABBRUCH: Vault-Pfad '$VAULT_ROOT' existiert nicht. Lege den Vault erst in Obsidian an." >&2
    exit 1
  fi

  if [[ "$DO_OBSIDIAN_SKILLS" -eq 1 ]]; then
    SKILLS_DST="$VAULT_ROOT/.claude/skills"
    if [[ -d "$SKILLS_DST" && -n "$(ls -A "$SKILLS_DST" 2>/dev/null)" ]]; then
      log "Obsidian-Skills bereits vorhanden in $SKILLS_DST - übersprungen"
    else
      TMP_CLONE="$(mktemp -d)"
      run "git clone --depth 1 https://github.com/kepano/obsidian-skills \"$TMP_CLONE\""
      run "mkdir -p \"$SKILLS_DST\""
      run "cp -r \"$TMP_CLONE\"/skills/* \"$SKILLS_DST\"/"
      run "rm -rf \"$TMP_CLONE\""
      log "Obsidian-Skills installiert nach $SKILLS_DST"
    fi
  fi
fi

step "Fertig"
log "Graphify-Artefakte landen projektlokal unter <code-root>/graphify-out/."
log "Kuratierte Inhalte gehören in den Vault (10_PROJEKTE, 40_ENTSCHEIDUNGEN, ...)."
log "Details: docs/workplace-graphify-obsidian-setup.md"
[[ "$DRY_RUN" -eq 1 ]] && log "(dry-run: es wurde nichts geschrieben)"
