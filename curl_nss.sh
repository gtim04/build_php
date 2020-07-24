#!/bin/bash

#rebuilding curl with NSS

#Install build dependencies ubuntu

sudo apt -y install libnss3*
sudo apt -y install libnsspem
sudo apt -y install build-essential

#start process
cd ~
mkdir -p ./build
wget https://curl.haxx.se/download/curl-$curl_version.tar.gz
tar -xvf curl-$curl_version.tar.gz
cd curl-$curl_version

#build process
./buildconf
./configure --prefix=/home/$usr/build --without-ssl --with-nss
make -j$(nproc)
make -i install

#verify you have built the correct curl
cd ~/build/bin
./curl -V
