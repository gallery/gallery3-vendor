#!bin/sh
rm -rf modified
rsync -ra upstream/ modified/
perl -pi -e 's/\r$//' `find modified -name '*.php'`

# Remove all the stuff we don't want in Gallery3.
# Note that this also prunes the default config since Gallery3 uses its own.
rm -rf modified/config
rm -rf modified/README.md
rm -rf modified/.gitignore

cd modified
for p in ../patches/*; do
    echo ">> Applying $p"
    patch -p2 < $p
done
cd ..

# Rewrite the preamble slightly
perl -pi -e 's/defined..SYSPATH.. OR die..No direct script access.../defined("SYSPATH") or die("No direct script access.")/i' `find modified -name '*.php'`
