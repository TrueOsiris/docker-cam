#!/bin/bash
thumbpath=/www/tempthumb/$1/
while :
        do
                day=$(date "+%Y-%m-%d")
                mkdir "/www/$1/pics/$day" 2>/dev/null
                chmod -R 777 "/www/$1/pics/$day" 2>/dev/null
                file1=`ls -tp $thumbpath | grep -v / | head -n2 | sort | head -n1`
                file2=`ls -tp $thumbpath | grep -v / | head -n1`
                totalpixelsf2=`identify -verbose -format %[fx:w*h] "$thumbpath$file2"`
                diff=`compare -fuzz 8% -metric ae "$thumbpath$file1" "$thumbpath$file2" "/tmp/$1_compare_temp.jpg" 2>&1`
                p=`echo "scale=6; ($diff/$totalpixelsf2)" | bc`
                p2=`echo "$p*100" | bc`
                p3=`echo "scale=2; $p2/1" | bc`
                num2=1
                tst=`echo $p3'>'$num2 | bc -l`
                if [ $tst -eq 1 ]; then
                        if [[ ! -e "/www/$1/pics/$file2" ]]; then
                                #echo "`date` copying $file2" >> /www/$1/pics/copy.log
                                cp "$thumbpath$file2" "/www/$1/pics/$day/"
                                filedate=$(date -r /www/$1/pics/$day/$file2 "+%Y-%m-%d %H:%M:%S")
                                convert -size 300x28 xc:none -pointsize 24 -gravity center -stroke black -strokewidth 2 -annotate 0 "$filedate" \
                                        -background none -shadow 100x2+0+0 +repage -stroke none -fill white -annotate 0 "$filedate" "/www/$1/pics/$day/$file2" +swap \
                                        -gravity south -geometry +0-3 -composite "/www/$1/pics/$day/$file2"
                        else
                                echo "`date` file /www/$1/pics$file2 already exists" >> /www/$1/pics/copy.log
                        fi
                fi
                sleep 1
done

