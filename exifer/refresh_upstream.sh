#!/bin/sh
find upstream -name .svn -prune -o -type f -print0 | xargs -0 rm
svn export --force http://www.zenphoto.org/svn/trunk/zp-core/exif/ upstream
