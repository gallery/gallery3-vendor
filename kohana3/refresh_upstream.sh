#!/bin/sh
rm -rf upstream
git clone -b 3.3/develop --recurse-submodules http://github.com/kohana/kohana.git upstream

# switch all submodules over to 3.3/develop (tracks our patches in ORM)
cd upstream
git submodule foreach git checkout 3.3/develop
cd ..

rm -rf `find upstream -name '.git*'`
