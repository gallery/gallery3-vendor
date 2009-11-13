rm -rf modified
mkdir modified

cp upstream/jquery.autocomplete.css modified/
cp upstream/jquery.autocomplete.pack.js modified/jquery.autocomplete.js

# Add a semi-colon to the end of the autocomplete.js file so when its combined
# It doesn't create problems.
echo ";" >> modified/jquery.autocomplete.js

# Set the width of the queue item to auto
patch -p0 modified/jquery.autocomplete.css < patches/css.txt
