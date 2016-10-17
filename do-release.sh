#!/bin/bash

# lundi 17 octobre 2016, 23:05:07 (UTC+0200)

rm -rf dist/release.zip | true

zip -9 -r -x@release-exclude.txt dist/release.zip . 

