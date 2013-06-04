#!/bin/sh
rm -rf upstream
git clone http://github.com/johndyer/mediaelement.git upstream
rm -rf `find upstream -name '.git*'`
