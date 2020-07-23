#!/bin/bash

#Documented for whenever i need to build a custom php with custom curl and openssl

# Cache sudo password
sudo -v

# Install build dependencies
sudo apt -y install build-essential

#Create src and build folder in your home directory
cd ~
mkdir -p ./build
mkdir -p ./src

#Go to the src directory get both curl and openssl
cd src
wget https://openssl.org/source/openssl-$openssl_version.tar.gz
wget https://curl.haxx.se/download/curl-$curl_version.tar.gz

#Build openssl on our build folder
tar -xvf openssl-$openssl_version.tar.gz
cd openssl-$openssl_version

#optional clean build
make clean
make dclean

#config optional depends on what you need see openssl build documentation
./config --prefix=/home/$usr/build enable-ssl3 enable-ssl3-method no-shared
make -j$(nproc)
make -i install

#verify you have built the correct openssl
cd ~/build/bin
./openssl version 
#OpenSSL 1.0.0u-dev xx XXX xxxx

#Build curl on our build folder
cd ~/src
env PKG_CONFIG_PATH=/home/$usr/build/lib/pkgconfig ./configure --with-ssl --prefix=/home/$usr/build

