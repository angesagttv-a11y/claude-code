# WP-CLI Local Wrapper und Skriptregeln

## Pflicht-Wrapper

Alle Bash-Skripte für das Campus-Sparbuch-Portal müssen mit diesem Wrapper starten. Verwende nicht den globalen `wp`-Befehl, weil Local by WP Engine auf macOS eigene PHP-, WP-CLI- und MySQL-Socket-Pfade nutzt.

```bash
#!/bin/bash
set -e

PHP="/Users/jessenikoi/Library/Application Support/Local/lightning-services/php-8.2.29+0/bin/darwin-arm64/bin/php"
WPCLI="/Applications/Local.app/Contents/Resources/extraResources/bin/wp-cli/wp-cli.phar"
WPROOT="/Users/jessenikoi/Local Sites/campus-sparbuch-dev/app/public"
SOCKET="/Users/jessenikoi/Library/Application Support/Local/run/BMqiTpNOs/mysql/mysqld.sock"
MYSQL_DIR="/Users/jessenikoi/Library/Application Support/Local/lightning-services/mysql-8.0.16+6/bin/darwin-arm64/bin"
export PATH="$MYSQL_DIR:$PATH"

wp() {
  "$PHP" -d "mysqli.default_socket=$SOCKET" "$WPCLI" "$@" --path="$WPROOT"
}
```

## Skriptstandard

Jedes Skript muss idempotent, lesbar und rückbaubar sein. Es darf bei einem zweiten Lauf keine doppelten Terms, Pakete, Pages, Optionen oder Benutzer erzeugen.

| Regel | Umsetzung |
|---|---|
| Idempotenz | Vor `create` immer `get`, `list` oder Slug-/Title-Lookup ausführen. |
| Sichtbare Logs | Mit `echo` Statusabschnitte ausgeben. Keine stillen Massenänderungen. |
| Kein Credential-Leak | Keine Passwörter, API Keys oder SMTP Secrets in Skripte schreiben. |
| Fehlerstopp | `set -e` verwenden, damit defekte Zwischenschritte nicht verdeckt werden. |
| Keine blinde Optionserfindung | Vor `wp option update listingpro_options` vorhandene Struktur prüfen. |
| Backup bei riskanten Änderungen | Vor Datenmigration oder Plugin-Dateiänderung Export oder Kopie anlegen. |

## Prüfkommandos

Nutze diese Muster, bevor du konfigurierst oder debugst.

```bash
wp core version
wp theme list
wp plugin list
wp option get listingpro_options --format=json
wp post list --post_type=listing --fields=ID,post_title,post_status --format=table
wp post list --post_type=lp-packages --fields=ID,post_title,post_status --format=table
wp term list listing_category --fields=term_id,name,slug,count --format=table
wp term list listing_location --fields=term_id,name,slug,count --format=table
wp term list listing_features --fields=term_id,name,slug,count --format=table
```

## Sichere Update-Muster

### Option als JSON sichern

```bash
wp option get listingpro_options --format=json > listingpro_options_before_$(date +%Y%m%d_%H%M%S).json
```

### Term idempotent anlegen

```bash
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
```

### Paket nicht doppelt anlegen

```bash
package_id=$(wp post list --post_type=lp-packages --title="Premium" --field=ID | head -n 1)
if [ -z "$package_id" ]; then
  package_id=$(wp post create --post_type=lp-packages --post_title="Premium" --post_status=publish --porcelain)
  echo "ANGELEGT: Premium Paket ID $package_id"
else
  echo "OK: Premium Paket existiert ID $package_id"
fi
```

Prüfe die echten Meta Keys im lokalen System, bevor du Paket-Meta schreibst.

## Browser-only nicht simulieren

Diese Punkte müssen im Browser oder Admin erledigt werden. Claude Code soll sie als offene Aufgaben dokumentieren, nicht durch Dummy-Werte ersetzen.

| Aufgabe | Warum nicht per Skript |
|---|---|
| SMTP-Passwort | Secret-Eingabe |
| Logo/Favicon | Medienauswahl und visuelle Prüfung |
| Google Maps API Key | Secret/API-Konfiguration |
| Google/Apple Social Login Keys | OAuth-Secrets |
| Complianz Wizard | Rechts-/DSGVO-Entscheidungen |
| Rank Math Wizard | SEO-Assistent und Bestätigung |

## Verifikation nach Skriptlauf

Nach jedem Skriptlauf mindestens diese Punkte prüfen: Exit-Code, Plugin-Status, Option-Backup, relevante Terms, relevante Posts, Fehlerlog, sichtbare Admin-Objekte und Frontend-Basistest. Wenn ein Schritt nicht prüfbar ist, als Annahme markieren.
