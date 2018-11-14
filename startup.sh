#!/bin/bash
mkdir "/www/tempvid" 2>/dev/null
chmod -R 777 /www/tempvid 2>/dev/null
mkdir "/www/tempthumb" 2>/dev/null
chmod -R 777 www/tempthumb 2>/dev/null
for y in {1..10}
do
        s="stream$y";
        q=${!s};
        if [ -z ${q+x} ]; then
                echo "$s is unset";
        else
                if [ -n "$q" ]; then
                        echo "$s: $q";
                        mkdir "/www/$s" 2>/dev/null;
                        mkdir "/www/$s/pics" 2>/dev/null;
                        mkdir "/www/$s/vids" 2>/dev/null;
                        chmod -R 777 /www/$s 2>/dev/null;
                        mkdir "/www/tempvid/$s" 2>/dev/null;
                        chmod -R 777 /www/tempvid/$s 2>/dev/null;
                        mkdir "/www/tempthumb/$s" 2>/dev/null;
                        chmod -R 777 /www/tempthumb/$s 2>/dev/null;
                        ps -auxw | grep -e [f]fmpeg | grep $s | grep mp4 | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [f]fmpeg | grep $s | grep jpg | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [c]lean_ | grep vid | grep $s | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [c]lean_ | grep thumb | grep $s | awk '{print $2}' | xargs kill 2>/dev/null;
                        # cleaning up extra temp videos and thumbs
                        /sbin/clean_tempvid.sh "/www/tempvid/$s/" &
                        /sbin/clean_tempvid.sh "/www/tempthumb/$s/" &
                        # getting 15 second video segments
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
                        # getting thumbnails
                        ffmpeg  -rtsp_transport tcp \
                                -i $q \
                                -an \
                                -map 0 \
                                -vf fps=1 \
                                -strftime 1 \
                                "/www/tempthumb/$s/$s-%Y-%m-%d_%H-%M-%S.jpg" \
                                >/dev/null 2>&1 &
                        # copying pics with differences
                        /sbin/compare.sh $s &

                else
                        echo "$s is not defined."
                fi
        fi
done

