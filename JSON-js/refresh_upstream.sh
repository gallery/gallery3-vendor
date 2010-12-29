#!/bin/sh
rm -rf upstream
git clone https://github.com/douglascrockford/JSON-js.git upstream
cd upstream
git log | head -1
/bin/rm -rf .git


