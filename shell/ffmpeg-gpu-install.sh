wget -O /tmp/cuda.deb https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
dpkg -i /tmp/cuda.deb
apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub
mkdir /usr/lib/nvidia
apt update
apt install -y linux-source linux-headers-$(uname -r)
apt install -y cuda

apt-get -y install autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev libvpx-dev libvpx3 nasm

mkdir -p ~/ffmpeg_sources ~/bin

cd ~/ffmpeg_sources && \
        wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 && \
        tar xjvf nasm-2.14.02.tar.bz2 && \
        cd nasm-2.14.02 && \
        ./autogen.sh && \
        PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
        make -j$(nproc) && \
        make -j$(nproc) install

cd ~/ffmpeg_sources && \
        wget -O yasm-1.3.0.tar.gz https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
        tar xzvf yasm-1.3.0.tar.gz && \
        cd yasm-1.3.0 && \
        ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
        make -j$(nproc) && \
        make -j$(nproc)

cd ~/ffmpeg_sources && \
        git -C x264 pull 2> /dev/null || git clone --depth 1 https://git.videolan.org/git/x264 && \
        cd x264 && \
        PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic && \
        PATH="$HOME/bin:$PATH" make -j$(nproc) && \
        make -j$(nproc) install

sudo apt-get install -y mercurial libnuma-dev && \
        cd ~/ffmpeg_sources && \
        wget 103.242.67.12/x265.tar.gz;tar xzvf x265.tar.gz;if cd x265 2> /dev/null; then hg pull && hg update; else hg clone https://bitbucket.org/multicoreware/x265; fi && \
                cd build/linux && \
                PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source && \
                PATH="$HOME/bin:$PATH" make -j$(nproc) && \
                make -j$(nproc) install

cd ~/ffmpeg_sources && \
        git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
        cd libvpx && \
        PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
        PATH="$HOME/bin:$PATH" make -j$(nproc) && \
        make -j$(nproc) install

cd ~/ffmpeg_sources && \
        git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
        cd fdk-aac && \
        autoreconf -fiv && \
        ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
        make -j$(nproc) && \
        make -j$(nproc) install

cd ~/ffmpeg_sources && \
        wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
        tar xzvf lame-3.100.tar.gz && \
        cd lame-3.100 && \
        PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm && \
        PATH="$HOME/bin:$PATH" make -j$(nproc) && \
        make -j$(nproc) install

cd ~/ffmpeg_sources && \
        git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
        cd opus && \
        ./autogen.sh && \
        ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
        make -j$(nproc) && \
        make -j$(nproc) install

cd ~/ffmpeg_sources && \
        git clone https://github.com/FFmpeg/nv-codec-headers.git -b sdk/8.0 && \
        cd nv-codec-headers && \
        make PREFIX="$HOME/ffmpeg_build" BINDDIR="$HOME/bin" && \
        make install PREFIX="$HOME/ffmpeg_build" BINDDIR="$HOME/bin" && \

cd ~/ffmpeg_sources && \
git clone https://github.com/FFmpeg/FFmpeg -b master &&
cd FFmpeg &&
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include -I/usr/local/cuda/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib -L/usr/local/cuda/lib64" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="$HOME/bin" \
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
  --enable-libnpp && \

make -j$(nproc) && \
make -j$(nproc) install && \
hash -r
ln -s /root/bin/ffmpeg /bin/ffmpeg
