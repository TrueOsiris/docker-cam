#!/bin/bash
mkdir "/www/tempvid" 2>&1
chmod -R 777 /www/tempvid 2>&1
for y in {1..10}
do
        s="stream$y";
        q=${!s};
        if [ -z ${q+x} ]; then
                echo "$s is unset";
        else
                if [ -n "$q" ]; then
                        echo "Starting processes for $s: $q";
                        mkdir "/www/$s" 2>&1;
                        chmod -R 777 /www/$s 2>&1;
                        mkdir "/www/tempvid/$s" 2>&1;
                        chmod -R 777 /www/tempvid/$s 2>&1;
                        ps -auxw | grep -e [f]fmpeg | grep $s | awk '{print $2}' | xargs kill 2>/dev/null
                        ps -auxw | grep -e [c]lean_ | grep $s | awk '{print $2}' | xargs kill 2>/dev/null
                        /sbin/clean_tempvid.sh "/www/tempvid/$s/" &

                        ffmpeg  -rtsp_transport tcp \
                                -i $q \
                                -vcodec copy \
                                -an \
                                -map 0 \
                                -f segment \
                                -segment_time 15 \
                                -segment_format mp4 \
                                -strftime 1 \
                                "/www/tempvid/$s/$s-%Y-%m-%d_%H-%M-%S.mp4" \
                                >/dev/null 2>&1 &
                else
                        echo "$s is not defined.";
                fi
        fi
done
