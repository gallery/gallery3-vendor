#!/bin/sh
git clone -q git://github.com/malsup/form.git tmp
cp tmp/jquery.form.js upstream/jquery.form.js
REV=$(cd tmp && git log | head -1 | awk '{print $2}')
rm -rf tmp
echo "git commit -m 'Updated upstream to $REV' upstream"

