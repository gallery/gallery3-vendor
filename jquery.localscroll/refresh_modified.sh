#!/bin/bash
cat upstream/jquery.localscroll.js | perl -pe 's/\r//g' > modified/jquery.localscroll.js
