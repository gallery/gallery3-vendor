#!/bin/bash
NAME=joeldbirch-superfish-master
PACKAGE=http://github.com/joeldbirch/superfish/zipball/master

wget -q -O- --no-check-certificate $PACKAGE > upstream/$NAME.zip
