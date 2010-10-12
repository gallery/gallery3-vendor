BASE=yui_2.8.1
PACKAGE=http://yuilibrary.com/downloads/yui2/$BASE.zip

wget -q -O- $PACKAGE > upstream/$BASE.zip
git add upstream
