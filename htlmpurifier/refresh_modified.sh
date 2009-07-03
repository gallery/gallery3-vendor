#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

# Remove all the stuff we don't want in Gallery3
rm -r modified/art
rm -r modified/extras
rm -r modified/maintenance
rm -r modified/benchmarks
rm -r modified/configdoc
rm -r modified/smoketests
rm -r modified/tests
rm -r modified/docs
rm -r modified/plugins

rm modified/release1-update.php
rm modified/VERSION
rm modified/FOCUS
rm modified/NEWS
rm modified/release2-tag.php
rm modified/WHATSNEW
rm modified/INSTALL
rm modified/package.php
rm modified/WYSIWYG
rm modified/CREDITS
rm modified/INSTALL.fr.utf8
rm modified/phpdoc.ini
rm modified/test-settings.sample.php
rm modified/Doxyfile
rm modified/README
rm modified/TODO

# Put the Kohana license down with its code
mv "modified/LICENSE" "modified/HTMLPurifierLicense"
