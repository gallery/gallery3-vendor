#!/bin/sh
rm -rf modified/*

cp upstream/jquery-*.js modified/jquery.js

# Apply patches here, eg:
#   patch modified/jquery.js < patches/ticket_xxxx.txt

# Minify the JS (unless specifically asked not to)
if [ "x$1" = "x--no-minify" ];
then
    echo "Not minifying!"
else
    echo "Minifying!"
    php -r 'require "../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("modified/jquery.js"));' > modified/jquery-min.js
    mv modified/jquery-min.js modified/jquery.js
fi
