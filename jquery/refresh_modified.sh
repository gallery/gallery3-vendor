#!/bin/bash
rm modified/*

# Stage the already-minified files (note that localScroll becomes all lowercase!)
cp upstream/jquery-[0-9]*.js modified/jquery.js
cp upstream/jquery-ui*.js modified/jquery-ui.js
cp upstream/jquery.scrollTo*.js modified/jquery.scrollTo.js
cp upstream/jquery.localScroll*.js modified/jquery.localscroll.js

# Minify the others (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
    cp upstream/jquery.cookie.js modified/jquery.cookie.js
    cp upstream/jquery.form.js modified/jquery.form.js
else
    ../gallery_tools/minify_js.sh upstream/jquery.cookie.js modified/jquery.cookie.js
    ../gallery_tools/minify_js.sh upstream/jquery.form.js modified/jquery.form.js
fi
