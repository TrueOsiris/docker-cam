#!/bin/bash
fuz=10
thumbpath=/www/tempthumb/$1/bw/
realpath=/www/tempthumb/$1/
while :
        do
                day=$(date "+%Y-%m-%d")
                if [[ ! -d "/www/$1/pics/$day" ]]; then
                        echo "Creating directory /www/$1/pics/$day"
                        mkdir "/www/$1/pics/$day" 2>&1
                        chmod -R 777 "/www/$1/pics/$day" 2>&1
                fi
                file1=`ls -tp $thumbpath | grep -v / | head -n2 | sort | head -n1`
                file2=`ls -tp $thumbpath | grep -v / | head -n1`
                totalpixelsf2=`identify -verbose -format %[fx:w*h] "$thumbpath$file2"`
                diff=`compare -fuzz "$fuz%" -metric ae "$thumbpath$file1" "$thumbpath$file2" "/tmp/$1_compare_temp.jpg" 2>&1`
                p=`echo "scale=6; ($diff/$totalpixelsf2)" | bc 2>/dev/null`
                p2=`echo "$p*100" | bc 2>/dev/null`
                p3=`echo "scale=2; $p2/1" | bc 2>/dev/null`
                num2=1
                sec=$(date "+%Y-%m-%d %H:%M:%S")
                echo "$sec fuzz:$fuz str:$1 difpix:$diff tpix:$totalpixelsf2 r:$p3" >> "/www/$1/pics/$day.log"
                tst=`echo $p3'>'$num2 | bc -l`
                if [ $tst -eq 1 ]; then
                        if [[ ! -e "/www/$1/pics/$file2" ]]; then
                                cp "$realpath$file2" "/www/$1/pics/$day/" 2>&1
                                filedate=$(date -r /www/$1/pics/$day/$file2 "+%Y-%m-%d %H:%M:%S") 2>&1
                                convert -size 300x28 xc:none -pointsize 24 -gravity center -stroke black -strokewidth 2 -annotate 0 "$filedate" \
                                        -background none -shadow 100x2+0+0 +repage -stroke none -fill white -annotate 0 "$filedate" "/www/$1/pics/$day/$file2" +swap \
                                        -gravity south -geometry +0-3 -composite "/www/$1/pics/$day/$file2" 2>&1
                        else
                                echo "`date` file /www/$1/pics/$file2 already exists" >> "/www/$1/pics/$day.log"
                        fi
                fi
                sleep 1
done
