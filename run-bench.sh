#!/bin/bash
: ${FFMPEG_DECODER:=h264}
: ${FFMPEG_ENCODER:=h264}

function wgetdown() {
  URL="https://docs.google.com/uc?export=download&id=$1"
  wget -q --load-cookies /tmp/cookies.txt \
       "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate $URL -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$1" -O $2
  rm -rf /tmp/cookies.txt
}

if [[ -L /usr/local/cuda ]];then
  echo ">> CUDA:"
  ls -l /usr/local/cuda
else 
  echo ">> No CUDA found in /usr/local"
fi


echo ">> Use FFMPEG_ENCODER:${FFMPEG_ENCODER} / FFMPEG_DECODER:${FFMPEG_DECODER}"
cd /data/
case $1 in
  "bee")
    if [  ! -f "honey-bees.mp4" ];then
       echo ">> Download sample 4k mp4 video"
       wget -qO honey-bees.mp4 "http://downloads.4ksamples.com/downloads/Honey%20Bees%2096fps%20In%204K%20(ULTRA%20HD)(4ksamples.com).mp4"
    fi
    set -x
    time ffmpeg -y -c:v ${FFMPEG_DECODER} -vsync 0 -i honey-bees.mp4 -strict -2 -vcodec ${FFMPEG_ENCODER} honey-bees_out.mp4 ;;
  "pet")
    if [  ! -f "my-pet-4k.ts" ];then
      echo ">> Download sample 4k ts video"
      wgetdown 0Bxj6TUyM3NwjWnNqSnNoSElndDg down.zip
      unzip down.zip
      mv Samsung\ Travel\ With\ My\ Pet\ HDR\ UHD\ 4K\ Demo.ts my-pet-4k.ts
      rm -rf down.zip
    fi
    time ffmpeg -y -c:v ${FFMPEG_DECODER} -vsync 0 -i my-pet-4k.mp4 -strict -2 -vcodec ${FFMPEG_ENCODER} my-pet-4k_out.mp4 ;;
  "world")
    if [  ! -f "my-pet-4k.ts" ];then
      echo ">> Download sample 4k ts video"
      wgetdown 0Bxj6TUyM3NwjbnlOODYtcTNDbWM world.zip
      unzip world.zip
      mv Samsung\ 7\ Wonders\ Of\ The\ World\ 4K\ Demo.ts 7-world-wonders_4k.ts
    fi
    time ffmpeg -y -c:v ${FFMPEG_DECODER} -vsync 0 -i 7-world-wonders_4k.ts -strict -2 -vcodec ${FFMPEG_ENCODER} 7-world-wonders_out.mp4 ;;
   *) echo "Please choose from 'pet', 'world' or 'bee'" ;;
esac
