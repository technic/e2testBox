#!/bin/bash

set -ex
whoami

sudo apt-get install -y \
  build-essential autoconf autotools-dev libtool libtool-bin checkinstall \
  swig python-dev python-twisted python-nose python-mock \
  libz-dev libssl-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0 \
  libfreetype6-dev libsigc++-1.2-dev  libfribidi-dev \
  libavahi-client-dev libjpeg-dev libgif-dev libsdl2-dev

mkdir -p src
cd src

if test -d libdvbsi++; then
  cd libdvbsi++
  git pull
else
  git clone git://git.opendreambox.org/git/obi/libdvbsi++.git
  cd libdvbsi++
fi
./autogen.sh
./configure
make
sudo checkinstall -y --pkgversion=0.3.8
cd -

if test -d tuxtxt; then
  cd tuxtxt
  git pull
else
  git clone git://github.com/OpenPLi/tuxtxt.git
  cd tuxtxt
fi

cd libtuxtxt
autoreconf -i
CPP="gcc -E -P" ./configure --with-boxtype=generic
make
sudo checkinstall -y --pkgversion=1.0 --exclude=/usr/lib
cd -

cd tuxtxt
autoreconf -i
CPP="gcc -E -P" ./configure --with-boxtype=generic
make
sudo checkinstall -y --pkgversion=1.0
cd -

cd ~/src

sudo mkdir -p /opt/disk
sudo chown $USER:$USER /opt/disk

if test -d enigma2; then
  cd enigma2
  git pull
else
  git clone https://github.com/technic/enigma2.git
  cd enigma2
fi
./autogen.sh
./configure --with-libsdl --with-gstversion=1.0 \
  --prefix=/opt/disk/usr --sysconfdir=/opt/disk/etc
make
make install
cd -

sudo ldconfig
mkdir -p /opt/disk/etc
cp /usr/local/share/fonts/tuxtxt.ttf /opt/disk/usr/share/fonts

