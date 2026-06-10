# ListingPro Theme Operations

## Grundsatz

ListingPro ist eine End-to-End-Directory-Lösung. Für Campus Sparbuch gilt: Zuerst die nativen ListingPro-Funktionen prüfen, dann Addons oder eigene Erweiterungen bewerten, und erst danach externe Systeme wie WooCommerce einführen. Externe Plugins erhöhen Wartung, Konflikte und Deployment-Risiko.

## Core-Plugins und unterstützte Plugins

| Kategorie | Plugins / Bedeutung |
|---|---|
| ListingPro Core | ListingPro Plugin, ListingPro Ads, ListingPro Reviews, ListingPro Appointments |
| Enthaltene Drittanbieter | Nextend Social Login, Redux Framework, WPBakery, Elementor |
| Unterstützt, aber nicht Core | WP All Import, Loco Translate, WPForms für Kontaktformulare |

ListingPro-Support deckt nicht beliebige Drittanbieter-Plugins ab. Wenn eine Lösung ein Drittplugin benötigt, dokumentiere den Grund, das Risiko und den Rollback-Pfad.

## Native Monetarisierung

ListingPro unterstützt mehrere Erlöswege. Campus Sparbuch nutzt davon für das MVP primär Pricing Packages, Featured-Sichtbarkeit und kostenlose Claims als Lead-Hebel.

| Erlöslogik | ListingPro-Fähigkeit | Campus-Sparbuch-Entscheidung |
|---|---|---|
| Paid Pricing Plans | Kostenlose und bezahlte Pläne, einmalig oder recurring | Basis 0 €, Premium 29 €, Featured 79 € |
| Paid Claim | Claims können kostenpflichtig sein | Für Campus Sparbuch kostenlos lassen |
| Ads Campaigns | Spotlight, Top of Search, Sidebar | Nach Traffic-Aufbau, nicht MVP |
| Sponsored Listings | Hero-/Banner-Sichtbarkeit | Später als Sponsoringlogik prüfen |
| Payment Gateways | Stripe, PayPal Express, 2Checkout, Direct/Wire Transfer built-in | Stripe nach Go-live prüfen |

## Payment-Entscheidungsregel

Prüfe Zahlungen in dieser Reihenfolge.

| Rang | Option | Bewertung |
|---|---|---|
| 1 | ListingPro-native Direct/Wire Transfer | MVP-tauglich, geringe Komplexität, manuelle Freigabe möglich |
| 2 | ListingPro-native Stripe | Naheliegend für v1.1, wenn Checkout sauber funktioniert |
| 3 | ListingPro Payment Hooks / offizielles Gateway-Addon | Nur wenn native Gateways nicht reichen |
| 4 | WooCommerce | Nur mit klarer Begründung, weil es ein zweites Commerce-System einführt |

Für Campus Sparbuch keine WooCommerce-Architektur empfehlen, bevor ListingPro-native Stripe-, Direct-Transfer- und Payment-Hook-Optionen geprüft wurden.

## Pricing Packages

Die Pakete sind als Post Type `lp-packages` zu behandeln. Prüfe vor dem Anlegen vorhandene Pakete per `wp post list --post_type=lp-packages`. Verwende lookup-before-create, damit Re-Runs keine Duplikate erzeugen.

| Paket | Preis | Laufzeit | Listing-Limit | Zweck |
|---|---:|---:|---:|---|
| Basis | 0 €/Jahr | 365 Tage | 1 | Kostenloser Einstieg und Claim-Akquise |
| Premium | 29 €/Jahr | 365 Tage | 3 | Bezahltes Partnerprofil |
| Featured | 79 €/Jahr | 365 Tage | 5 | Sichtbarkeit, Featured Badge, Priorität |

Prüfe Meta Keys im echten System, bevor du Paket-Metadaten setzt. ListingPro-Versionen können Meta-Strukturen ändern.

## Claim-System

Claims bleiben kostenlos und manuell geprüft. Der Claim-Button lautet: „Dieses Profil gehört mir – Jetzt beanspruchen“. Keine Automatik einbauen, die Besitzansprüche ohne Admin-Prüfung bestätigt. Nachweis der Inhaberschaft ist erforderlich.

Ein guter Claim-Flow sammelt Kontaktdaten, Business-Nachweis, Listing-Referenz und Freigabestatus. Er darf das interne Kurationsmodell nicht in offenen Self-Service umwandeln.

## Review-System

