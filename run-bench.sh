#!/bin/bash

cd /data/
if [  ! -f "honey-bees.mp4" ];then
   echo ">> Download sample 4k video"
   wget -O honey-bees.mp4  \"http://downloads.4ksamples.com/downloads/Honey%20Bees%2096fps%20In%204K%20(ULTRA%20HD)(4ksamples.com).mp4
fi
time ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i honey-bees.mp4 -vf scale_npp=1920:1080 -vcodec h264_nvenc honey-bees_1080.mp4
