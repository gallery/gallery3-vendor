#!/bin/sh
find upstream -name .svn -prune -o -type f -print0 | xargs -0 rm
svn export --force http://kohanamodules.googlecode.com/svn/tags/2.2/forge upstream
