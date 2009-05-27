#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

for file in `find modified -name "*.php"`; do
  perl -pi -e '$_ = "<?php defined(\"SYSPATH\") or die(\"No direct script access.\");\n" if ($. == 1)' $file
done

# Remove all the stuff we don't want in Gallery3
rm -r modified/i18n
rm -r modified/controllers
rm -r modified/models
rm -r modified/views


