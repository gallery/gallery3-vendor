#!/bin/sh
PACKAGE=http://htmlpurifier.org/releases/htmlpurifier-4.0.0-lite.tar.gz

rm -rf upstream
mkdir upstream
wget -q -O- $PACKAGE | (cd upstream && tar xzf - --strip-components=1)
git add upstream
