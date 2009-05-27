#!/bin/sh
rm -rf upstream
svn export --force http://www.zenphoto.org/svn/trunk/zp-core/exif/ upstream
git add upstream
