BASE=jsmin-1.1.1
PACKAGE=http://jsmin-php.googlecode.com/files/$BASE.php

wget -q -O- $PACKAGE > upstream/$BASE.php
git add upstream
