#!/bin/bash
while :
        do
                thumbpath=/www/tempthumb/$1/
                file1=`ls -tp $thumbpath | grep -v / | head -n2 | sort | head -n1`
                file2=`ls -tp $thumbpath | grep -v / | head -n1`
                totalpixelsf2=`identify -verbose -format %[fx:w*h] "$thumbpath$file2"`
                diff=`compare -fuzz 8% -metric ae "$thumbpath$file1" "$thumbpath$file2" null 2>&1`
                p=`echo "scale=6; ($diff/$totalpixelsf2)" | bc`
                p2=`echo "$p*100" | bc`
                p3=`echo "scale=2; $p2/1" | bc`
                num2=1
                tst=`echo $p3'>'$num2 | bc -l`
                if [ $tst -eq 1 ]; then
                        #echo "doing something with $file2"
                        cp "$thumbpath$file2" "/www/$1/pics/"
                fi
                sleep 1
done

#convert -font helvetica -fill white -pointsize 36 -draw 'text 10,50 "Floriade 2002, Canberra, Australia"' floriade.jpg comment.jpg
