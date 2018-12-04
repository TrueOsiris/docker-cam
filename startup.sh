#!/bin/bash
fuzglobal_default=15
mkdir "/www/tempvid" 2>/dev/null
chmod -R 777 /www/tempvid 2>/dev/null
mkdir "/www/tempthumb" 2>/dev/null
chmod -R 777 www/tempthumb 2>/dev/null
if [ ! -f /www/index.php ]; then
        cp index.php /www/ 2>&1
fi
fuzglobal_varname="FUZZ_GLOBAL"
fuzglobal=${!fuzglobal_varname}
if [ -z ${fuzglobal} ]; then
        echo "$fuzglobal_varname is unset. Setting to default of $fuzglobal_default"
        fuzglobal=$fuzglobal_default
else
        echo "$fuzglobal_varname is set. Setting to $fuzglobal"
fi
> /www/vars.txt 2>&1
for y in {1..12}
do
        s="stream$y";
        q=${!s};
        fuz=$fuzglobal
        if [ -z ${q+x} ]; then
                echo "$s is unset";
        else
                if [ -n "$q" ]; then
                        echo "$s: $q";
                        echo "$s: $q" >> /www/vars.txt;
                        echo "checking directories and rights for $s ..."
                        mkdir "/www/$s" 2>/dev/null;
                        mkdir "/www/$s/pics" 2>/dev/null;
                        mkdir "/www/$s/vids" 2>/dev/null;
                        chmod -R 777 /www/$s 2>/dev/null;
                        mkdir "/www/tempvid/$s" 2>/dev/null;
                        chmod -R 777 /www/tempvid/$s 2>/dev/null;
                        mkdir "/www/tempthumb/$s" 2>/dev/null;
                        mkdir "/www/tempthumb/$s/bw" 2>/dev/null;
                        chmod -R 777 /www/tempthumb/$s 2>/dev/null;
                        echo "stopping ffmpeg environments and scripts for $s ..."
                        ps -auxw | grep -e [f]fmpeg | grep $s | grep mp4 | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [f]fmpeg | grep $s | grep jpg | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [c]lean_ | grep vid | grep $s | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [c]lean_ | grep thumb | grep bw | grep $s | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [c]lean_ | grep thumb | grep $s | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [c]ompare | grep $s | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep -e [t]imelapse | awk '{print $2}' | xargs kill 2>/dev/null;
                        ps -auxw | grep sleep | awk '{print $2}' | xargs kill 2>/dev/null;
                        echo "starting everything for $s in 3 seconds ..."
                        sleep 3
                        # cleaning up extra temp videos and thumbs
                        /sbin/clean_tempvid.sh "/www/tempvid/$s/" &
                        /sbin/clean_tempvid.sh "/www/tempthumb/$s/" &
                        /sbin/clean_tempvid.sh "/www/tempthumb/$s/bw/" &
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
                                "/www/tempvid/$s/$s-%Y-%m-%d__%H-%M-%S.mp4" \
                                >/dev/null 2>&1 &
                        # getting a pic per second
                        ffmpeg  -rtsp_transport tcp \
                                -i $q \
                                -an \
                                -map 0 \
                                -vf fps=1 \
                                -strftime 1 \
                                "/www/tempthumb/$s/$s-%Y-%m-%d__%H-%M-%S.jpg" \
                                >/dev/null 2>&1 &
                        # getting black and white thumbnails
                        ffmpeg  -rtsp_transport tcp \
                                -i $q \
                                -an \
                                -map 0 \
                                -vf fps=1,format=gray,format=yuv422p,scale="512:-1" \
                                -strftime 1 \
                                "/www/tempthumb/$s/bw/$s-%Y-%m-%d__%H-%M-%S.jpg" \
                                >/dev/null 2>&1 &
                        # copying pics with differences
                        /sbin/compare.sh $s "$fuz" "pics" &
                        #/sbin/compare.sh $s 8 "pics/fuz8" &
                fi
        fi
done
/sbin/timelapse.sh &
