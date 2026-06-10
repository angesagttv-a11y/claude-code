# WP All Import — ListingPro Add-On Reference

Source: bundled `listingpro-Bulk-import-addon.zip` (Cridio Studio, "WP All Import - Listingpro Add-On" v1.0.2). Required: WP All Import (free or Pro) plus the ListingPro theme active. Use this when planning or building CSV/XML import templates for bulk listing imports (Phase 2 of the Campus Sparbuch roadmap).

## What it does

Registers a `RapidAddon` named `Listingpro Add-On` (`listingpro_addon`) scoped to:

- Theme: `Listingpro`
- Post type: `listing`

It adds extra import-mappable fields on top of WP All Import's standard post fields, and post-processes the imported row into ListingPro's actual meta structure.

## Importable fields exposed by the add-on

| Add-on field key | Label | Notes |
|---|---|---|
| `tagline_text` | Tagline Text | |
| `gAddress` | Google Address | Used for geocoding if lat/long absent |
| `latitude` | Latitude | |
| `longitude` | Longitude | |
| `phone` | Phone | |
| `email` | Email | |
| `website` | Website | |
| `twitter`, `facebook`, `linkedin`, `google_plus`, `youtube`, `instagram` | Social links | One field each |
| `video` | Youtube Video URL | |
| `price_status` | Price Status | |
| `Plan_id` | Pricing Plan ID | Must match an existing `lp-packages` post ID |
| `list_price` | Price From | |
| `list_price_to` | Price To | |
| `claimed_section` | Claim Status | |
| `faq` | FAQ questions | Pipe-separated: `Q1 | Q2 | Q3` |
| `faqans` | FAQ answers | Pipe-separated, same order as `faq`: `ANS1 | ANS2 | ANS3` |
| `businesshours` | Business hours | Pipe-separated per day: `Sunday,08:00,18:00 | Monday,09:00,17:00 | ...` |

Image imports (via `import_images`):

| Field | Maps to |
|---|---|
| `listingpro_addon_gallery_images` (Gallery Images) | Appends attachment IDs to post meta `gallery_image_ids` (comma-separated) |
| `listingpro_addon_logo_image` (Listings Logo) | Sets post meta `business_logo` to the attachment URL |

Floor plan and property-attachment image hooks exist in the source but are **commented out** (`listingpro_addon_floorplan_images`, `listingpro_addon_property_attachments`) — not active unless re-enabled in the add-on file.

## How the import maps into ListingPro's data model

On import, `listingpro_addon_import()`:

1. Builds an array from all the fields above (except image fields) and saves it as serialized post meta `lp_listingpro_options`.
   - `faq` + `faqans` are zipped into `lp_listingpro_options['faqs']['faq']` / `['faqans']`.
   - `businesshours` is parsed into `lp_listingpro_options['business_hours'][<Day>] = ['open' => ..., 'close' => ...]`.
2. Clears `fave_attachments` and `fave_property_images` post meta if image updates are enabled (avoids stale gallery references from prior imports).
3. Resolves/creates an agent: looks up a `listingpro_agent` post by title matching the `fave_agents` field; creates one if missing, then stores its post ID in `fave_agents` meta on the listing.
4. Resolves the listing's map location:
   - If `location_settings == search_by_address`, geocodes `gAddress` via the Google Geocoding API (`maps.googleapis.com/maps/api/geocode/json`) using whichever Google API key/signature fields are present in the import config.
   - Otherwise uses provided `latitude`/`longitude` directly, or reverse-geocodes to get a formatted address.
   - Writes `fave_property_map_address` and `fave_property_location` (`"lat,long"`) post meta.
5. On `lp_saved_post` action, `lp_update_features_taxonomy()` copies the listing's `features` taxonomy term IDs into each of its `listing-category` terms' `lp_category_tags` term meta (merging with any existing values) — this keeps category-level "available features" lists in sync with what's actually used by listings in that category.

## Practical implications for CSV templates

- A CSV column per field above, mapped 1:1 in WP All Import's drag-and-drop interface.
- `Plan_id` must reference a real `lp-packages` post ID — create/confirm pricing packages **before** running a bulk import (see `references/wp-cli-local-wrapper.md` for the idempotent package-creation pattern).
- If the CSV already contains accurate latitude/longitude, set `location_settings` accordingly to skip the geocoding API call (saves quota and avoids rate-limit failures on large imports).
- `faq`/`faqans`/`businesshours` use `|` as the delimiter — ensure source CSV data doesn't contain literal `|` characters, or escape/transform them during CSV prep.
- Re-running an import on the same rows (update mode) re-runs `listingpro_addon_import`, overwriting `lp_listingpro_options` — confirm WP All Import's "update existing" matching is keyed on a stable unique field (e.g., a slug or external ID column) to avoid duplicate listings.

## Geocoding API key

The geocoding step needs a Google API key configured in WP All Import's import settings (`address_google_developers_api_key` or the "for work" client/signature pair). This is a **browser/admin** step (API key entry) — do not hardcode keys into scripts.
