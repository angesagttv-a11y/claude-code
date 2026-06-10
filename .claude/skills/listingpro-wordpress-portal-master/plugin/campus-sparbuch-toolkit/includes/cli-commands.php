<?php
/**
 * `wp cs ...` commands wrapping the toolkit helpers, so Claude Code /
 * automation scripts can read and edit ListingPro listing data without
 * crafting raw `wp post meta` / `wp eval` calls each time.
 *
 * Run via the project's Local WP wrapper, e.g.:
 *   wp cs listing get-options 123
 *   wp cs listing set-faq 123 "Question?" "Answer."
 *   wp cs term ensure listing-category "Restaurants" restaurants
 *   wp cs package ensure "Premium"
 */

defined( 'ABSPATH' ) || exit;
defined( 'WP_CLI' ) || exit;

class CS_Listingpro_CLI_Listing {

	/**
	 * Print a listing's lp_listingpro_options as JSON.
	 *
	 * ## OPTIONS
	 *
	 * <post_id>
	 * : Listing post ID.
	 *
	 * ## EXAMPLES
	 *
	 *     wp cs listing get-options 123
	 */
	public function get_options( $args ) {
		list( $post_id ) = $args;

		WP_CLI::print_value( cs_get_listing_options( (int) $post_id ), array( 'format' => 'json' ) );
	}

	/**
	 * Append one FAQ question/answer pair to a listing.
	 *
	 * ## OPTIONS
	 *
	 * <post_id>
	 * : Listing post ID.
	 *
	 * <question>
	 * : FAQ question text.
	 *
	 * <answer>
	 * : FAQ answer text.
	 *
	 * ## EXAMPLES
	 *
	 *     wp cs listing add-faq 123 "Gibt es Rabatt fuer Studierende?" "Ja, 10 Prozent."
	 */
	public function add_faq( $args ) {
		list( $post_id, $question, $answer ) = $args;

		$options = cs_get_listing_options( (int) $post_id );
		$faq     = $options['faqs']['faq'] ?? array();
		$faqans  = $options['faqs']['faqans'] ?? array();

		$faq[]    = $question;
		$faqans[] = $answer;

		cs_update_listing_options(
			(int) $post_id,
			array(
				'faqs' => array(
					'faq'    => $faq,
					'faqans' => $faqans,
				),
			)
		);

		WP_CLI::success( "Added FAQ to listing $post_id." );
	}

	/**
	 * Sync a listing's feature taxonomy terms into its category terms'
	 * lp_category_tags meta.
	 *
	 * ## OPTIONS
	 *
	 * <post_id>
	 * : Listing post ID.
	 *
	 * ## EXAMPLES
	 *
	 *     wp cs listing sync-category-tags 123
	 */
	public function sync_category_tags( $args ) {
		list( $post_id ) = $args;

		cs_sync_category_feature_tags( (int) $post_id );

		WP_CLI::success( "Synced category feature tags for listing $post_id." );
	}
}

class CS_Listingpro_CLI_Term {

	/**
	 * Ensure a taxonomy term exists, creating it if needed.
	 *
	 * ## OPTIONS
	 *
	 * <taxonomy>
	 * : Taxonomy slug, e.g. listing-category, listing_location, listing_features.
	 *
	 * <name>
	 * : Term display name.
	 *
	 * <slug>
	 * : Term slug.
	 *
	 * ## EXAMPLES
	 *
	 *     wp cs term ensure listing-category "Restaurants" restaurants
	 */
	public function ensure( $args ) {
		list( $taxonomy, $name, $slug ) = $args;

		$term_id = cs_ensure_term( $taxonomy, $name, $slug );

		WP_CLI::success( "Term $taxonomy/$slug -> ID $term_id" );
	}
}

class CS_Listingpro_CLI_Package {

	/**
	 * Ensure an lp-packages post exists for the given title.
	 *
	 * ## OPTIONS
	 *
	 * <title>
	 * : Package title, e.g. "Free", "Premium".
	 *
	 * ## EXAMPLES
	 *
	 *     wp cs package ensure "Premium"
	 */
	public function ensure( $args ) {
		list( $title ) = $args;

		$post_id = cs_ensure_package( $title );

		WP_CLI::success( "Package \"$title\" -> ID $post_id" );
	}
}

WP_CLI::add_command( 'cs listing', 'CS_Listingpro_CLI_Listing' );
WP_CLI::add_command( 'cs term', 'CS_Listingpro_CLI_Term' );
WP_CLI::add_command( 'cs package', 'CS_Listingpro_CLI_Package' );
