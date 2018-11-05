#!/bin/bash

ffmpeg  -rtsp_transport tcp \
        -i $1 \
        -vcodec copy \
        -an \
        -map 0 \
        -f segment \
        -segment_time 15 \
        -segment_format mp4 \
        -strftime 1 \
        "/www/$2-%Y-%m-%d_%H-%M-%S.mp4"
        >/dev/null 2>&1 &
