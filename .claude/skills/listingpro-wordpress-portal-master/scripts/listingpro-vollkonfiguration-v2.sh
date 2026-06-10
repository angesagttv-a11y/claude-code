#!/bin/bash
#
# listingpro-vollkonfiguration-v2.sh
#
# Phase-1-Hauptskript fuer die Campus-Sparbuch-ListingPro-Vollkonfiguration.
# Deckt die in references/project-context.md genannten Phase-1-Bereiche ab,
# soweit das ohne Erfindung von Theme-Option-Schluesseln moeglich ist.
#
# WICHTIG: Vor dem produktiven Lauf Abschnitt 0 (Inspektion) ausfuehren und
# die Ausgabe von `listingpro_options` pruefen. Abschnitte, die konkrete
# Theme-Option-Keys brauchen, sind als TODO markiert und greifen erst nach
# Bestaetigung der echten Keys.
#
# Nutzung: bash listingpro-vollkonfiguration-v2.sh

set -e

# --- Local WP Wrapper (siehe references/wp-cli-local-wrapper.md) ---------
PHP="/Users/jessenikoi/Library/Application Support/Local/lightning-services/php-8.2.29+0/bin/darwin-arm64/bin/php"
WPCLI="/Applications/Local.app/Contents/Resources/extraResources/bin/wp-cli/wp-cli.phar"
WPROOT="/Users/jessenikoi/Local Sites/campus-sparbuch-dev/app/public"
SOCKET="/Users/jessenikoi/Library/Application Support/Local/run/BMqiTpNOs/mysql/mysqld.sock"
MYSQL_DIR="/Users/jessenikoi/Library/Application Support/Local/lightning-services/mysql-8.0.16+6/bin/darwin-arm64/bin"
export PATH="$MYSQL_DIR:$PATH"

wp() {
  "$PHP" -d "mysqli.default_socket=$SOCKET" "$WPCLI" "$@" --path="$WPROOT"
}

# --- Helper: idempotente Term-Erstellung ----------------------------------
ensure_term() {
  local taxonomy="$1"
  local name="$2"
  local slug="$3"

  if wp term get "$taxonomy" "$slug" --by=slug >/dev/null 2>&1; then
    echo "OK: $taxonomy/$slug existiert"
  else
    wp term create "$taxonomy" "$name" --slug="$slug"
    echo "ANGELEGT: $taxonomy/$slug"
  fi
}

# --- Helper: idempotente Paket-Erstellung (lp-packages) --------------------
ensure_package() {
  local title="$1"

  local package_id
  package_id=$(wp post list --post_type=lp-packages --title="$title" --field=ID | head -n 1)

  if [ -z "$package_id" ]; then
    package_id=$(wp post create --post_type=lp-packages --post_title="$title" --post_status=publish --porcelain)
    echo "ANGELEGT: Paket \"$title\" -> ID $package_id"
  else
    echo "OK: Paket \"$title\" existiert -> ID $package_id"
  fi

  echo "$package_id"
}

echo "=== Campus Sparbuch / ListingPro Vollkonfiguration v2 ==="
echo

# ============================================================================
# 0. Inspektion (immer ausfuehren, vor jeder Aenderung)
# ============================================================================
echo "--- 0. Inspektion ---"
wp core version
wp theme list
wp plugin list
echo

BACKUP_FILE="listingpro_options_before_$(date +%Y%m%d_%H%M%S).json"
wp option get listingpro_options --format=json > "$BACKUP_FILE"
echo "Backup geschrieben: $BACKUP_FILE"
echo

echo "Aktuelle Listings, Pakete, Terms:"
wp post list --post_type=listing --fields=ID,post_title,post_status --format=table
wp post list --post_type=lp-packages --fields=ID,post_title,post_status --format=table
wp term list listing_category --fields=term_id,name,slug,count --format=table
wp term list listing_location --fields=term_id,name,slug,count --format=table
wp term list listing_features --fields=term_id,name,slug,count --format=table
echo

# ============================================================================
# 1. Pricing Packages (Basis / Premium / Featured)
# ============================================================================
echo "--- 1. Pricing Packages ---"
BASIS_ID=$(ensure_package "Basis")
PREMIUM_ID=$(ensure_package "Premium")
FEATURED_ID=$(ensure_package "Featured")
echo

