#!/bin/bash
rm modified/*
unzip -d modified -j upstream/*.zip 'development-bundle/ui/jquery-ui-*.custom.js'
mv modified/jquery-ui-*.custom.js modified/jquery-ui.js

# Apply patches here, eg:
#   patch modified/jquery-ui.js < patches/ticket_xxxx.txt
#
# Note that since the upgrade to 1.8.21 I have commented out
# these patches so that we can see if we need them before we
# figure out how to apply them (not all of them apply cleanly anymore)
#
#patch modified/jquery-ui.js < patches/ticket_4441.txt
#patch modified/jquery-ui.js < patches/ticket_4377.txt
#patch modified/jquery-ui.js < patches/ticket_2843.txt
#patch modified/jquery-ui.js < patches/ticket_5370.txt

# Minify the JS (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
else
    echo "Minifying!"
    php -r 'require "../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("modified/jquery-ui.js"));' > modified/jquery-ui-jsmin.js
    mv modified/jquery-ui-jsmin.js modified/jquery-ui.js
fi
