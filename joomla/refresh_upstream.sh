#!/bin/sh
rm -rf upstream
mkdir upstream
cd upstream
svn export http://joomlacode.org/svn/joomla/development/trunk/libraries/joomla/crypt/crypt.php
svn info http://joomlacode.org/svn/joomla/development/trunk/libraries/joomla/crypt/crypt.php
cd ..
git add upstream
