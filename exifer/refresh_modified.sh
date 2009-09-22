#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

for file in `find modified -name "*.php"`; do
  perl -pi -e '$_ = "<?php defined(\"SYSPATH\") or die(\"No direct script access.\");\n" if ($. == 1)' $file
  perl -pi -e 's/\r$//' $file
  perl -pi -e 's/gettext\(/\(string\) t\(/' $file
done

