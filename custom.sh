#!/bin/bash

#Documented for whenever i need to build a custom php with custom curl and openssl

# Cache sudo password
sudo -v

# Install build dependencies
sudo apt -y install build-essential
sudo apt -y install libcurl4-openssl-dev

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
tar -xvf curl-$curl_version.tar.gz
cd curl-$curl_version
env PKG_CONFIG_PATH=/home/$usr/build/lib/pkgconfig ./configure --with-ssl --prefix=/home/$usr/build
make -j$(nproc)
make -i install

#verify you have built the correct curl
cd ~/build/bin
./curl -V
#curl 7.24.0 (x86_64-unknown-linux-gnu) libcurl/7.24.0 OpenSSL/1.0.0u zlib/1.2.11

#completed own curl and openssl now we can start building our php
cd ~
wget https://www.php.net/distributions/$php_version.tar.gz
tar -xvf php-$php_version.tar.gz
./configure --prefix=/opt/$php_version --with-config-file-path=/opt/$php_version/etc --with-curl=/home/$usr/build --with-openssl-dir=/home/$usr/build --with-pdo-mysql --with-libdir=lib64
#added next line on the configure to present the command better
#./configure \
#> --prefix=/opt/$php_version \
#> --with-config-file-path=/opt/$php_version/etc \
#> --with-curl=/home/$usr/build \
#> --with-openssl-dir=/home/$usr/build \
#> --with-openssl=shared \
#> --with-pdo-mysql \
#> --with-fpm-user=apache \
#Optional if u will use fpm as well
#> --with-fpm-group=apache \
#Optional if u will use fpm as well
#> --with-libdir=lib64 \ 
#Use if on 64 bit OS. Include softlink to lib directory
#check php manual to see additional configurations
make clean
make -j$(nproc) -B
make -i install

#check if your custom php is working with you custom curl and openssl
php -a
var_dump(curl_version());
#should print ur custom curl version with your openssl
exit


