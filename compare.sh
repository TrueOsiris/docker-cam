#!/bin/bash
## param 1 is the stream name
if [ -z $1 ]; then
        s="stream1"
else
        s=$1
fi
## param 2 is the fuzziness factor to compare
if [ -z $2 ]; then
        fuz=5
else
        fuz=$2
fi
## param 3 is the target directory
if [ -z $3 ]; then
        targetpath="pics"
else
        targetpath=$3
fi
mkdir -p "/www/$s/$targetpath" 2>&1
thumbpath=/www/tempthumb/$s/bw/
realpath=/www/tempthumb/$s/
while :
        do
                day=$(date "+%Y-%m-%d")
                logfile="/www/$s/$targetpath/$day.log"
                if [[ ! -d "/www/$s/$targetpath/$day" ]]; then
                        echo "Creating directory /www/$s/$targetpath/$day" >> $logfile
                        mkdir "/www/$s/$targetpath/$day" 2>&1
                        chmod -R 777 "/www/$s/$targetpath/$day" 2>&1
                fi
                file1=`ls -tp $thumbpath | grep -v / | head -n2 | sort | head -n1`
                file2=`ls -tp $thumbpath | grep -v / | head -n1`
                totalpixelsf2=`identify -verbose -format %[fx:w*h] "$thumbpath$file2"`
                diff=`compare -fuzz "$fuz%" -metric ae "$thumbpath$file1" "$thumbpath$file2" "/tmp/$s_compare$fuz_temp.jpg" 2>&1`
                p=`echo "scale=6; ($diff/$totalpixelsf2)" | bc 2>/dev/null`
                p2=`echo "$p*100" | bc 2>/dev/null`
                p3=`echo "scale=2; $p2/1" | bc 2>/dev/null`
                num2=1
                sec=$(date "+%Y-%m-%d %H:%M:%S")
                tst=`echo $p3'>'$num2 | bc -l`
                #echo "$sec fuzz:$fuz str:$1 difpix:$diff tpix:$totalpixelsf2 r:$p3 t:$tst" >> $logfile
                if [ -z "$tst" ]; then
                        #echo "${tst}"
                        if [ "${tst}" = "1" ]; then
                                if [[ ! -e "/www/$s/$targetpath/$file2" ]]; then
                                        if [[ -e "$realpath$file2" ]]; then
                                                cp "$realpath$file2" "/www/$s/$targetpath/$day/" 2>>$logfile 1>>$logfile
                                                filedate=$(date -r /www/$s/$targetpath/$day/$file2 "+%Y-%m-%d %H:%M:%S") 2>>$logfile
                                                convert -size 300x28 xc:none -pointsize 24 -gravity center -stroke black -strokewidth 2 \
                                                        -annotate 0 "$filedate" -background none -shadow 100x2+0+0 +repage -stroke none \
                                                        -fill white -annotate 0 "$filedate" "/www/$s/$targetpath/$day/$file2" +swap \
                                                        -gravity south -geometry +0-3 -composite "/www/$s/$targetpath/$day/$file2" 2>>$logfile
                                                /sbin/movevid.sh $s $file2 &
                                        else
                                                echo "`date` sourcefile $realpath$file2 does not exist" >> $logfile
                                        fi
                                else
                                        echo "`date` file /www/$s/$targetpath/$file2 already exists" >> $logfile
                                fi
                        fi
                fi
                sleep 1
done
