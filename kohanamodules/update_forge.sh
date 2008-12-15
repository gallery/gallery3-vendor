#!/bin/sh
find forge -name .svn -prune -o -type f -print | xargs rm
svn export --force http://kohanamodules.googlecode.com/svn/tags/2.2/forge
