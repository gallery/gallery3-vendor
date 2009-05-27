BASE=superfish-1.4.8
PACKAGE=http://users.tpg.com.au/j_birch/plugins/superfish/$BASE.zip

wget -q -O- $PACKAGE > upstream/$BASE.zip
git add upstream
