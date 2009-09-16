#!/bin/bash
# Create an unpacked version in order apply patches
rm modified/*
unzip -d modified -j upstream/*.zip 'development-bundle/ui/jquery-ui-*.custom.js'
cp modified/jquery-ui-*.custom.js modified/jquery-ui.js

# Apply patches here, eg:
#   patch modified/jquery-ui.js < patches/ticket_xxxx.txt
patch modified/jquery-ui.js < patches/ticket_4441.txt
patch modified/jquery-ui.js < patches/ticket_4377.txt
patch modified/jquery-ui.js < patches/ticket_2843.txt
