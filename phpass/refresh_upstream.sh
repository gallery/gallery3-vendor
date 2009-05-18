PACKAGE=http://www.openwall.com/phpass/phpass-0.1.tar.gz

find upstream -name .svn -prune -o -type f -print0 | xargs -0 rm
wget -q -O- $PACKAGE | (cd upstream && tar xzf - --strip-components=1)
