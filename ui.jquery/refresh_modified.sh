#!/bin/bash
cat upstream/*.js | perl -pe 's/\r//g' > modified/jquery-ui.js
