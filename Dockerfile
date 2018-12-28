ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=qnib
ARG FROM_IMG_NAME=uplain-cuda-dev
ARG FROM_IMG_TAG=bionic.9-2
ARG FROM_IMG_HASH=""

FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get update \
 && apt-get install --no-install-recommends -y git yasm \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/src
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git \
 && cd nv-codec-headers \
 && make \
 && make install \
 && cd .. \
 && rm -rf nv-codec-headers
RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
RUN cd ffmpeg \
 && ./configure --enable-cuda --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp \
                --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 \
 && make -j10 \
 && make install \
 && cd .. \
 && rm -rf ffmpeg
RUN echo "wget -O honey-bees.mp4  \"http://downloads.4ksamples.com/downloads/Honey%20Bees%2096fps%20In%204K%20(ULTRA%20HD)(4ksamples.com).mp4\"" >> /root/.bash_history \
 && echo "ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i honey-bees.mp4 -vf scale_npp=1920:1072 -vf scale_npp=1920:1080 -vcodec h264_nvenc honey-bees_1080.mp4" >> /root/.bash_history
