# Campus Sparbuch Projektkontext

## Projektdefinition

Campus Sparbuch ist ein kuratiertes Online-Verzeichnis für Studentenrabatte im DACH-Raum. Studierende finden verifizierte Rabattangebote in ihrer Stadt. Partner erscheinen als geprüfte Listings; das Claim-System erzeugt Leads und ermöglicht später Upsells.

Das Portal basiert auf **WordPress**, **ListingPro Theme v2.9.10** und **CubeWP Framework**. Es ist kein generisches Coupon-Blog-System und kein offener Marketplace. Das Team trägt Partner intern ein. Frontend-Self-Service bleibt deaktiviert, weil Qualität, Datenkonsistenz und Akquisesteuerung Vorrang haben.

## Aktueller Stand

| Bereich | Stand |
|---|---|
| Phase | Phase 1 von 5 |
| Fokus | Vollkonfiguration per Skript |
| Nächster Schritt | `bash listingpro-vollkonfiguration-v2.sh` ausführen |
| Phase 0 | Abgeschlossen |
| Fortschritt | ca. 20 Prozent |
| Kritischer Blocker | Hauptskript muss vor Bulk Import, Browser-Schritten und Deployment laufen |

## Abgeschlossene Basis

| Element | Status |
|---|---|
| WordPress Core, Child Theme, ListingPro Plugin, CubeWP | Aktiv |
| Permalinks | Konfiguriert |
| 20 Kategorien mit Lucide Icons | Angelegt |
| Städte/Locations | Angelegt |
| Bewertungs-Shortcode `[cs_rating]` und AJAX | Eingebunden |
| Wordfence Security | Aktiv |
| Nextend Social Login | Aktiv |
| Salzburg als Stadt mit 7 Listings | Angelegt |

## Offene v1-Anforderungen

Phase 1 muss Theme Options, 12 Features/Amenities, 3 Pricing Packages, Review- und Claim-System, E-Mail-Vorlagen, Rank Math, WP Fastest Cache, Listing Lifecycle und Partner-Dashboard-Konfiguration erledigen.

Phase 2 richtet WP All Import ein, erstellt ein CSV-Template und importiert Test-Listings.

Phase 3 umfasst die sechs browserpflichtigen Schritte, Duplicator-Export und Deployment auf DomainFactory.

## Roadmap

| Phase | Ziel | Status |
|---|---|---|
| 0 | Basis-Setup: WordPress, ListingPro, CubeWP, Kategorien, Städte, Icons, Reviews, Security | Abgeschlossen |
| 1 | Vollkonfiguration über `listingpro-vollkonfiguration-v2.sh` | Bereit |
| 2 | Bulk Import Setup mit WP All Import | Offen |
| 3 | Manuelle Admin-Schritte und Deployment | Offen |
| 4 | Stripe Integration | Nach Go-live |
| 5 | Traffic, Claims, Featured-Upsell | Nach Go-live |

## Business-Entscheidungen

| Entscheidung | Bedeutung für Claude Code |
|---|---|
| Kein Self-Service | Keine offenen Frontend-Submission-Flows aktivieren. |
| Claim kostenlos | Claim dient Lead-Akquise, nicht Checkout-Hürde. |
| Featured als Default-Sort | Bezahlte Sichtbarkeit ist Teil der Monetarisierung. |
| Keine Preise auf Cards | Rabattinformation schlägt Preis-Kommunikation auf Listing Cards. |
| Stripe später | Für MVP keine Zahlungskomplexität erzwingen. |
| Duplicator Deployment | Migration zu DomainFactory über Duplicator vorbereiten. |

## Projektkonfiguration

| Feld | Wert |
|---|---|
| Domain | `campussparbuch.de` |
| E-Mail | `info@campus-sparbuch.de` |
| SMTP | `smtp.variomedia.de`, Port `587`, TLS |
| Deployment-Ziel | DomainFactory |
| Betreiber | Jesse Nikoi, Crossmedial Gruppe, Gütersloh |

## Datenmodell

| Konzept | Technische Struktur |
|---|---|
| Listings | Post Type `listing` |
| Kategorien | Taxonomie `listing_category` |
| Orte | Taxonomie `listing_location` |
| Features/Amenities | Taxonomie `listing_features` |
| Pricing Packages | Post Type `lp-packages` |
| ListingPro Optionen | WordPress Option `listingpro_options` |

## Marken- und UI-Entscheidungen

| Element | Vorgabe |
|---|---|
| Primary | `#E8318A` |
| Secondary | `#0195B3` |
| Button Hover | `#F06FAF` |
| Body Font | Open Sans, 15px |
| Heading Font | Montserrat, Weight 800 |
| Border Radius | `0` |
| Währung | EUR, `€`, Position nach Betrag |
| Datum | `d.m.Y` |

## Browserpflichtige Schritte

Diese Aufgaben nicht per WP-CLI vortäuschen. Sie brauchen WordPress Admin, API-Schlüssel oder geheime Eingaben.

| Schritt | Ort |
|---|---|
| WP Mail SMTP Passwort setzen | WP Admin → WP Mail SMTP → Settings |
| Logo und Favicon hochladen | WP Admin → Appearance → Customize → Site Identity |
| Google Maps API Key eintragen | WP Admin → ListingPro → Theme Options → Maps |
| Google/Apple Social Login Keys eintragen | WP Admin → Nextend Social Login |
| Complianz DSGVO Wizard durchführen | WP Admin → Complianz → Setup Wizard |
| Rank Math Setup Wizard durchführen | WP Admin → Rank Math → Setup Wizard |

## Skript-Ökosystem

| Skript | Zweck |
|---|---|
| `listingpro-vollkonfiguration-v2.sh` | Hauptskript für 17 Konfigurationsbereiche (Entwurf in `scripts/`, lauffähige Teile: Backup, Pricing Packages, Features/Amenities; restliche Bereiche als TODO mit Inspektionsschritten) |
| `bulk-import-listings-v2.sh` | WP All Import, CSV-Template, 5 Test-Listings |
| `salzburg-listings-v2.sh` | 7 Salzburg-Listings |
| `bewertung-feature-v2.sh` | Review-System, AJAX, Shortcode |
| `kategorie-icons-v2.sh` | 20 Kategorie-Icons, PHP-Funktionen |

## Nicht verhandelbare Constraints

Self-Service bleibt deaktiviert: `frontend-submission = 0`. JS-Minify bleibt deaktiviert. Preloader bleibt deaktiviert. Border-Radius bleibt `0`. Auto-Renew bleibt deaktiviert. Mobile App ist out of scope. Footer/Blog/Misc Widgets werden manuell im Admin bearbeitet, nicht per Skript.