# TODO (manuell oder nach Pruefung der echten Meta-Keys automatisieren):
#   - Basis:    Preis 0 EUR / Jahr,  Listing-Limit 1
#   - Premium:  Preis 29 EUR / Jahr, Listing-Limit 3
#   - Featured: Preis 79 EUR / Jahr, Listing-Limit 5, Featured-Badge + Priority
#
# Vor dem Setzen der Meta-Keys pruefen:
#   wp post meta list "$PREMIUM_ID"
# und mit den tatsaechlichen ListingPro-2.9.x-Feldnamen abgleichen
# (siehe references/listingpro-feature-catalog.md, Abschnitt Monetarisierung).
echo "TODO: Paket-Metadaten (Preis, Laufzeit, Listing-Limit, Featured-Flag)"
echo "      erst nach 'wp post meta list <ID>' setzen, siehe Kommentar im Skript."
echo

# ============================================================================
# 2. Features / Amenities (12 filterbare Merkmale)
# ============================================================================
echo "--- 2. Features / Amenities ---"
#
# PLATZHALTER-LISTE: an das tatsaechliche Studentenrabatt-Angebot anpassen,
# bevor der Lauf produktiv erfolgt. Slugs sind bewusst kurz und URL-sicher.
declare -A FEATURES=(
  ["Kostenlos"]="kostenlos"
  ["Online einloesbar"]="online-einloesbar"
  ["Vor Ort einloesbar"]="vor-ort-einloesbar"
  ["Mit Studierendenausweis"]="mit-studierendenausweis"
  ["Kombinierbar mit anderen Aktionen"]="kombinierbar"
  ["Zeitlich limitiert"]="zeitlich-limitiert"
  ["Neu"]="neu"
  ["Dauerhaftes Angebot"]="dauerhaftes-angebot"
  ["Wochenend-Angebot"]="wochenend-angebot"
  ["Lieferung verfuegbar"]="lieferung-verfuegbar"
  ["Gruppenrabatt"]="gruppenrabatt"
  ["App erforderlich"]="app-erforderlich"
)

for name in "${!FEATURES[@]}"; do
  ensure_term "listing_features" "$name" "${FEATURES[$name]}"
done
echo

# ============================================================================
# 3. Theme Options: nicht verhandelbare Constraints
# ============================================================================
echo "--- 3. Theme Options: Constraints ---"
#
# Ziel-Zustand laut references/project-context.md:
#   - Self-Service / Frontend-Submission: aus
#   - JS-Minify: aus
#   - Preloader: aus
#   - Border-Radius: 0
#   - Auto-Renew: aus
#   - Primary  #E8318A, Secondary #0195B3, Hover #F06FAF
#   - Body-Font Open Sans 15px, Heading-Font Montserrat 800
#   - Waehrung EUR, Symbol € nach Betrag, Datumsformat d.m.Y
#
# Diese Werte duerfen NICHT blind in listingpro_options geschrieben werden
# (siehe references/wp-cli-local-wrapper.md, "Keine blinde Optionserfindung").
# Vorgehen:
#   1. wp option get listingpro_options --format=json | less
#   2. Die zu diesen Constraints gehoerenden Schluessel identifizieren
#      (z.B. Suche nach "minify", "preloader", "radius", "currency", "date_format",
#       "auto_renew", "frontend-submission", "primary_color", "font").
#   3. Pro bestaetigtem Schluessel einen gezielten
#      `wp option patch update listingpro_options <key> <value>`
#      Aufruf ergaenzen (WP-CLI `option patch` aendert nur den angegebenen
#      Pfad innerhalb des serialisierten Arrays, ohne den Rest zu ueberschreiben).
#
# Beispiel (NICHT aktiv, erst nach Bestaetigung des Keys einkommentieren):
#   wp option patch update listingpro_options frontend-submission 0
#   wp option patch update listingpro_options js_minify 0
#   wp option patch update listingpro_options preloader 0
#   wp option patch update listingpro_options border_radius 0
#   wp option patch update listingpro_options auto_renew 0
#   wp option patch update listingpro_options primary_color "#E8318A"
#   wp option patch update listingpro_options secondary_color "#0195B3"
#   wp option patch update listingpro_options hover_color "#F06FAF"
#   wp option patch update listingpro_options currency "EUR"
#   wp option patch update listingpro_options currency_position "after"
#   wp option patch update listingpro_options date_format "d.m.Y"
echo "TODO: Theme-Option-Keys gegen 'wp option get listingpro_options --format=json'"
echo "      pruefen und die passenden 'wp option patch' Zeilen oben einkommentieren."
echo

