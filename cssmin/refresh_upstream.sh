BASE=cssmin-v2.0.1.0064
PACKAGE=http://cssmin.googlecode.com/files/$BASE.php

wget -q -O- $PACKAGE > upstream/$BASE.php
git add upstream
