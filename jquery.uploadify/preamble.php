<?= "<" . "?php" ?>

/**
 * Gallery - a web based photo album viewer and editor
 * Copyright (C) 2000-2013 Bharat Mediratta
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA  02110-1301, USA.
 */

// Redirect the initial request to strip off any query parameters or URL fragments
// We know it's an initial request if the token is missing
if (empty($_GET["token"])) {
  // We have not yet redirected
  $rand = md5(rand());
  setcookie("uploadify_token", $rand);
  header("Location: <?= $argv[1] ?>?token=$rand#.");
  exit;
}

// If the token exists but there's no cookie, then this is a bogus token
// or the user does not support cookies.  Ignore this request.
if (empty($_COOKIE["uploadify_token"])) {
  exit;
}

// If the token exists but it doesn't match our cookie, then this is a bogus
// request.  Ignore this request.
if ($_GET["token"] != $_COOKIE["uploadify_token"]) {
  exit;
}

// This is a legitimate request.  Serve it, but disallow caching.
header("Content-Type: application/x-shockwave-flash");
header("Cache-Control: no-cache, no-store, must-revalidate");
setcookie("uploadify_token", "", time() - 3600);
