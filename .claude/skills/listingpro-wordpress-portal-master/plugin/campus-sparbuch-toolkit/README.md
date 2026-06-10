# Campus Sparbuch ListingPro Toolkit (project plugin)

Project-specific WordPress plugin that gives Claude Code (and any automation script) a stable, idempotent PHP/WP-CLI API on top of ListingPro's data model, instead of re-deriving meta keys (`lp_listingpro_options`, `gallery_image_ids`, `lp_category_tags`, `lp-packages`) in every script.

## Install (Local WP)

```bash
cp -r .claude/skills/listingpro-wordpress-portal-master/plugin/campus-sparbuch-toolkit \
  "/Users/jessenikoi/Local Sites/campus-sparbuch-dev/app/public/wp-content/plugins/"

wp plugin activate campus-sparbuch-toolkit
```

Use the Local WP wrapper from `references/wp-cli-local-wrapper.md` for the `wp` calls.

## What it provides

- `includes/listing-options.php` — read/write `lp_listingpro_options` (tagline, contact info, social links, FAQs, business hours, claim status, pricing) without touching raw serialized arrays directly; gallery image helpers.
- `includes/taxonomy-helpers.php` — idempotent term creation; sync of `listing_features` into category-level `lp_category_tags` (mirrors the bulk import add-on's behaviour).
- `includes/package-helpers.php` — idempotent `lp-packages` lookup/creation and Plan ID resolution.
- `includes/cli-commands.php` — `wp cs listing ...`, `wp cs term ...`, `wp cs package ...` commands wrapping the above.

## Extending it

Add new helpers/commands here for recurring Campus Sparbuch automation (e.g., claim-status changes, featured-listing toggles, review imports) instead of one-off `wp eval` snippets, so behaviour stays documented, testable, and reusable across phases. Keep changes idempotent and avoid inventing new `listingpro_options` / meta keys without first confirming them against the live install (`wp post meta list`, `wp option get listingpro_options --format=json`).
