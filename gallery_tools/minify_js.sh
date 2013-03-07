#!/bin/sh
input=$1
output=$2
input=`dirname $input`/${input##*/}
output=`dirname $output`/${output##*/}
phpfile=`dirname $0`/minify_js.php

php $phpfile $input $output $3 $4
