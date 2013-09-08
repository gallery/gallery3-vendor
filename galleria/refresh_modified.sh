#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/
cd modified/galleria

# Remove plugins and non-minified theme
rm -rf plugins
rm -rf themes/classic/galleria.classic.js
rm -rf themes/classic/classic-demo.html

# Rename already-minified core JS, then delete non-minified version
mv galleria-*.min.js galleria.min.js
rm galleria-*.js

cd ../..
