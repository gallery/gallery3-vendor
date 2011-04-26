#!/bin/sh
rm -rf upstream
mkdir tmp
cd tmp
wget http://tinsology.net/downloads/LoremIpsum.zip
cd ..
mkdir upstream
cd upstream
unzip ../tmp/LoremIpsum.zip
cd ..
rm -rf tmp