ListingPro Reviews ist ein Core-Plugin. Campus Sparbuch nutzt zusätzlich den Shortcode `[cs_rating]` mit AJAX. Reviews erfordern eingeloggte Nutzer, Moderation, keine Mehrfachreviews pro Nutzer und Listing sowie Antwortmöglichkeit für Partner.

Prüfe `listingpro-reviews` Plugin-Status und vorhandene Review-Optionen, bevor du eigene Review-Logik ergänzt. Custom Code gehört in Child Theme oder kontrolliertes Plugin.

## Datenimport mit WP All Import

ListingPro unterstützt WP All Import plus `listingpro-Bulk-import-addon.zip`. Der CSV-Import läuft über `All Import > New Import > New Items > Listings`. Zu mappen sind Listing-Felder, Gallery Images, Kategorien, Features, Tags und Locations. Der Unique Identifier soll bewusst gesetzt werden, um Updates statt Duplikate zu ermöglichen.

| Feldgruppe | Mapping-Hinweis |
|---|---|
| Listing-Basis | Titel, Beschreibung, Adresse, Kontakt, Website, Öffnungszeiten |
| Taxonomien | `listing_category`, `listing_location`, `listing_features`, Tags |
| Rabattdaten | Rabatt, Coupon-Code, QR-Code als Zusatzfelder oder Meta prüfen |
| Medien | Gallery Images mappen; Business Logo braucht Sonderprüfung |
| IDs | Stabile externe ID nutzen, nicht nur Titel |

Business-Logo-Import ist laut ListingPro-Dokumentation nicht standardmäßig als CSV-Feld verfügbar. Die Knowledgebase beschreibt eine Änderung an `listingpro-add-on.php`. Für Campus Sparbuch gilt: Diese Änderung nur nach Backup, Child-/Plugin-Strategie und Rollback-Plan durchführen.

## Features, Kategorien und Locations

Features gehören in `listing_features`, Kategorien in `listing_category`, Orte in `listing_location`. Lege Terms idempotent an. Prüfe Slugs, Parent-Child-Beziehungen und Frontend-Filter. Für Campus Sparbuch müssen 12 Features/Amenities filterbar sein.

## Maps

ListingPro enthält OpenStreetMap. Google Maps ist für erweiterte Standortsuche relevant und benötigt einen API Key. Den Google Maps API Key nicht in Skripten hartcodieren. Dieser Schritt ist browserpflichtig und gehört in WP Admin → ListingPro → Theme Options → Maps.

## Ads Campaigns

ListingPro Ads unterstützt drei Platzierungen: Spotlight, Top of Search und Sidebar. Spotlight läuft über WPBakery-Elemente, Top of Search erscheint über organischen Suchergebnissen, Sidebar Ads werden über Widgets in Listing Details Sidebar und Listing Archive Sidebar platziert.

Campus Sparbuch behandelt Ads als spätere Phase. Nicht im MVP aktivieren, wenn dadurch Dashboard, Payment oder Partnerkommunikation komplexer wird.

## Cache und Minify

WP Fastest Cache darf CSS minifizieren, aber JS-Minify bleibt aus. ListingPro nutzt eigene Scripts, Maps, AJAX und Dashboard-Funktionen; JS-Minify kann schwer sichtbare Konflikte erzeugen. Nach Listing-Importen Cache leeren und Frontend-Suche prüfen.

## Version und Kompatibilität

ListingPro 2.9.x enthält relevante Fixes für PHP 8.2, Stripe-Checkout, Redux/WPBakery, Business Logo, Formularfelder, Imports, Features, Claim, Reviews, Maps, Mobile und Dashboard. Prüfe Theme- und Plugin-Versionen vor Debugging. Manche Fehler sind Versionsprobleme, keine Projektlogikfehler.

## Quellen

| Nr. | Quelle |
|---|---|
| [1] | ListingPro Documentation FAQ: https://docs.listingprowp.com/ |
| [2] | ListingPro Bulk Import Knowledgebase: https://docs.listingprowp.com/knowledgebase/how-to-import-bulk-listings/ |
| [3] | ListingPro Extra Plugins Knowledgebase: https://docs.listingprowp.com/knowledgebase/do-i-need-extra-plugins/ |
| [4] | ListingPro Ads Campaign Knowledgebase: https://docs.listingprowp.com/knowledgebase/how-to-create-ads-campaign/ |
| [5] | ListingPro Payment Gateway FAQ: https://docs.listingprowp.com/faq/integrate-with-other-payment-gateway/ |
| [6] | ListingPro Update Logs: https://listingprowp.com/update-logs/ |
