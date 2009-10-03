#!/bin/sh
cp -f upstream/swfobject/swfobject.js modified/swfobject.js
cp -f upstream/swfobject_generator/html/index.html generator/index.html

git add modified/swfobject.js
git add generator/index.html

