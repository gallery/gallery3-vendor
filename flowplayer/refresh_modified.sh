#!/bin/bash
FP_VERSION="3\.2\.12"

rm modified/*

# Generate patched flashembed.js
cp upstream/flashembed.js modified/flashembed.js
patch modified/flashembed.js < patches/ticket_30_rev20130226.txt

# Add version number to flowplayer.js
cp upstream/flowplayer-src.js modified/flowplayer.js
sed -i "s/@VERSION/"$FP_VERSION"/g" modified/flowplayer.js
sed -i "s/@REVISION/"$FP_VERSION", patched for use with Gallery 3/g" modified/flowplayer.js
sed -i "s/@DATE/"`date +\%Y-\%m\-%d`"/g" modified/flowplayer.js

# Rebuild flowplayer.js, tack on iPad support
cat modified/flashembed.js >> modified/flowplayer.js
cat upstream/flowplayer.ipad-[0-9]*.js >> modified/flowplayer.js
unlink modified/flashembed.js

# Stage the SWF files
cp upstream/flowplayer.pseudostreaming/flowplayer.pseudostreaming-byterange-[0-9]*.swf modified/flowplayer.pseudostreaming-byterange.swf
cp upstream/flowplayer.pseudostreaming/flowplayer.pseudostreaming-[0-9]*.swf modified/flowplayer.pseudostreaming.swf
cp upstream/flowplayer/flowplayer.controls-[0-9]*.swf modified/flowplayer.controls.swf
cp upstream/flowplayer/flowplayer-[0-9]*.swf modified/flowplayer.swf

# Minify the JS (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
else
    ../gallery_tools/minify_js.sh modified/flowplayer.js modified/flowplayer.js
fi
