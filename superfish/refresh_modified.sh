#!/bin/bash
NAME=joeldbirch-superfish

rm -rf modified
mkdir modified

cd modified
mkdir css images js
cd ..

# Extract the three files we need
unzip -q -o -j upstream/$NAME*.zip -d modified/css $NAME*/css/superfish.css
unzip -q -o -j upstream/$NAME*.zip -d modified/images $NAME*/images/arrows-ffffff.png
unzip -q -o -j upstream/$NAME*.zip -d modified/js $NAME*/js/superfish.js

# Minify the JS (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
else
    ../gallery_tools/minify_js.sh modified/js/superfish.js modified/js/superfish.js
fi
