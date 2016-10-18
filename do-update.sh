#!/bin/ash

# /!\ This script use ASH

# mardi 18 octobre 2016, 09:55:34 (UTC+0200)

# delete all zip files in this dir, download a new release from a local origin and uncompress it

rm *.zip | true & wget http://172.16.100.136/chipbox/dist/release.zip && unzip release.zip
