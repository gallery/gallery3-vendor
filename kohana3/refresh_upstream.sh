#!/bin/sh
rm -rf upstream
git clone --recurse-submodules http://github.com/kohana/kohana.git upstream
rm -rf `find upstream -name '.git*'`
