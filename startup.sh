#!/bin/bash
for y in {1..10}
do
        s="stream$y";
        q=${!s};
        if [ -z ${q+x} ]; then
                echo "$s is unset";
        else
                if [ -n "$q" ]; then
                        echo "$s: $q";
                fi
        fi
done
