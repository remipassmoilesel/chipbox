#!/bin/bash

# lundi 17 octobre 2016, 23:05:07 (UTC+0200)

cd dist

rm -rf release.zip chipbox | true

git clone .. chipbox

cd chipbox

git submodule init
git submodule update

cd ..

zip -9 -r -x@../release-exclude.txt release.zip chipbox

rm -rf chipbox

echo 
echo "Release ready"
