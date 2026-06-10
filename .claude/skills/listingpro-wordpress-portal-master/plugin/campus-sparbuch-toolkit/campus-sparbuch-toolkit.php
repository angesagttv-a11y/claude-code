<?php
/**
 * Plugin Name: Campus Sparbuch ListingPro Toolkit
 * Description: Project plugin for Campus Sparbuch. Provides a stable PHP/WP-CLI API around ListingPro's data model (lp_listingpro_options, lp-packages, listing taxonomies) so automation scripts and the listingpro-wordpress-portal-master skill don't have to re-derive meta keys or duplicate lookup-before-create logic.
 * Version: 0.1.0
 * Author: Campus Sparbuch
 * License: GPLv2 or later
 * Text Domain: cs-listingpro-toolkit
 */

defined( 'ABSPATH' ) || exit;

define( 'CS_LISTINGPRO_TOOLKIT_DIR', plugin_dir_path( __FILE__ ) );

require_once CS_LISTINGPRO_TOOLKIT_DIR . 'includes/listing-options.php';
require_once CS_LISTINGPRO_TOOLKIT_DIR . 'includes/taxonomy-helpers.php';
require_once CS_LISTINGPRO_TOOLKIT_DIR . 'includes/package-helpers.php';

if ( defined( 'WP_CLI' ) && WP_CLI ) {
	require_once CS_LISTINGPRO_TOOLKIT_DIR . 'includes/cli-commands.php';
}
