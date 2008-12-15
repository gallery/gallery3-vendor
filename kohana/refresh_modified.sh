#!/bin/sh
find modified -name .svn -prune -o -type f -print0 | xargs -0 rm
tar cf - --exclude='.svn' upstream | (cd modified && tar -xf - --strip-components 1)

# Remove all the stuff we don't want in Gallery3
rm -r modified/application
rm -r modified/modules/archive
rm -r modified/modules/auth
rm -r modified/modules/flot
rm -r modified/modules/gmaps
rm -r modified/modules/kodoc
rm -r modified/modules/payment
rm -r modified/modules/smarty
rm -r modified/modules/unit_test/i18n
rm -r modified/modules/unit_test/tests/Example_Test.php
rm -r modified/modules/unit_test/tests/Valid_Helper_Test.php
rm -r modified/system/fonts
rm -r modified/system/i18n/de_DE
rm -r modified/system/i18n/el_GR
rm -r modified/system/i18n/en_GB
rm -r modified/system/i18n/es_AR
rm -r modified/system/i18n/es_ES
rm -r modified/system/i18n/fi_FI
rm -r modified/system/i18n/fr_FR
rm -r modified/system/i18n/it_IT
rm -r modified/system/i18n/mk_MK
rm -r modified/system/i18n/nl_NL
rm -r modified/system/i18n/pl_PL
rm -r modified/system/i18n/pt_BR
rm -r modified/system/i18n/ru_RU
rm -r modified/system/i18n/zh_CN
rm -r modified/system/vendor
rm -r modified/system/views/pagination
rm modified/example.htaccess
rm modified/index.php
rm modified/install.php
rm modified/kohana.png
rm modified/system/config/captcha.php
rm modified/system/controllers/captcha.php
rm modified/system/i18n/en_US/swift.php
rm modified/system/i18n/en_US/captcha.php
rm modified/system/i18n/en_US/pagination.php
rm modified/system/libraries/Calendar.php
rm modified/system/libraries/Calendar_Event.php
rm modified/system/libraries/Captcha.php
rm modified/system/libraries/Tagcloud.php
rm modified/system/views/kohana_calendar.php

# Move all the code in 'system' to 'kohana'
tar cf - --exclude='.svn' modified/system | (cd modified/kohana && tar -xf - --strip-components=2)
rm -rf modified/system
mv "modified/Kohana License.html" "modified/kohana/KohanaLicense.html"
