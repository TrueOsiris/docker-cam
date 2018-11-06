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
                        echo "$s: $q";
                        mkdir "/www/$s" 2>&1;
                        chmod -R 777 /www/$s 2>&1;
                        mkdir "/www/tempvid/$s" 2>&1;
                        chmod -R 777 /www/tempvid/$s 2>&1;
                        ./clean_tempvid.sh "/www/tempvid/$s/" &
                        # ./grabber.sh $q $s
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
