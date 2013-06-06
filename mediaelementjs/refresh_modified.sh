#!/bin/sh
rm -rf tmp modified
mkdir tmp modified

# Get ready to copy
cd modified
SRC=../upstream/build

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

# prepend our preamble
i=0
for swf in *.swf;
do
    php ../preamble.php $swf.php 1 $i > $swf.php
    php -r "print 'print base64_decode(\"' . base64_encode(file_get_contents('$swf')) . '\");';" >> $swf.php
    i=$[i+1]
done
rm *.swf
cd ..
