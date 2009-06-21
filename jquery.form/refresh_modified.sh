#!/bin/bash
cat upstream/jquery.form.js | perl -pe 's/\r//g' > modified/jquery.form.js
