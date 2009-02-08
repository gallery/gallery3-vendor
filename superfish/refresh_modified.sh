NAME=superfish-1.4.8

find modified -name .svn -prune -o -type f -print0 | xargs -0 rm
unzip -q -o -j upstream/$NAME.zip -d modified/css $NAME/css/superfish.css
unzip -q -o -j upstream/$NAME.zip -d modified/images $NAME/images/arrows-ffffff.png
unzip -q -o -j upstream/$NAME.zip -d modified/images $NAME/images/shadow.png
unzip -q -o -j upstream/$NAME.zip -d modified/js $NAME/js/superfish.js
