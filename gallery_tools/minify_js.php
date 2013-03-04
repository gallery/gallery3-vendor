<?php
/**
 * This script minifies a JS file for use with Gallery.  Importantly, it keeps any copyright
 * header that may be at the start of the file.
 */

/**
 * Check and parse the arguments.
 */

  // Must run from CLI
  if (PHP_SAPI != "cli") {
    print "Must run from command line.\n";
    exit(1);
  }

  // Check syntax, return help info if incorrect
  $args = $_SERVER["argv"];
  if (count($args) != 3) {
    print "This script minifies JS for use with Gallery.  The syntax is:\n";
    print "  php minify_js.php input_path output_path\n";
    print "The paths should be relative to the gallery3-vendor root (i.e. the parent directory of this script).\n";
    print "The input and output paths can be the same.\n";
    exit(1);
  }

  // Parse arguments, check input, return error if not found
  $input_file = $args[1];
  $output_file = $args[2];
  if (!file_exists($input_file) || !filesize($input_file)) {
    print "Input file not found: $input_file\n";
    exit(1);
  } else {
    print "Minifying $input_file...\n";
  }

/**
 * Extract the copyright header.  First, set some parameters.
 */

  // Set the number of characters we pull from the start of the source file for our search.
  $copyright_search_max = 15000;
  // Set the max size.
  $copyright_length_max = 1500;
  // Set the min size.  This is only used if we find something too long and need to shorten it.
  $copyright_length_min = 50;
  // Set some keywords.  If we need to shorten it, we ensure that we keep the first occurrence of these.
  $copyright_keywords = array("copyright", "warranty", "http");

  $input = file_get_contents($input_file, null, null, 0, $copyright_search_max);
  $copyright_header = get_leading_comment($input);
  if ($copyright_header) {
    // Found - check if too long and shorten if needed (e.g. json2.php has entire docs in the header).
    if (strlen($copyright_header) > $copyright_length_max) {
      // Set the min length.
      $copyright_length = $copyright_length_min;
      // Make sure we get the first case-insensitive occurrence of each keyword (if found).
      foreach ($copyright_keywords as $keyword) {
        $copyright_length = max($copyright_length, stripos($copyright_header, $keyword));
      }
      // Go to the end of the line, then close the comment.
      $copyright_length = strpos($copyright_header, "\n", $copyright_length);
      $copyright_header = substr($copyright_header, 0, $copyright_length) . "\n*/";
    }
  } else {
    // Not found - make sure we have an empty string and not a null
    $copyright_header = "";
  }

/**
 * Minify and generate the output
 */

  // Minify the JS using php-closure.  This uses a REST API for the
  // Google Closure JS Compiler web service.
  include(dirname(__FILE__) . "/../php-closure/php-closure.php");
  $minify = new PhpClosure();
  $output = $minify->add($input_file)
                   ->hideDebugInfo()  // otherwise _compile() will return extra info
                   ->simpleMode()     // advancedMode could mangle variable names used externally
                   ->_compile();      // using write() echos _compile() instead

  // Check that the minifier worked
  if (!$output) {
    print "Google Closure minification failed.\n";
    exit(1);
  }

  // If the output starts with another comment or \n, remove them.
  ltrim($output, "\n");
  while ($comment = get_leading_comment($output)) {
    $output = substr($output, strlen($comment));
    $output = ltrim($output, "\n");
  }

  // Build the output file
  $input_size = filesize($input_file);  // do this first in case input and output are the same.
  @unlink($output_file);
  file_put_contents($output_file, $copyright_header . "\n" . $output);
  if (file_exists($output_file) && filesize($output_file)) {
    $output_size = filesize($output_file);
    print "$input_file successfully minified! $input_size bytes --> $output_size bytes\n";
    exit(0);
  } else {
    print "$input_file minification failed.\n";
    exit(1);
  }

/**
 * Look for and extract leading extended comments.
 */
function get_leading_comment($input) {
  if (substr($input, 0, 2) == "/*") {
    $comment = substr($input, 0, strpos($input, "*/"));
    if (!strlen($comment)) {
      // No closing */ - return all input and close the comment.
      return $input . "\n*/";
    }
    return $comment . "*/";
  }
  return null;
}
?>
