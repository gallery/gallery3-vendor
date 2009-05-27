#!/bin/sh
rm -rf upstream
svn export --force http://kohanamodules.googlecode.com/svn/tags/2.2/forge upstream
git add upstream
