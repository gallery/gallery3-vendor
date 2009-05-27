PACKAGE=http://swfupload.googlecode.com/files/SWFUpload%20v2.2.0.1%20Core.zip

wget -q -O- $PACKAGE > package.zip
rm -rf upstream
unzip -d upstream package.zip
mv upstream/SWF*/* upstream
rmdir upstream/SWF*
rm -f package.zip
git add upstream
