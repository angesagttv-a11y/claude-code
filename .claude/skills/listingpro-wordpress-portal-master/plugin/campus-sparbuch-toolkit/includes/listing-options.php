<?php
/**
 * Helpers for reading/writing the `lp_listingpro_options` post meta blob
 * that ListingPro stores per listing (tagline, contact info, social links,
 * FAQs, business hours, claim status, pricing, etc.).
 *
 * Field names mirror the bundled WP All Import - Listingpro Add-On
 * (see references/bulk-import-addon.md) so imports, manual edits, and
 * scripted edits stay consistent.
 */

defined( 'ABSPATH' ) || exit;

/**
 * Get the full lp_listingpro_options array for a listing, with defaults
 * for keys that may not exist yet.
 */
function cs_get_listing_options( int $post_id ): array {
	$options = get_post_meta( $post_id, 'lp_listingpro_options', true );

	if ( ! is_array( $options ) ) {
		$options = array();
	}

	$defaults = array(
		'tagline_text'    => '',
		'gAddress'        => '',
		'latitude'        => '',
		'longitude'       => '',
		'phone'           => '',
		'email'           => '',
		'website'         => '',
		'twitter'         => '',
		'facebook'        => '',
		'linkedin'        => '',
		'google_plus'     => '',
		'youtube'         => '',
		'instagram'       => '',
		'video'           => '',
		'price_status'    => '',
		'Plan_id'         => '',
		'list_price'      => '',
		'list_price_to'   => '',
		'claimed_section' => '',
		'faqs'            => array(
			'faq'    => array(),
			'faqans' => array(),
		),
		'business_hours'  => array(),
	);

	return array_replace_recursive( $defaults, $options );
}

/**
 * Merge-update lp_listingpro_options for a listing. Only keys present in
 * $changes are touched; everything else is preserved.
 */
function cs_update_listing_options( int $post_id, array $changes ): array {
	$current = cs_get_listing_options( $post_id );
	$updated = array_replace_recursive( $current, $changes );

	update_post_meta( $post_id, 'lp_listingpro_options', $updated );

	return $updated;
}

/**
 * Set FAQ question/answer pairs for a listing.
 *
 * @param array $pairs List of ['question' => ..., 'answer' => ...] pairs.
 */
function cs_set_listing_faqs( int $post_id, array $pairs ): void {
	$faq    = array();
	$faqans = array();

	foreach ( $pairs as $pair ) {
		$faq[]    = $pair['question'] ?? '';
		$faqans[] = $pair['answer'] ?? '';
	}

	cs_update_listing_options(
		$post_id,
		array(
			'faqs' => array(
				'faq'    => $faq,
				'faqans' => $faqans,
			),
		)
	);
}

/**
 * Set business hours for a listing.
 *
 * @param array $hours Map of day name => ['open' => 'HH:MM', 'close' => 'HH:MM'].
 *                      Example: ['Monday' => ['open' => '09:00', 'close' => '17:00']]
 */
function cs_set_listing_business_hours( int $post_id, array $hours ): void {
	cs_update_listing_options( $post_id, array( 'business_hours' => $hours ) );
}

/**
 * Append image attachment IDs to a listing's gallery (gallery_image_ids meta),
 * matching the behaviour of the bulk import add-on's gallery image handler.
 */
function cs_add_gallery_images( int $post_id, array $attachment_ids ): void {
	$existing = get_post_meta( $post_id, 'gallery_image_ids', true );
	$ids      = $existing ? array_filter( explode( ',', (string) $existing ) ) : array();

	foreach ( $attachment_ids as $attachment_id ) {
		$ids[] = (string) $attachment_id;
	}

	$ids = array_values( array_unique( $ids ) );

	update_post_meta( $post_id, 'gallery_image_ids', implode( ',', $ids ) );
}

/**
 * Get the claim status for a listing ('' = unclaimed, theme-defined string otherwise).
 */
function cs_get_claim_status( int $post_id ): string {
	$options = cs_get_listing_options( $post_id );

	return (string) ( $options['claimed_section'] ?? '' );
}
