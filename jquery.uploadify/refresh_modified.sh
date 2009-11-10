rm -rf modified
mkdir modified

unzip -q -o -j upstream/jquery.uploadify.zip -d modified/
rm modified/jquery-1.3.2.min.js
rm modified/jquery.uploadify.v2.1.0.js
rm modified/dwsync.xml
rm modified/swfobject.js
rm modified/default.css
rm modified/expressInstall.swf
rm modified/*.as
rm modified/*.pdf
rm modified/*.php

mv modified/jquery.uploadify.v2.1.0.min.js modified/jquery.uploadify.min.js

# Set the width of the queue item to auto
patch -p0 modified/uploadify.css < patches/auto_width.patch.txt

# remove the carriage returns
tr -d '\r' < modified/uploadify.css > modified/tmp.css
mv modified/tmp.css modified/uploadify.css
