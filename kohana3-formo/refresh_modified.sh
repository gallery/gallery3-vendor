#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

# Remove all the stuff we don't want in Gallery3.
# Note that this also prunes the default config and views since Gallery3 uses its own.
rm -rf modified/config
rm -rf modified/guide
rm -rf modified/tests
rm -rf modified/views
rm -rf modified/README.md

# Rewrite the preamble slightly
perl -pi -e 's/defined..SYSPATH.. OR die..No direct script access.../defined("SYSPATH") or die("No direct script access.")/i' `find modified -name '*.php'`
