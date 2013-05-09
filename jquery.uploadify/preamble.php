<?= "<" . "?" ?>

// Redirect the initial request to strip off any query parameters or URL fragments
// We know it's an initial request if the token is missing
if (empty($_GET["token"])) {
  // We have not yet redirected
  $rand = rand();
  setcookie("uploadify_token", $rand);
  header("Location: <?= $argv[1] ?>?token=$rand#");
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
