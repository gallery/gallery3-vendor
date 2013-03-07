#!/bin/sh
rm -rf modified
mkdir modified

# Minify the JS (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
else
    ../gallery_tools/minify_js.sh upstream/json2.js modified/json2-min.js
fi
