# ListingPro Feature & Capability Catalog

Reference inventory of what the ListingPro WordPress theme (CridioStudio, ThemeForest item 19386460) can do natively. Use this to check "does ListingPro already do this?" before adding plugins or custom code, per the master skill's operating principles.

Sources: bundled theme documentation (v1.1.0/2.0.0), bundled WP All Import add-on source, ListingPro product/feature pages, and ListingPro public knowledge base (docs.listingprowp.com).

## Core data model

| Concept | WordPress structure |
|---|---|
| Listings | Custom post type `listing` |
| Listing categories | Taxonomy `listing-category` (also referenced as `listing_category`) |
| Listing locations | Taxonomy `listing_location` |
| Listing features/amenities | Taxonomy `listing_features` (also `features`) |
| Agents | Custom post type `listingpro_agent` |
| Pricing/submission packages | Custom post type `lp-packages` |
| Theme options (global) | WP option `listingpro_options` |
| Per-listing structured data | Post meta `lp_listingpro_options` (serialized array: tagline, social links, FAQs, business hours, pricing, claim status, gallery, etc.) |
| Gallery images | Post meta `gallery_image_ids` (comma-separated attachment IDs) |
| Business logo | Post meta `business_logo` |

`lp_listingpro_options` typically holds: `tagline_text`, `gAddress`, `latitude`, `longitude`, `phone`, `email`, `website`, social links (`twitter`, `facebook`, `linkedin`, `google_plus`, `youtube`, `instagram`), `video`, `price_status`, `Plan_id`, `list_price`, `list_price_to`, `claimed_section`, `faqs` (with `faq`/`faqans` arrays), `business_hours` (per-day `open`/`close`).

## Monetization

| Feature | Notes |
|---|---|
| Pricing/submission plans | `lp-packages` post type; supports free and paid plans, recurring subscriptions |
| Paid claim | Business owners pay (or claim free, per project config) to take ownership of a listing and unlock dashboard features |
| Featured listings | Paid placement; can be default sort order |
| Ads campaigns | Built-in ad/banner campaign system for listing owners |
| Google AdSense | Native ad slot support |
| Coupons & deals | Native coupon/deal post type for promotions |

## Listing lifecycle & ownership

| Feature | Notes |
|---|---|
| Frontend submission | Can be enabled/disabled; Campus Sparbuch keeps this **disabled** (curated/internal model) |
| Claim system | Unclaimed listings show a "Claim this business" CTA; claiming links a WP user to a listing and unlocks the partner dashboard |
| Partner/vendor dashboard | Frontend dashboard for claimed-listing owners: edit listing, view leads/messages, manage reviews, run ads |
| Listing expiration / renewal | Tied to package duration; auto-renew can be toggled (Campus Sparbuch: disabled) |
| Listing status workflow | Draft/pending/publish via standard WP post status, plus theme-specific "claimed" flag |

## Reviews & ratings

| Feature | Notes |
|---|---|
| Multi-criteria reviews | Admin defines rating criteria sets per category (e.g., price, service, location) |
| Spam protection | Built-in safeguards on review submission |
| Review shortcode | `[cs_rating]`-style custom shortcodes are typically layered on top via child theme/plugin (see `bewertung-feature-v2.sh` in project scripts) |
| Owner responses | Claimed-listing owners can reply to reviews from the dashboard |

## Search, filters & maps

| Feature | Notes |
|---|---|
| Advanced search/filter widgets | Filter by category, location, features/amenities, price range, rating |
| Map integration | Google Maps by default; Mapbox supported via API token in Theme Options → Map Settings |
| Location restriction shortcodes | Can restrict search/listing display to a specific country/region |
| Geocoding | Bulk-import add-on geocodes addresses via Google Geocoding API when lat/long are missing |

## Communication

| Feature | Notes |
|---|---|
| Inbox / messaging | Peer-to-peer messaging between users and listing owners |
| Lead capture | Contact/inquiry forms on listing pages feed into messaging or email notifications |
| Email templates | Theme + WP Mail SMTP for transactional email (claim confirmation, messages, package purchase) |

## Bookings & events

| Feature | Notes |
|---|---|
| Business hours | Per-day open/close stored in `lp_listingpro_options.business_hours` |
| Event management & booking | Native event post type / booking flow for event-style listings (theme feature; verify availability per installed theme version before relying on it) |
| FAQ blocks | Per-listing FAQ/answer pairs stored as `faqs.faq` / `faqs.faqans` arrays |

## Page builder integration

| Feature | Notes |
|---|---|
| Elementor support | 25+ ListingPro-specific Elementor widgets (listing grids, search forms, category boxes, maps, etc.) |
| WPBakery support | Equivalent shortcode/element set for WPBakery Page Builder |
| Theme Options one-page/tabbed view | Toggle between tabbed and single-scroll Theme Options UI |
| Theme Options import/export | Export/import full Theme Options as JSON for backup/migration — **overwrites all values on import**, use with caution |

## Import / data tooling

| Feature | Notes |
|---|---|
| WP All Import + ListingPro Add-on | Bundled add-on (`listingpro-Bulk-import-addon.zip`) maps CSV/XML columns to listing fields; see `references/bulk-import-addon.md` |
| Demo content importer | One-click demo content import (separate from Theme Options import/export) |
| CubeWP Framework | Used alongside ListingPro on this project for additional custom field/CRM-style capabilities — confirm exact integration points in the live install before assuming feature parity with stock ListingPro |

## Required / recommended companion plugins

Per theme setup wizard: ListingPro typically bundles or recommends Elementor (or WPBakery), a slider plugin (LayerSlider/Revolution Slider), Contact Form 7 or similar, and WP All Import for bulk data. Confirm the actual active plugin list with `wp plugin list` rather than assuming — installs vary by version and project.

## Browser-only / non-scriptable areas (recap)

Maps API keys, social login OAuth secrets, SMTP passwords, Theme Options visual wizard steps, Complianz/Rank Math wizards, and logo/favicon uploads remain manual admin tasks — see `references/wp-cli-local-wrapper.md`.

## Verifying capabilities before relying on them

Theme versions and bundled feature sets change between ListingPro releases. Before telling a user "ListingPro can do X natively":

1. Check the active theme version: `wp theme list` / `wp theme get listingpro --field=version`.
2. Check `wp option get listingpro_options --format=json` for the relevant option keys.
3. Check active plugins: `wp plugin list`.
4. Grep the theme/child-theme source for the relevant template tags or functions before assuming a hook/filter exists.
