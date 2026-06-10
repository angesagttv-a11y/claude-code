---
name: listingpro-wordpress-portal-master
description: Master workflow for Campus Sparbuch ListingPro WordPress portal work. Use for ListingPro, WordPress, WP-CLI, Local WP, Campus Sparbuch, listings, claims, pricing plans, imports, reviews, Stripe, deployment, or Claude Cowork handoffs.
---

# ListingPro WordPress Portal Master Skill

## Purpose

Use this skill whenever you work on the **Campus Sparbuch WordPress portal** or any task involving the **ListingPro WordPress theme**. Treat the portal as a business system, not as a generic WordPress site. The correct operating model combines ListingPro-native directory features, WP-CLI automation, Local by WP Engine constraints, disciplined project state handling, and direct editorial standards.

Claude Code must optimize for **safe implementation, reproducible scripts, clear handoffs, and minimal guesswork**. Before adding external plugins, custom code, WooCommerce, or manual admin steps, inspect whether ListingPro already provides the required capability.

## Mandatory start sequence

Read the relevant bundled references before acting. Do not skip this sequence on portal tasks.

| Task type | Read first |
|---|---|
| Any Campus Sparbuch task | `references/project-context.md`, then `references/wp-cli-local-wrapper.md` |
| ListingPro feature, configuration, monetization, import, claim, review, maps, cache, or payment work | `references/listingpro-theme-operations.md`, then `references/listingpro-feature-catalog.md` |
| Bulk import / CSV / WP All Import work | `references/bulk-import-addon.md` |
| Licensing or redistribution questions about theme/plugin files | `references/licensing.md` |
| Writing copy, handoffs, documentation, partner emails, internal notes, or reports | `references/editorial-standards.md` |
| Delegating work to another Claude session, Manus, a browser operator, or a developer | `templates/handoff-brief.md` |
| Building or extending automation that reads/writes ListingPro listing data | `plugin/campus-sparbuch-toolkit/README.md` |
| Phase 1 full configuration run | `scripts/listingpro-vollkonfiguration-v2.sh` (run section 0 first, confirm option keys before uncommenting TODO sections) |

## Operating principles

Work in this order: understand the current phase, identify the safest native ListingPro path, write or inspect deterministic code, verify in WordPress, then document the result. Do not treat WordPress admin clicking as the default path. Prefer WP-CLI scripts for repeatable configuration unless the project context marks a step as browser-only.

Separate **facts, assumptions, risks, and decisions**. If a theme option key, post meta key, plugin function, or database structure is unknown, inspect the actual codebase or database before editing. Do not invent ListingPro option names.

Protect the business model. Campus Sparbuch uses an internal curation model, not open self-service submission. Claiming is a free lead-generation mechanism. Featured visibility supports monetization. Stripe and other payment automation belong after the MVP unless the user explicitly changes the roadmap.

## Execution workflow

1. **Load context.** Read `references/project-context.md` and identify the active phase, blockers, constraints, and acceptance criteria.
2. **Inspect before editing.** Use `wp option get`, `wp post list`, `wp term list`, `wp plugin list`, `wp theme list`, `wp eval`, filesystem grep, or database inspection to confirm current state.
3. **Prefer child-theme and scripts.** Put durable PHP/CSS/JS changes in the child theme or the bundled `plugin/campus-sparbuch-toolkit` project plugin (see `plugin/campus-sparbuch-toolkit/README.md`) — extend it rather than writing one-off `wp eval` snippets for recurring listing-data operations. Put repeatable configuration in Bash/WP-CLI scripts with the Local WP wrapper.
4. **Keep scripts idempotent.** Re-running a script must not create duplicate terms, packages, pages, options, or users. Use lookup-before-create logic.
5. **Respect browser-only boundaries.** SMTP password, logo/favicon, Google Maps API key, social-login keys, Complianz wizard, and Rank Math wizard require browser/admin work.
6. **Verify output.** After implementation, check database state, admin-visible objects, frontend behavior where possible, and error logs.
7. **Write a handoff.** Record what changed, what was verified, what remains blocked, and what the next operator should do.

## Hard constraints

| Area | Constraint |
|---|---|
| Stack | WordPress + ListingPro + CubeWP. No framework switch. |
| Submission model | Self-service frontend submission stays disabled unless Jesse explicitly changes the business model. |
| WP-CLI | Use the Local by WP Engine wrapper from `references/wp-cli-local-wrapper.md`; do not assume a global `wp` command works. |
| Minification | Leave JS minify disabled because ListingPro scripts are conflict-prone. |
| Design | Primary `#E8318A`, secondary `#0195B3`, hover `#F06FAF`, Open Sans body, Montserrat 800 headings, border radius `0`. |
| Currency/date | EUR, `€` after the amount, date format `d.m.Y`. |
| Payments | Prefer ListingPro-native payment/plan logic before WooCommerce. Stripe is scheduled after go-live unless the user changes priority. |
| Data model | `listing`, `listing_category`, `listing_location`, `listing_features`, `lp-packages`, option key `listingpro_options`. |

## Quality gates

Before presenting work as complete, check the following.

| Gate | Pass condition |
|---|---|
| Context | You used the current phase and did not contradict project decisions. |
| Safety | You avoided credentials in files and created no destructive migration without backup. |
| Reproducibility | Changes can be repeated through scripts or documented admin steps. |
| ListingPro fit | You checked native ListingPro functionality before adding external systems. |
| Verification | You verified options, terms, packages, plugins, frontend behavior, or logs as relevant. |
| Writing | You removed AI filler, passive voice, vague business phrases, and unsupported claims. |

## Output standard

When responding to the user or preparing a handoff, use concise professional German unless asked otherwise. Give a clear status, exact files or settings touched, verification evidence, remaining risks, and next action. Avoid generic encouragement. If something is blocked, name the blocker and the operator who can remove it.

## Useful invocation examples

Use this skill for prompts such as:

> „Konfiguriere die ListingPro Theme Options für Campus Sparbuch per WP-CLI.“

> „Prüfe, ob Stripe über ListingPro nativ oder über WooCommerce umgesetzt werden sollte.“

> „Erstelle ein Claude-Cowork-Handoff für den Bulk Import der ersten 181 Listings.“

> „Fixe die ListingPro Claim-Logik, ohne das interne Kurationsmodell zu zerstören.“
