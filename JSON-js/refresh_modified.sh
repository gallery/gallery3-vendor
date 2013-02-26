#!/bin/sh
rm -rf modified
mkdir modified

cat > modified/json2-min.js <<EOF
/*
    json2.js
    2012-10-08

    Public Domain.

    NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.

    See http://www.JSON.org/js.html
*/
EOF

php -r 'require "../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("upstream/json2.js"));' >> modified/json2-min.js

