#!/bin/sh
rm -rf upstream
git clone --recurse-submodules http://github.com/bmidget/kohana-formo.git upstream
rm -rf `find upstream -name '.git*'`
