#!/bin/bash


## Base provisioning ##

# Apply updates
yum update -y

# Mount second disk
mkdir data
mkfs.ext4 /dev/sdb
mount /dev/sdb data

# Change dir to the new disk
cd data

## Build graphene ##

# Install dependencies
yum groupinstall -y "Development Tools"
yum install -y wget git cmake zlib-devel bzip2-devel openssl-devel clang autoconf libtool readline-devel doxygen

# Install ninja
git clone https://github.com/ninja-build/ninja.git && cd ninja
./configure.py --bootstrap

# Install Boost 1.57.0
cd ../
wget http://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.gz
tar -xvf boost_1_57_0.tar.gz && cd boost_1_57_0
./bootstrap.sh --prefix=/usr/
./b2 -j $(nproc)
./b2 -j $(nproc) install

# Build graphene
cd ../
git clone https://github.com/FollowMyVote/graphene.git && cd graphene
git checkout v2.15.306
git submodule update --init --recursive
cmake -- -j $(nproc) -DCURSES_LIBRARY=/usr/lib64/libcurses.so -DCURSES_INCLUDE_PATH=/usr/include/ -DCMAKE_BUILD_TYPE=Debug .
make -j $(nproc)


## Build graphene-ui ##

# Install node and npm
#cd ../
#curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
#nvm install v5
#nvm use v5
