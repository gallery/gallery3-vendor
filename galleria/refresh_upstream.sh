#!/bin/sh
PACKAGE=http://galleria.io/static/galleria-1.2.9.zip

rm -rf upstream
mkdir upstream
wget -q -O- $PACKAGE > upstream/galleria.zip

cd upstream
unzip -q -o galleria.zip
rm -rf galleria.zip
cd ..