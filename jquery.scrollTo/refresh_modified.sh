#!/bin/bash
cat upstream/jquery.scrollTo.js | perl -pe 's/\r//g' > modified/jquery.scrollTo.js
