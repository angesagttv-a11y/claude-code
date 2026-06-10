# Claude Cowork Handoff: Campus Sparbuch / ListingPro

## Auftrag

[Eine klare Aufgabe. Kein Kontext-Overload.]

## Aktueller Projektstand

| Feld | Wert |
|---|---|
| Phase | [Phase eintragen] |
| Umgebung | [Local WP / Staging / Produktion] |
| WordPress-Pfad | `/Users/jessenikoi/Local Sites/campus-sparbuch-dev/app/public` |
| Stack | WordPress + ListingPro + CubeWP |
| Relevanter Skill | `listingpro-wordpress-portal-master` |

## Bereits entschieden

| Entscheidung | Bedeutung |
|---|---|
| Kein Self-Service | Frontend-Submission nicht aktivieren. |
| Claim kostenlos | Claim-Flow als Lead-Hebel behandeln. |
| ListingPro-native zuerst | Keine WooCommerce-/Drittplugin-Lösung ohne Prüfung. |
| JS-Minify aus | ListingPro-Konflikte vermeiden. |

## Aufgabe im Detail

[Beschreibe die genaue technische oder redaktionelle Arbeit. Nenne Dateien, Optionen, Post Types, Taxonomien oder Admin-Bereiche.]

## Relevante Dateien / Kommandos

```bash
# Pflicht: Local-WP-CLI-Wrapper aus references/wp-cli-local-wrapper.md nutzen
wp plugin list
wp theme list
wp option get listingpro_options --format=json
wp post list --post_type=lp-packages --fields=ID,post_title,post_status --format=table
wp term list listing_category --fields=term_id,name,slug,count --format=table
```

## Akzeptanzkriterien

| Kriterium | Muss erfüllt sein |
|---|---|
| Idempotenz | Re-Run erzeugt keine Duplikate. |
| Native Prüfung | ListingPro-Bordmittel wurden geprüft. |
| Verifikation | Zustand wurde per WP-CLI, Admin oder Frontend geprüft. |
| Dokumentation | Änderungen, Risiken und nächste Schritte sind dokumentiert. |

## Risiken / offene Fragen

| Punkt | Status |
|---|---|
| Theme Option Keys geprüft? | [Ja/Nein] |
| Meta Keys geprüft? | [Ja/Nein] |
| Browser-only Schritt betroffen? | [Ja/Nein] |
| Secrets benötigt? | [Ja/Nein] |

## Erwartete Rückgabe

Bitte liefere nur:

1. Geänderte Dateien oder Kommandos.
2. Kurze Begründung der technischen Entscheidung.
3. Verifikation mit konkretem Nachweis.
4. Offene Blocker.
5. Nächsten operativen Schritt.

Keine Füllphrasen, keine Meta-Kommentare, keine generischen Zusammenfassungen.
