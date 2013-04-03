#!/bin/sh
PACKAGE=http://htmlpurifier.org/releases/htmlpurifier-4.5.0-standalone.tar.gz

rm -rf upstream
mkdir upstream
wget -q -O- $PACKAGE | (cd upstream && tar xzf - --strip-components=1)
# git add upstream
