#!/bin/bash
s=$1
q=$2
e=`ps -auxw | grep -e [f]fmpeg | grep $s | grep jpg | grep gray | awk '{print $2}' 2>/dev/null;`
p="/www/tempthumb/$s/bw/"

echo "killing previous blackwhite thumb capturing process: $e"
ps -auxw | grep -e [f]fmpeg | grep $s | grep jpg | grep gray | awk '{print $2}' | xargs kill 2>/dev/null;

while :
        do
                # If no files less than 1 minute old are found ...
                if [[ -z $(find $p -type f -mmin -1 2>/dev/null) ]]; then
                        echo "no files younger than 1 minute exist in $p";
                        echo "killing previous blackwhite thumb capturing process: $e";
                        ps -auxw | grep -e [f]fmpeg | grep $s | grep jpg | grep gray | awk '{print $2}' | xargs kill 2>/dev/null;
                        echo "launching blackwhite thumb capturing for $s on $q";
                        ffmpeg  -rtsp_transport tcp \
                                -i $q \
                                -an \
                                -map 0 \
                                -vf fps=1,format=gray,format=yuv422p,scale="512:-1" \
                                -strftime 1 \
                                "/www/tempthumb/$s/bw/$s-%Y-%m-%d__%H-%M-%S.jpg" \
                                >/dev/null 2>&1 &
                fi
                sleep 15
done
