#!/bin/bash
[ $# -eq 0 ] && echo "#'basename $0' file1 [file 2 file#]"

for input in $@
do
    output=$(echo $input | sed -e 's/\..*$//g')
    echo "Converting $input to $output...."
    ffmpeg -i "$input" -c:v prores -profile:v 3 -c:a pcm_s16le "$output.mov"
done

