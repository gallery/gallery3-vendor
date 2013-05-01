#!/bin/sh
rm -rf upstream
git clone --recurse-submodules http://github.com/webking/kohana-pagination.git upstream
rm -rf `find upstream -name '.git*'`
