#!/bin/sh
find kohana_modified -name .svn -prune -o -type f -print0 | xargs -0 rm
tar cf - --exclude='.svn' kohana_upstream | (cd kohana_modified && tar -xf - --strip-components 1)

# Remove all the stuff we don't want in Gallery3
rm kohana_modified/system/libraries/Calendar.php
rm -r kohana_modified/application
rm -r kohana_modified/modules/archive
rm -r kohana_modified/modules/auth
rm -r kohana_modified/modules/flot
rm -r kohana_modified/modules/gmaps
rm -r kohana_modified/modules/kodoc
rm -r kohana_modified/modules/payment
rm -r kohana_modified/modules/smarty
rm -r kohana_modified/system/fonts
rm -r kohana_modified/system/i18n
rm -r kohana_modified/system/vendor
rm -r kohana_modified/system/views/pagination
rm -r kohana_modified/modules/unit_test/i18n
rm -r kohana_modified/modules/unit_test/tests/Example_Test.php
rm -r kohana_modified/modules/unit_test/tests/Valid_Test.php
rm kohana_modified/example.htaccess
rm kohana_modified/index.php
rm kohana_modified/install.php
rm kohana_modified/kohana.png
rm kohana_modified/system/config/captcha.php
rm kohana_modified/system/controllers/captcha.php
rm kohana_modified/system/libraries/Calendar_Event.php
rm kohana_modified/system/libraries/Captcha.php
rm kohana_modified/system/libraries/Tagcloud.php
rm kohana_modified/system/views/kohana_calendar.php

# Move all the code in 'system' to 'kohana'
tar cf - --exclude='.svn' kohana_modified/system | (cd kohana_modified/kohana && tar -xf - --strip-components=2)
rm -rf kohana_modified/system
mv "kohana_modified/Kohana License.html" "kohana_modified/kohana/KohanaLicense.html"
