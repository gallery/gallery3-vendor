#!/bin/sh
rm -rf modified
rsync -ra upstream/ modified/

# Remove all the stuff we don't want in Gallery3.
# Note that this also prunes the default config and views since Gallery3 uses its own.
rm -rf modified/config
rm -rf modified/guide
rm -rf modified/tests
rm -rf modified/views
rm -rf modified/README.md
