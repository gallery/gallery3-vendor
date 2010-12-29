#!/bin/sh
rm -rf modified
mkdir modified

php -r 'require "../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("upstream/json2.js"));' > modified/json2-min.js