# ============================================================================
# 4. Listing Lifecycle
# ============================================================================
echo "--- 4. Listing Lifecycle ---"
# Laufzeit 365 Tage je Paket (siehe Abschnitt 1), Auto-Renew aus (Abschnitt 3).
# Konkrete Lifecycle-Optionen (Ablaufwarnung, Reaktivierung) erst nach
# Sichtung der lp-packages-Meta-Struktur konfigurieren.
echo "TODO: Lifecycle-Felder pro Paket nach 'wp post meta list <package_id>' setzen."
echo

# ============================================================================
# 5. Review-System
# ============================================================================
echo "--- 5. Review-System ---"
wp plugin status listingpro-reviews 2>/dev/null || echo "Hinweis: Plugin 'listingpro-reviews' nicht gefunden, Slug pruefen."
# Multi-Kriterien-Set, Moderation, ein Review pro Nutzer/Listing, Partner-Antwort:
# Konfiguration ueber ListingPro-Reviews-Plugin-Optionen, Keys vor Aenderung
# per 'wp option list --search="*review*"' ermitteln.
echo "TODO: Review-Plugin-Optionen pruefen (siehe references/listingpro-theme-operations.md)."
echo

# ============================================================================
# 6. Claim-System
# ============================================================================
echo "--- 6. Claim-System ---"
# Claims bleiben kostenlos und manuell geprueft (kein automatisches Approval).
# Button-Text: "Dieses Profil gehoert mir - Jetzt beanspruchen"
# Konkrete Claim-Option-Keys (z.B. "claim_price", "claim_requires_approval")
# vor Aenderung pruefen.
echo "TODO: Claim-Option-Keys pruefen, Preis auf 0 setzen, Approval-Pflicht aktiv lassen."
echo

# ============================================================================
# 7. E-Mail-Vorlagen
# ============================================================================
echo "--- 7. E-Mail-Vorlagen ---"
# SMTP-Zugang (smtp.variomedia.de:587, TLS) ist browserpflichtig
# (WP Admin -> WP Mail SMTP -> Settings) und wird hier NICHT gesetzt.
# Vorlagentexte (Claim-Bestaetigung, Nachricht erhalten, Paket gekauft)
# koennen ueber ListingPro-Theme-Options bzw. WP Mail SMTP Email-Templates
# gepflegt werden, sobald die Keys bestaetigt sind.
echo "TODO: E-Mail-Vorlagentexte nach Bestaetigung der Optionsstruktur pflegen."
echo "BROWSER-PFLICHTIG: SMTP-Passwort in WP Mail SMTP eintragen."
echo

# ============================================================================
# 8. SEO (Rank Math) - browserpflichtig
# ============================================================================
echo "--- 8. Rank Math ---"
echo "BROWSER-PFLICHTIG: Rank Math Setup Wizard manuell durchfuehren."
wp plugin status seo-by-rank-math 2>/dev/null || echo "Hinweis: Rank-Math-Plugin-Slug pruefen."
echo

# ============================================================================
# 9. Cache (WP Fastest Cache)
# ============================================================================
echo "--- 9. WP Fastest Cache ---"
# CSS-Minify darf an sein, JS-Minify bleibt aus (siehe Constraints).
wp plugin status wp-fastest-cache 2>/dev/null || echo "Hinweis: WP-Fastest-Cache-Plugin-Slug pruefen."
echo "TODO: CSS-Minify aktivieren, JS-Minify deaktiviert lassen, Optionen pruefen mit"
echo "      'wp option get WpFastestCache --format=json' (Optionsname je nach Version)."
echo

# ============================================================================
# 10. Partner-Dashboard
# ============================================================================
echo "--- 10. Partner-Dashboard ---"
# Dashboard-Sichtbarkeit (Listing bearbeiten, Leads, Reviews, Ads) haengt an
# Claim-Status (lp_listingpro_options.claimed_section, siehe
# references/bulk-import-addon.md) und an den Theme-Option-Keys fuer
# Dashboard-Module. Vor Aktivierung/Deaktivierung einzelner Module die
# vorhandenen Keys auflisten.
echo "TODO: Dashboard-Modul-Keys pruefen und gegen Partner-Anforderungen abgleichen."
echo

# ============================================================================
# Zusammenfassung
# ============================================================================
echo "=== Zusammenfassung ==="
echo "Erledigt: Backup, Pricing-Pakete (IDs $BASIS_ID / $PREMIUM_ID / $FEATURED_ID),"
echo "          12 Features/Amenities (idempotent)."
echo "Offen:    Alle TODO-Abschnitte oben - erfordern Bestaetigung der echten"
echo "          listingpro_options-Keys vor scriptgestuetzter Aenderung."
echo "Browser:  SMTP-Passwort, Rank-Math-Wizard (siehe Abschnitte 7 und 8)."
