#!/bin/sh
rm -rf upstream
svn export --force http://swfobject.googlecode.com/svn/trunk/ upstream
git add upstream
