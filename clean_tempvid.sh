#!/bin/bash

#
# Takes an argument like '/www/tempvid/stream1/' including the slashes.
# This will constantly keep only the most recent 20 files in folder /www/tempvid/stream1/
# 
# \ls -tp /www/tempvid/stream1/ | grep -v '/$' | tail -n +21 | xargs -I {} rm -- "/www/tempvid/stream1/{}"
#

while :
        do
                \ls -tp $1 | grep -v '/$' | tail -n +21 | xargs -I {} rm -- "$1{}"
                sleep 10
done
