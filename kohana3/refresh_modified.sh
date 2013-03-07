#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

# Remove all the stuff we don't want in Gallery3
rm -rf `find modified -name userguide.php`
rm -rf `find modified -name '.md' | egrep -v 'LICENSE.md'`
rm -rf modified/.travis.yml
rm -rf modified/CONTRIBUTING.md
rm -rf modified/README.md
rm -rf modified/application/cache/
rm -rf modified/application/classes/
rm -rf modified/application/config/
rm -rf modified/application/i18n/
rm -rf modified/application/logs/
rm -rf modified/application/messages/
rm -rf modified/application/views/
rm -rf modified/build.xml
rm -rf modified/composer.json
rm -rf modified/example.htaccess
rm -rf modified/index.php
rm -rf modified/install.php
rm -rf modified/modules/*/guide
rm -rf modified/modules/auth
rm -rf modified/modules/cache
rm -rf modified/modules/codebench
rm -rf modified/modules/database/config
rm -rf modified/modules/unittest
rm -rf modified/modules/image/README.markdown
rm -rf modified/modules/minion
rm -rf modified/modules/orm/auth-schema-*.sql
rm -rf modified/modules/unittest/example.phpunit.xml
rm -rf modified/modules/userguide
rm -rf modified/system/config/
rm -rf modified/system/config/credit_cards.php
rm -rf modified/system/config/userguide.php
rm -rf modified/system/guide/
rm -rf modified/system/i18n/
rm -rf modified/system/media/
rm -rf modified/system/tests
rm -rf modified/system/views/kohana/generate_logo.php
rm -rf modified/system/views/kohana/logo.php
rmdir `find modified -type d -empty`

# Put the Kohana license down with its code
mv modified/LICENSE.md modified/system
