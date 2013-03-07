#!/bin/sh
# This script should be compatible with both 3.3.1 and 3.4.0
rm -rf tmp modified
mkdir tmp modified

cd tmp
unzip -q ../upstream/ext-3.*.zip
mv ext-3.* ext-3

cd ../modified
mkdir css images js
SRC=../../tmp/ext-3

# Copy the css
cd css
cp $SRC/examples/ux/css/ux-all.css .
cp $SRC/resources/css/ext-all.css .
cd ..

# Copy the images (NOTE: this list is not dynmically-generated. @todo - refine this)
cd images
mkdir default fam
cd default
mkdir box button dd form grid panel progress qtip toolbar tree window
cp ../$SRC/resources/images/default/s.gif .
cp ../$SRC/resources/images/default/shadow.png .
cp ../$SRC/resources/images/default/shadow-c.png .
cp ../$SRC/resources/images/default/shadow-lr.png .
cp ../$SRC/resources/images/default/box/tb-blue.gif box
cp ../$SRC/resources/images/default/box/tb-blue.gif box
cp ../$SRC/resources/images/default/button/btn.gif button
cp ../$SRC/resources/images/default/dd/drop-no.gif dd
cp ../$SRC/resources/images/default/dd/drop-yes.gif dd
cp ../$SRC/resources/images/default/form/text-bg.gif form
cp ../$SRC/resources/images/default/form/trigger.gif form
cp ../$SRC/resources/images/default/grid/invalid_line.gif grid
cp ../$SRC/resources/images/default/grid/loading.gif grid
cp ../$SRC/resources/images/default/panel/tool-sprites.gif panel
cp ../$SRC/resources/images/default/panel/white-top-bottom.gif panel
cp ../$SRC/resources/images/default/progress/progress-bg.gif progress
cp ../$SRC/resources/images/default/qtip/bg.gif qtip
cp ../$SRC/resources/images/default/toolbar/bg.gif toolbar
cp ../$SRC/resources/images/default/tree/arrows.gif tree
cp ../$SRC/resources/images/default/tree/drop-add.gif tree
cp ../$SRC/resources/images/default/tree/drop-between.gif tree
cp ../$SRC/resources/images/default/tree/drop-over.gif tree
cp ../$SRC/resources/images/default/tree/folder.gif tree
cp ../$SRC/resources/images/default/tree/folder-open.gif tree
cp ../$SRC/resources/images/default/tree/loading.gif tree
cp ../$SRC/resources/images/default/window/left-corners.png window
cp ../$SRC/resources/images/default/window/left-right.png window
cp ../$SRC/resources/images/default/window/right-corners.png window
cp ../$SRC/resources/images/default/window/top-bottom.png window
cd ../fam
cp ../$SRC/examples/shared/icons/fam/delete.gif .
cd ../..

# Copy/minify the JS (unless specifically asked not to)
cd js
if [ "$1" == "--no-minify" ];
then
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
    TARGET="ext-organize-bundle-debug.js"
else
    MIN="../../../gallery_tools/minify_js.sh"
    # All but one of these are already shipped minified, so use them.  We still process them anyway
    # so we can get rid of extra \n, duplicated copyright notices, etc.
    $MIN $SRC/adapter/ext/ext-base.js      ext-base.js        --no-minify
    $MIN $SRC/examples/ux/DataView-more.js DataView-more.js               --no-copyright-header
    $MIN $SRC/pkgs/cmp-foundation.js       cmp-foundation.js  --no-minify --no-copyright-header
    $MIN $SRC/pkgs/data-foundation.js      data-foundation.js --no-minify --no-copyright-header
    $MIN $SRC/pkgs/data-json.js            data-json.js       --no-minify --no-copyright-header
    $MIN $SRC/pkgs/data-list-views.js      data-list-views.js --no-minify --no-copyright-header
    $MIN $SRC/pkgs/ext-core.js             ext-core.js        --no-minify --no-copyright-header
    $MIN $SRC/pkgs/ext-dd.js               ext-dd.js          --no-minify --no-copyright-header
    $MIN $SRC/pkgs/ext-foundation.js       ext-foundation.js  --no-minify --no-copyright-header
    $MIN $SRC/pkgs/pkg-buttons.js          pkg-buttons.js     --no-minify --no-copyright-header
    $MIN $SRC/pkgs/pkg-forms.js            pkg-forms.js       --no-minify --no-copyright-header
    $MIN $SRC/pkgs/pkg-tree.js             pkg-tree.js        --no-minify --no-copyright-header
    $MIN $SRC/pkgs/window.js               window.js          --no-minify --no-copyright-header
    $MIN $SRC/pkgs/pkg-toolbars.js         pkg-toolbars.js    --no-minify --no-copyright-header
    TARGET="ext-organize-bundle.js"
fi

# order is important
FILES=" \
       ext-base*.js ext-core*.js ext-foundation*.js cmp-foundation*.js \
       data-list-views*.js DataView-more.js data-foundation*.js data-json*.js \
       pkg-forms*.js pkg-buttons*.js ext-dd*.js pkg-tree*.js window*.js \
       pkg-toolbars*.js \
      "

echo "" > $TARGET
for file in $FILES; do
    cat $file >> $TARGET
    rm $file;
done

rm -rf ../../tmp
