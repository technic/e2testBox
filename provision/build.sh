#!/bin/bash

set -ex
whoami

sudo apt-get install -y \
  build-essential autoconf autotools-dev libtool libtool-bin checkinstall unzip \
  swig python-dev python-twisted python-nose python-mock \
  libz-dev libssl-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
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


sudo apt-get install -y libarchive-dev  libcurl4-openssl-dev libgpgme11-dev

opkgVer="0.3.5"
opkgDir="opkg-$opkgVer"
if ! test -d "$opkgDir"; then
    wget "http://git.yoctoproject.org/cgit/cgit.cgi/opkg/snapshot/opkg-$opkgVer.tar.gz"
    tar -xzf "$opkgDir".tar.gz
fi
cd "$opkgDir"
./autogen.sh
./configure --enable-curl --enable-ssl-curl --enable-gpg
make
sudo checkinstall -y --pkgversion=$opkgVer
cd -

sudo install -D -m 644 /vagrant/provision/opkg.conf /usr/local/etc/opkg/opkg.conf
sudo mkdir -p /opt/testdisk
sudo chown $USER:$USER /opt/testdisk

cd ~/src
mkdir -p fakepkg
mkdir -p fakepkg/DEBIAN

cat > "fakepkg/DEBIAN/control" <<EOF
Package: enigma2
Version: 1.0
Depends:
Description: enigma2 fake package
Section: extra
Priority: optional
Maintainer: unknown
License: unknown
Architecture: all
EOF

dpkg-deb -b fakepkg enigma2.deb
# install enigma2 fake package to make dependent packages happy
opkg install enigma2.deb
cd -


if ! test -d skin-PLiHD-master; then
    wget https://github.com/littlesat/skin-PLiHD/archive/master.zip -O skin-PLiHD-master.zip
    unzip skin-PLiHD-master.zip
fi
cp -a skin-PLiHD-master/usr/share/enigma2/PLi-HD /opt/disk/usr/share/enigma2
cp -a skin-PLiHD-master/usr/share/enigma2/PLi-FullHD /opt/disk/usr/share/enigma2


sudo ldconfig
mkdir -p /opt/disk/etc
cp /usr/local/share/fonts/tuxtxt.ttf /opt/disk/usr/share/fonts

