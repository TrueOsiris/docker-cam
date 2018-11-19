#!/bin/bash
declare -a ARR
#while :
 #       do
                day=$(date "+%Y-%m-%d")
                if [[ -d "/www/$1/pics/$day" ]]; then
                        dir="/www/$1/pics/$day"
                        t=`ls -tp $dir | grep -v '/$' | head -10`
                        arr=($t)
                        echo "arr0" ${arr[0]}
                        echo "arr1" ${arr[1]}
                fi
                        #| xargs -I {} rm -- "$1{}"
 #               sleep 5
#done
