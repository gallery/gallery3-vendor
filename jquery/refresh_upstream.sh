#!/bin/sh
fileName="jquery-$1.js"
if test ! -d upstream  ; then
    mkdir upstream
else
    rm -rf upstream/*
fi
wget "http://code.jquery.com/$fileName" -O "upstream/$fileName"

