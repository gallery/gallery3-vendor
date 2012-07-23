#!/bin/bash
rm modified/*

# Tack on iPad support
cat upstream/flowplayer-src/*.js > modified/flowplayer.js
cat upstream/ipad/flowplayer.*.js >> modified/flowplayer.js

# Stage the SWF files
cp upstream/flowplayer.pseudostreaming/flowplayer.pseudostreaming-byterange-[0-9]*.swf modified/flowplayer.pseudostreaming-byterange.swf
cp upstream/flowplayer.pseudostreaming/flowplayer.pseudostreaming-[0-9]*.swf modified/flowplayer.pseudostreaming.swf
cp upstream/flowplayer-packaged/flowplayer.controls-3.2.12.swf modified/flowplayer.controls.swf
cp upstream/flowplayer-packaged/flowplayer-3.2.12.swf modified/flowplayer.swf

# Minify the JS (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
else
    echo "Minifying!"
    php -r 'require "../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("modified/flowplayer.js"));' > modified/flowplayer.min.js
    mv modified/flowplayer.min.js modified/flowplayer.js
fi
