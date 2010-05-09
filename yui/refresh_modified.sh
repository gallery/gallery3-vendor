NAME=yui_2.8.1

rm -rf modified
mkdir -p modified/lib/yui
unzip -q -o -j upstream/$NAME.zip -d modified/lib/yui yui/build/base/base-min.css
unzip -q -o -j upstream/$NAME.zip -d modified/lib/yui yui/build/reset-fonts-grids/reset-fonts-grids.css
git add modified
