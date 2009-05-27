#!/bin/sh
rm -rf upstream
svn export --force http://source.kohanaphp.com/trunk upstream
git add upstream



