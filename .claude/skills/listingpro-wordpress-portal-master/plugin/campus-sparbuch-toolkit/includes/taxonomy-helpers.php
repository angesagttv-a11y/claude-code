<?php
/**
 * Idempotent term helpers for ListingPro's directory taxonomies
 * (listing-category, listing_location, listing_features), matching the
 * "lookup-before-create" rule from references/wp-cli-local-wrapper.md.
 */

defined( 'ABSPATH' ) || exit;

/**
 * Get an existing term by slug, or create it. Returns the term_id.
 */
function cs_ensure_term( string $taxonomy, string $name, string $slug ): int {
	$term = get_term_by( 'slug', $slug, $taxonomy );

	if ( $term instanceof WP_Term ) {
		return (int) $term->term_id;
	}

	$result = wp_insert_term( $name, $taxonomy, array( 'slug' => $slug ) );

	if ( is_wp_error( $result ) ) {
		// Term may already exist under a different slug collision; surface it.
		throw new RuntimeException( $result->get_error_message() );
	}

	return (int) $result['term_id'];
}

/**
 * Sync a listing's `listing_features` terms into each of its
 * `listing-category` terms' `lp_category_tags` term meta, mirroring the
 * bulk import add-on's lp_update_features_taxonomy() behaviour
 * (see references/bulk-import-addon.md).
 */
function cs_sync_category_feature_tags( int $post_id ): void {
	if ( get_post_type( $post_id ) !== 'listing' ) {
		return;
	}

	$category_terms = wp_get_post_terms( $post_id, 'listing-category', array( 'fields' => 'all' ) );
	$feature_terms  = wp_get_post_terms( $post_id, 'listing_features', array( 'fields' => 'all' ) );

	if ( empty( $feature_terms ) || empty( $category_terms ) || is_wp_error( $category_terms ) || is_wp_error( $feature_terms ) ) {
		return;
	}

	$feature_ids = wp_list_pluck( $feature_terms, 'term_id' );

	foreach ( $category_terms as $category_term ) {
		$existing = get_term_meta( $category_term->term_id, 'lp_category_tags', true );
		$existing = is_array( $existing ) ? $existing : array();

		$merged = array_values( array_unique( array_merge( $existing, $feature_ids ) ) );

		update_term_meta( $category_term->term_id, 'lp_category_tags', $merged );
	}
}
