#!/bin/bash
rm modified/*
rm flashembed/modified/*

fe_version=1.0.4

# Generate patched flashembed.js
cp flashembed/upstream/tools.flashembed-${fe_version}.js flashembed/modified/tools.flashembed-${fe_version}.js
patch flashembed/modified/tools.flashembed-${fe_version}.js < flashembed/patches/ticket_30.txt

# Generate patched flowplayer.js
cat upstream/src/javascript/flowplayer.js/flowplayer-src.js flashembed/modified/tools.flashembed-${fe_version}.js > modified/flowplayer.js
cat ipad/upstream/flowplayer.ipad.js >> modified/flowplayer.js

# Minify

# Minify the JS (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
else
    echo "Minifying!"
    php -r 'require "../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("modified/flowplayer.js"));' > modified/flowplayer.min.js
    mv modified/flowplayer.min.js modified/flowplayer.js
fi
