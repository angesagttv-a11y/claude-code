---
type: daily_input
date: 2026-10-01
agent: Claude Regular
system: Claude_Regular
project: Campus Sparbuch
object: [campus-sparbuch-website-audit]
object_type: Projekt
handoff_target: Jesse
status: teilweise_erledigt
created_at: 2026-10-01 16:40
---
# Daily Input – Claude Regular – 2026-10-01 – Campus Sparbuch

## Kurzlage
Externe, rein lesende Analyse von campus-sparbuch.de ist durch: 508 Sitemap-URLs, 5 Kernseiten je Mobile und Desktop im Browser, Accessibility mit axe, Consent-Verhalten. Technisch und SEO-seitig ist die Seite sauber, Consent funktioniert. Der größte Hebel ist die Ladezeit (LCP 3,8 bis 5,5 s in meiner Messumgebung). Danach folgen Kontrast und Tap-Ziele sowie ein Widerspruch zwischen Design-Regel (`border-radius: 0`) und Live-Stand (Pill-Buttons). Nicht getestet: Backend, Formulare, Login, Claim, Zahlung, Suche und Filter.

## Erledigt
- Domain-Verhalten gemessen: `https://campus-sparbuch.de` 200, `www.` und `http://` per 301 auf die Hauptdomain.
- 508 Sitemap-URLs gecrawlt: alle 200, alle mit Title, Description, Canonical (selbstreferenzierend), genau 1 H1, kein noindex, JSON-LD überall. Alle 208 Listings haben BreadcrumbList, PostalAddress, GeoCoordinates, 140 davon Offer.
- Consent: Vor Einwilligung 0 Drittanbieter-Requests, 0 Cookies, Google Maps nur per Zwei-Klick-Platzhalter. Schriften selbst gehostet. Meine Hypothese eines DSGVO-Problems bei Maps ist damit widerlegt.
- Rechtstexte: keine sichtbaren Platzhalter (`[PLZ]` etc.) auf Impressum, Datenschutz, AGB, Barrierefreiheit, KI-Transparenz und auf keiner der 508 URLs. Impressum nennt HRB 11900, AG Gütersloh. Der Skill-Stand vom 02.08. (offener Punkt 4) ist auf Live überholt.
- Performance, Accessibility, Layout auf Startseite, Angebote, Listing, Kategorie, Für Unternehmen gemessen (Details unten).

## Weiterarbeiten
- **Performance (Hoch):** Startseite lädt 1,5 bis 2,6 MB, 104 bis 124 Requests, 51 render-blockierende Ressourcen. Größte Posten: `listingpro/assets/css/main.css` (130 KB übertragen, 804 KB entpackt), `jquery-ui.js` (655 KB entpackt), `mapbox.js`, `prettyphoto.css` (361 KB entpackt, auf der Startseite vermutlich ungenutzt). 43 von 113 Bildern sind mehr als doppelt so groß wie ihre Anzeigegröße. Messwerte (mobil 375 px, Cloud-Umgebung, TTFB ca. 1 s durch Proxy, also zu pessimistisch): FCP 3,6 bis 4,8 s, LCP 3,9 bis 5,5 s, CLS 0 bis 0,065. Nächster Schritt: echte Messung mit PageSpeed Insights, dann CSS/JS pro Template entladen (Constraint beachten: kein JS-Minify).
- **Kontrast (Hoch, schneller Fix):** `#7f7f7f` auf Weiß = 4,0:1, Soll 4,5:1. Betrifft v. a. die „präsentiert von“-Zeilen in Karten (3 bis 12 Stellen je Seite). Fix: Textfarbe auf `#767676` oder dunkler. Dazu `link-in-text-block` auf Für-Unternehmen.
- **Tap-Ziele:** 8 bis 16 Links/Buttons je Seite unter 24 px Kantenlänge.
- **Landmarks:** Listing-Seite hat doppeltes `banner` und nicht eindeutige Landmarks, viele Inhalte außerhalb von Regionen (axe `region`, moderat).
- **Cookie-Banner mobil:** deckt ca. 55 % des Viewports und verdeckt den Hero. Funktional korrekt (Akzeptieren, Ablehnen, Einstellungen), aber ein Conversion- und LCP-Faktor. Kompakteren Banner prüfen.
- **Security-Hygiene:** keine Content-Security-Policy. `wp-login.php` und `license.txt` öffentlich erreichbar. Gut: `xmlrpc.php` 405, User-Endpoint 404, `readme.html` 403, keine Debug- oder Backup-Dateien erreichbar.
- **SEO-Feinschliff:** 2 doppelte Titles („Über uns | Campus Sparbuch“, „Frankfurter Sparkasse | Campus Sparbuch“), 2 Titles über 60 Zeichen, 5 Descriptions über 160 und 2 unter 70 Zeichen.

