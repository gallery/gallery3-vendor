#!/bin/sh
find upstream -name .svn -prune -o -type f -print0 | xargs -0 rm
svn export --force http://simple-uploader.googlecode.com/svn/trunk/GalleryUploader/trunk upstream


