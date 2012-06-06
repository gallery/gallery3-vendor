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

# Fix up the way we inject names into the queue
patch -p0 modified/jquery.uploadify.v2.1.0.js < patches/js_filename.patch.txt

php -r 'require "../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("modified/jquery.uploadify.v2.1.0.js"));' > modified/jquery.uploadify.min.js
rm modified/jquery.uploadify.v2.1.0.js
