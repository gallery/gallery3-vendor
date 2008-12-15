#!/bin/sh
find kohana_upstream -name .svn -prune -o -type f -print0 | xargs -0 rm
svn export --force http://source.kohanaphp.com/trunk kohana_upstream


