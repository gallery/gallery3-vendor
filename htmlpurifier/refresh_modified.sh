#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

# Remove all the stuff we don't want in Gallery3
rm modified/NEWS
rm modified/INSTALL
rm modified/CREDITS

cd modified/library
mv * ..
cd ../..
rmdir modified/library

# Put the Kohana license down with its code
mv "modified/LICENSE" "modified/HTMLPurifierLicense"

for file in `find modified -name "*.php"`; do
  perl -pi -e '$_ = "<?php defined(\"SYSPATH\") or die(\"No direct script access.\");\n" if ($. == 1)' $file
  perl -pi -e 's/\r$//' $file
done

git add modified
