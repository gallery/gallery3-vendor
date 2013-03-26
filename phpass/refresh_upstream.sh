PACKAGE=http://www.openwall.com/phpass/phpass-0.3.tar.gz

rm -rf upstream
mkdir upstream
wget -q -O- $PACKAGE | (cd upstream && tar xzf - --strip-components=1)
# git add upstream
