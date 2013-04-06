#!/bin/sh
rm -rf tmp modified
mkdir tmp modified

# Unzip the archive
cd tmp
unzip -q ../upstream/johndyer-mediaelement*.zip
mv johndyer-mediaelement* mejs

# Get ready to copy
cd ../modified
SRC=../tmp/mejs/build

# Copy some things that can't be minified
cp $SRC/background.* .
cp $SRC/bigplay.* .
cp $SRC/controls.* .
cp $SRC/loading.* .
cp $SRC/*.swf .
cp $SRC/*.xap .

# Copy JS and CSS as minified (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    cp $SRC/mediaelement.js .
    cp $SRC/mediaelementplayer.js .
    cp $SRC/mediaelementplayer.css .
else
    cp $SRC/mediaelement.min.js        mediaelement.js
    cp $SRC/mediaelementplayer.min.js  mediaelementplayer.js
    cp $SRC/mediaelementplayer.min.css mediaelementplayer.css
fi

rm -rf ../tmp
