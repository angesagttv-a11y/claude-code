<?php
/**
 * Idempotent helpers for ListingPro pricing/submission packages
 * (post type `lp-packages`).
 */

defined( 'ABSPATH' ) || exit;

/**
 * Get an existing lp-packages post by title, or create it as a draft.
 * Returns the post ID. Does not set price/feature meta — inspect the
 * actual meta keys used by the installed ListingPro version with
 * `wp post meta list <id>` before scripting those, per the master skill's
 * "no blind option invention" rule.
 */
function cs_ensure_package( string $title ): int {
	$existing = get_posts(
		array(
			'post_type'      => 'lp-packages',
			'title'          => $title,
			'post_status'    => array( 'publish', 'draft' ),
			'numberposts'    => 1,
			'fields'         => 'ids',
		)
	);

	if ( ! empty( $existing ) ) {
		return (int) $existing[0];
	}

	$post_id = wp_insert_post(
		array(
			'post_type'   => 'lp-packages',
			'post_title'  => $title,
			'post_status' => 'publish',
		),
		true
	);

	if ( is_wp_error( $post_id ) ) {
		throw new RuntimeException( $post_id->get_error_message() );
	}

	return (int) $post_id;
}

/**
 * Resolve a package title to its post ID, for setting Plan_id on a listing
 * (see references/bulk-import-addon.md).
 */
function cs_get_package_id_by_title( string $title ): ?int {
	$existing = get_posts(
		array(
			'post_type'   => 'lp-packages',
			'title'       => $title,
			'post_status' => array( 'publish', 'draft' ),
			'numberposts' => 1,
			'fields'      => 'ids',
		)
	);

	return ! empty( $existing ) ? (int) $existing[0] : null;
}
