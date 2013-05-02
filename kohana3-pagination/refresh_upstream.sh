#!/bin/sh
rm -rf upstream
git clone -b 3.3/master https://github.com/shadowhand/pagination.git upstream
rm -rf `find upstream -name '.git*'`
