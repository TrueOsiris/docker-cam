#!/bin/bash
sleep 20
s=$1
v=`echo $2 | sed 's/\.[^.]*$//'`
vend=${v##*-}
vbase=${v%-*}
sourcedir="/www/tempvid/$s/"
targetdir="/www/$s/vids/"
case 1 in
        $((0<=$vend && $vend<15)))mend=0;;
        $((15<=$vend && $vend<30)))mend=15;;
        $((30<=$vend && $vend<45)))mend=30;;
        $((45<=$vend && $vend<=59)))mend=45;;
esac
#echo "vbase: $vbase - vend: $vend - mend: $mend"
for (( i=$mend; i<$((mend+15)); i++ ))
do
        t="$i";
        if [ ${#t} == 1 ]; then
                t="0$i";
        fi
        moviefile="$vbase-$t.mp4"
        #echo $moviefile
        if [ -f "$sourcedir$moviefile" ]; then
                if [ ! -f "$targetdir$moviefile" ]; then
                        cp "$sourcedir$moviefile" "$targetdir$moviefile" 2>&1
                        echo "copying $sourcedir$moviefile to $targetdir ..."
                fi
        fi
done