## Nicht vollständig erledigt
- Backend-Checks (Taxonomy-Slug, Child-Theme, Migration `_cs_rabatt_*`): kein Novamira-Zugang in dieser Session, nicht geprüft. Live-URLs zeigen `listing-category`, das spricht für den Bindestrich-Slug, ist aber keine Registrierungsprüfung.
- Funktionstests (Suche, Filter, Formulare, Anmelden, Claim, Zahlung): bewusst nicht ausgeführt. Nichts abgesendet, nichts eingewilligt, kein Login.
- Echte Mobilgeräte, Safari, Firefox: nicht getestet (nur Chromium).
- Domain `campussparbuch.de` ohne Bindestrich: der Agent-Proxy blockt den Host (502). Weder bestätigt noch widerlegt.

## Blocker / Rückfragen
- Maps-API-Key `AIza…zibk9k` steht im HTML. Das ist bei Maps JS üblich, aber nur sicher, wenn der Key in der Google-Cloud-Konsole auf HTTP-Referrer `campus-sparbuch.de/*` und auf die genutzten APIs beschränkt ist. Prüfung nur durch Jesse oder Kevin möglich.
- Design-Regel `border-radius: 0 durchgängig` (Skill) steht im Widerspruch zum Live-Stand: Suchfeld, Buttons, Badges, Merken-Buttons und Cookie-Banner nutzen `999px`. Entscheidung nötig: Ist der Skill veraltet oder liegt ein Regelbruch vor?
- Partnerleiste auf der Startseite („wird dir präsentiert von“ mit Haspa und mehreren Sparkassen-Logos, „Wintersemester 2026/27“): Ob die Partnerschaften und Logo-Nutzungsrechte vertraglich gedeckt sind, ist von außen nicht prüfbar. Rechtlich und markenrechtlich sensibel, bitte intern gegenprüfen.
- Claim „180+ Deals“ im OG-Bild und Hero-Text: Die sechs Kategoriezähler der Startseite ergeben 179 (55+47+28+23+13+13). Sitewide gibt es 208 Listings, davon 140 mit Offer-Markup. Welche Zahl gilt, ist offen. Claim an die Datenbasis koppeln statt hart schreiben.

## Entscheidungen
| Entscheidung | Begründung | Konsequenz |
|---|---|---|
| Keine Entscheidung getroffen | Auftrag war Analyse und Test, keine Änderung | Alle Punkte oben sind Empfehlungen, nichts wurde geändert |

## Relevante Dateien / Links
| Artefakt | Pfad/URL | Zweck | Status |
|---|---|---|---|
| Analyseplan | `/root/.claude/plans/refactored-enchanting-adleman.md` | Testphasen und Grenzen | freigegeben |
| Rohdaten Browser-Audit | `…/scratchpad/audit.json` (Cloud-Session, flüchtig) | Messwerte je Seite/Viewport | nicht dauerhaft gesichert |
| Rohdaten Crawl | `…/scratchpad/crawl.tsv` (Cloud-Session, flüchtig) | Status/Größe/Zeit je URL | nicht dauerhaft gesichert |
| Screenshots | `…/scratchpad/shots/` (Cloud-Session, flüchtig) | Mobile-Layout | nicht dauerhaft gesichert |
| Live-Site | https://campus-sparbuch.de | Prüfobjekt | geprüft, extern |

## Kopf-Memory-Bezug
Kein Kopf-Memory-Bezug dokumentiert.

## Nächster sinnvoller Schritt
PageSpeed Insights für Startseite und ein Listing laufen lassen und parallel den Kontrastfix (`#7f7f7f` auf mindestens `#767676`) im Child-Theme über Novamira umsetzen lassen.

Daily Input erstellt: Ja
Zielpfad: ~/Workplace/Daily/Input/Claude_Regular/2026-10-01_Claude_Regular_CAMPUS-SPARBUCH_Website-Analyse.md (in dieser Cloud-Session liegt die Datei unter /home/user/claude-code/2026-10-01_Claude_Regular_CAMPUS-SPARBUCH_Website-Analyse.md, bitte in den Zielordner kopieren)
Nicht dokumentierte Unsicherheit: Alle Ladezeiten stammen aus einer Cloud-Umgebung hinter einem Proxy (TTFB ca. 1 s) und sind absolut zu pessimistisch, relativ zueinander aber vergleichbar. Dass `x-cache-status: MISS` im Header stand, liegt am Cache-Buster `?probe=`, es sagt nichts über den Seiten-Cache aus.
