#!/bin/bash
rm modified/*

# Generate patched flowplayer.js
cp upstream/src/javascript/flowplayer.js/flowplayer-src.js modified/flowplayer.js
patch modified/flowplayer.js < patches/ticket_30.txt

# Tack on iPad support
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
