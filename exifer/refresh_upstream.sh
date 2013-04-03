#!/bin/bash
rm -rf upstream
mkdir upstream
mkdir upstream/makers

SOURCE=http://github.com/zenphoto/zenphoto/raw/master/zp-core/exif
TARGET=upstream

wget -q -O- --no-check-certificate $SOURCE/exif.php             > $TARGET/exif.php
wget -q -O- --no-check-certificate $SOURCE/makers/canon.php     > $TARGET/makers/canon.php
wget -q -O- --no-check-certificate $SOURCE/makers/fujifilm.php  > $TARGET/makers/fujifilm.php
wget -q -O- --no-check-certificate $SOURCE/makers/gps.php       > $TARGET/makers/gps.php
wget -q -O- --no-check-certificate $SOURCE/makers/nikon.php     > $TARGET/makers/nikon.php
wget -q -O- --no-check-certificate $SOURCE/makers/olympus.php   > $TARGET/makers/olympus.php
wget -q -O- --no-check-certificate $SOURCE/makers/panasonic.php > $TARGET/makers/panasonic.php
wget -q -O- --no-check-certificate $SOURCE/makers/sanyo.php     > $TARGET/makers/sanyo.php
