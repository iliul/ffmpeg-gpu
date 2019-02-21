# FFmpeg-GPU

[![Build Status](https://travis-ci.com/iliul/ffmpeg-gpu.svg?branch=master)](https://travis-ci.com/iliul/ffmpeg-gpu)

FFmpeg with NVIDIA P4 GPU Driver Support, 3rd library :

- libx264
- libx265
- libfdk_acc
- libmp3lame
- libops
- libogg
- libvorbis
- libvpx

## Install CUDA

Note: Use CUDA 9.2 with FFmpeg-n4.0, *Version 10.0 is incompatible.*

```
~# sudo wget -S https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu1604/x86_64/cuda-9-2_9.2.88-1_amd64.deb
~# sudo dpkg -i cuda-9-2_9.2.88-1_amd64.deb
~# sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
~# sudo apt-get update -y
~# sudo apt-get install cuda -y
```

## Compiling ffmpeg

```
~# PATH="/data/bin:$PATH" PKG_CONFIG_PATH="/data/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="/data/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I/data/ffmpeg_build/include -I/usr/local/cuda/include" \
  --extra-ldflags="-L/data/ffmpeg_build/lib -L/usr/local/cuda/lib64" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="/data/bin" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --enable-cuda \
  --enable-cuvid \
  --enable-nvenc \
  --enable-libnpp
```
