#!/bin/sh
find modified -name .svn -prune -o -type f -print0 | xargs -0 rm
tar cf - --exclude='.svn' upstream | (cd modified && tar -xf - --strip-components 1)

# Remove all the stuff we don't want in Gallery3
rm -r modified/i18n
