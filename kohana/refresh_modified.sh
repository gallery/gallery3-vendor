#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

# Remove all the stuff we don't want in Gallery3
rm -rf modified/application/cache
rm -rf modified/application/config
rm -rf modified/application/controllers
rm -rf modified/application/helpers
rm -rf modified/application/hooks
rm -rf modified/application/libraries
rm -rf modified/application/logs
rm -rf modified/application/models
rm -rf modified/application/views
rm -rf modified/example.htaccess
rm -rf modified/index.php
rm -rf modified/install.php
rm -rf modified/kohana.png
rm -rf modified/system/config/html_purifier.php
rm -rf modified/system/config/log_database.php
rm -rf modified/system/config/log_file.php
rm -rf modified/system/config/log_syslog.php
rm -rf modified/system/controllers/captcha.php

# Put the Kohana license down with its code
mv "modified/Kohana License.html" "modified/system/KohanaLicense.html"
