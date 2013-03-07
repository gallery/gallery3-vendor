#!/bin/sh
rm -rf tmp modified
mkdir tmp modified
cd tmp
unzip -q ../upstream/ext-3.3.1.zip
cd ../modified

SRC=../tmp/ext-3.3.1
cp $SRC/adapter/ext/ext-base-debug.js .
cp $SRC/examples/ux/DataView-more.js .
cp $SRC/pkgs/cmp-foundation-debug.js .
cp $SRC/pkgs/data-foundation-debug.js .
cp $SRC/pkgs/data-json-debug.js .
cp $SRC/pkgs/data-list-views-debug.js .
cp $SRC/pkgs/ext-core-debug.js .
cp $SRC/pkgs/ext-dd-debug.js .
cp $SRC/pkgs/ext-foundation-debug.js .
cp $SRC/pkgs/pkg-buttons-debug.js .
cp $SRC/pkgs/pkg-forms-debug.js .
cp $SRC/pkgs/pkg-tree-debug.js .
cp $SRC/pkgs/window-debug.js .
cp $SRC/pkgs/pkg-toolbars-debug.js .

# order is important
FILES=" \
       ext-base-debug.js ext-core-debug.js ext-foundation-debug.js cmp-foundation-debug.js \
       data-list-views-debug.js DataView-more.js data-foundation-debug.js data-json-debug.js \
       pkg-forms-debug.js pkg-buttons-debug.js ext-dd-debug.js pkg-tree-debug.js window-debug.js \
       pkg-toolbars-debug.js \
      "

echo "" > ext-organize-bundle-debug.js
for file in $FILES; do
    cat $file >> ext-organize-bundle-debug.js
    rm $file;
done

# Minify the JS (unless specifically asked not to)
if [ "$1" == "--no-minify" ];
then
    echo "Not minifying!"
else
    ../../gallery_tools/minify_js.sh ext-organize-bundle-debug.js ext-organize-bundle.js
fi

rm -rf ../tmp
