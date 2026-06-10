# ListingPro Licensing Notes

Source: bundled `Licensing/README_License.txt` and `Licensing/GPL.txt` (ThemeForest item 19386460).

## Two-part license

1. **PHP code and integrated HTML**: licensed under GPLv2 (full text in the bundled `GPL.txt`). This code can be modified and reused under GPL terms.
2. **Everything else** (CSS, images, design assets, demo content): licensed under the terms of the purchased ThemeForest license (Regular or Extended), per [Envato licensing terms](http://themeforest.net/licenses).

## Practical implications for this project

- A **Regular License** covers use on a single end product (one live site, e.g. `campussparbuch.de`) made available to non-paying end users. Confirm which license tier was purchased before deploying to additional domains/staging copies that count as separate "end products," or before reselling/sublicensing the design.
- The PHP/template code can be freely copied into the child theme or a custom plugin (GPL), but design assets (images, CSS not derived from GPL code, demo content) should not be redistributed outside the licensed installation.
- Do not commit the full theme/plugin zip files, demo content, or design assets into source control repositories that are or could become public — this skill's reference docs intentionally summarize *behavior and data structures* (derived facts, GPL-covered code patterns) rather than embedding the licensed assets themselves.
- The bundled WP All Import add-on (`listingpro-Bulk-import-addon.zip`) is itself GPLv2-licensed (per its `readme.txt`), separate from the theme's mixed license.

## Where the originals live

The original purchased zips (theme, bulk import add-on, full documentation, licensing folder) are kept outside this repository. If they need to be re-applied to a Local WP environment, retrieve them from the project's local ThemeForest download archive — do not re-download from public URLs without Jesse's account access.
