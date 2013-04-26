#!/bin/sh
rm -rf upstream
git clone -b 3.3/develop --recurse-submodules http://github.com/kohana/kohana.git upstream
rm -rf `find upstream -name '.git*'`
