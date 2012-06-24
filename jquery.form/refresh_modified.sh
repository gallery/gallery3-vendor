#!/bin/bash
cat upstream/jquery.form.js | perl -pe 's/\r//g' > modified/jquery.form.js

php -r 'require "../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("modified/jquery.form.js"));' > modified/jquery.form-jsmin.js
mv modified/jquery.form-jsmin.js modified/jquery.form.js

