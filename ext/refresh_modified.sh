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

# order is important
FILES="ext-base-debug.js ext-core-debug.js ext-foundation-debug.js cmp-foundation-debug.js \
       data-list-views-debug.js DataView-more.js data-foundation-debug.js data-json-debug.js \
       pkg-forms-debug.js pkg-buttons-debug.js ext-dd-debug.js pkg-tree-debug.js"

echo "" > ext-organize-bundle-debug.js
for file in $FILES; do
    cat $file >> ext-organize-bundle-debug.js
    rm $file;
done

echo -n "Minifying..."
php -r 'require "../../jsmin-php/upstream/jsmin-1.1.1.php"; echo JSMin::minify(file_get_contents("ext-organize-bundle-debug.js"));' > ext-organize-bundle.js
echo "done."

rm -rf ../tmp


