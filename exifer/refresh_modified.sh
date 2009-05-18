#!/bin/sh
find modified -name .svn -prune -o -type f -print0 | xargs -0 rm
tar cf - --exclude='.svn' upstream | (cd modified && tar -xf - --strip-components 1)
for file in `find modified -name .svn -prune -o \( -name "*.php" -print \)`; do
  perl -pi -e '$_ = "<?php defined(\"SYSPATH\") or die(\"No direct script access.\");\n" if ($. == 1)' $file
  perl -pi -e 's/\r$//' $file
done

