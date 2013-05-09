#!/bin/bash
rm -rf modified
mkdir modified

unzip -q -o -j upstream/jquery.uploadify.zip -d modified/
rm modified/jquery-1.3.2.min.js
rm modified/jquery.uploadify.v2.1.0.min.js
rm modified/dwsync.xml
rm modified/swfobject.js
rm modified/default.css
rm modified/expressInstall.swf
rm modified/*.as
rm modified/*.pdf
rm modified/*.php

# Set the width of the queue item to auto
patch -p0 modified/uploadify.css < patches/auto_width.patch.txt

# remove the carriage returns
tr -d '\r' < modified/uploadify.css > modified/tmp.css
mv modified/tmp.css modified/uploadify.css

patch -R -p1 modified/uploadify.css < patches/rtl.patch.txt

# Fix up the way we inject names into the queue
patch -p0 modified/jquery.uploadify.v2.1.0.js < patches/js_filename.patch.txt


# Minify the JS (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
else
    bash ../gallery_tools/minify_js.sh modified/jquery.uploadify.v2.1.0.js modified/jquery.uploadify.min.js
fi

rm modified/jquery.uploadify.v2.1.0.js

# prepend our preamble
php preamble.php uploadify.php > modified/uploadify.php
php -r "print 'print base64_decode(\"' . base64_encode(file_get_contents('modified/uploadify.swf')) . '\");';" >> modified/uploadify.php

php preamble.php uploadify.allglyphs.php > modified/uploadify.allglyphs.php
php -r "print 'print base64_decode(\"' . base64_encode(file_get_contents('modified/uploadify.swf')) . '\");';" >> modified/uploadify.allglyphs.php

rm modified/*.swf


