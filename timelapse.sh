#!/bin/bash
while :
  do
    for yy in {1..12}
      do
        ss="stream$yy";
        if [ -d "/www/$ss" ]; then
          basedir="/www/$ss/pics"
          today=$(date "+%Y-%m-%d")
          find $basedir -type f -size 0 -delete
          t=`ls -d $basedir/20*/ | awk -F/ '{print$5}'`
          arr=($t)
          for i in "${arr[@]}"
          do
            if [ $i == $today ]; then
              ffmpeg -y -framerate 24 -pattern_type glob -i "$basedir/$i/*.jpg" -c:v libx264 -pix_fmt yuv420p \
                "$basedir/${i}_temp_timelapse_in_progress.mp4" >/dev/null 2>&1
              mv "$basedir/${i}_temp_timelapse_in_progress.mp4" "$basedir/${i}_temp_timelapse.mp4" 2>&1
            else
              file="$basedir/${i}_timelapse.mp4"
              if [[ ! -f "$file" ]]; then
                ffmpeg -framerate 24 -pattern_type glob -i "$basedir/$i/*.jpg" -c:v libx264 -pix_fmt yuv420p \
                  "$basedir/${i}_timelapse.mp4" >/dev/null 2>&1
                rm "$basedir/${i}_temp_timelapse.mp4" 2>&1
              fi
            fi
          done
        fi
    done
    sleep 1800
done
