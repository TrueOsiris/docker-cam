#!/bin/bash
s=$1
q=$2
p="/www/tempvid/$s/"
t=`ps -auxw | grep -e [f]fmpeg | grep $s | grep mp4 | awk '{print $2}' 2>/dev/null;`;
echo "stopping mp4 generation process for $s: $t";
ps -auxw | grep -e [f]fmpeg | grep $s | grep mp4 | awk '{print $2}' | xargs kill -9 2>/dev/null;

while :
        do
                # If no files less than 1 minute old are found ...
                if [[ -z $(find $p -type f -mmin -1 2>/dev/null) ]]; then
                        echo "no files younger than 1 minute exist in $p";
                        t=`ps -auxw | grep -e [f]fmpeg | grep $s | grep mp4 | awk '{print $2}' 2>/dev/null;`;
                        echo "stopping mp4 generation process for $s: $t";
                        ps -auxw | grep -e [f]fmpeg | grep $s | grep mp4 | awk '{print $2}' | xargs kill -9 2>/dev/null;
                        echo "launching 15 second segment capturing for $s on $q";
                        ffmpeg  -rtsp_transport tcp \
                                -i $q \
                                -vcodec copy \
                                -an \
                                -map 0 \
                                -f segment \
                                -segment_time 15 \
                                -segment_format mp4 \
                                -strftime 1 \
                                "/www/tempvid/$s/$s-%Y-%m-%d__%H-%M-%S.mp4" \
                                >/dev/null 2>&1 &
                fi
                sleep 15
done
