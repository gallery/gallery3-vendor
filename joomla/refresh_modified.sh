#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

for file in `find modified -name "*.php"`; do
  perl -pi -e '$_ = "<?php defined(\"SYSPATH\") or die(\"No direct script access.\");\n" if ($. == 1)' $file
  perl -pi -e '$_ = "// $_" if /JPATH_PLATFORM/' $file
done

