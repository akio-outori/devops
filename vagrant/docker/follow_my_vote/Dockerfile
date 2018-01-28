# Builds the follow my vote toolchain in the latest ubuntu environment
FROM ubuntu

LABEL "maintainer"  = "Jeff Hallyburton"
LABEL "version"     = "0.1"
LABEL "name"        = "witness_node"
LABEL "description" = "Graphene witness node for setting up blockchains"

# System Update
RUN apt-get update -y
RUN apt-get upgrade -y
# RUN apt-get do-release-upgrade

# Install dependencies
RUN apt-get install -y wget git cmake zlib1g-dev libbz2-dev clang npm ninja autoconf libtool libreadline-dev doxygen
RUN apt-get install -y build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev libncurses5-dev

# Download boost 1.57.0
RUN wget http://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.gz
RUN tar -xvf boost_1_57_0.tar.gz

# Build boost
WORKDIR /boost_1_57_0/
RUN ./bootstrap.sh --prefix=/usr/
RUN ./b2 -j $(nproc)
RUN ./b2 -j $(nproc) install

# Pull down sources for graphene
WORKDIR /
RUN git clone https://github.com/FollowMyVote/graphene.git

# Build graphene
WORKDIR /graphene
RUN git checkout v2.15.306
RUN git submodule update --init --recursive

# Build graphene
RUN cmake -- -j $(nproc) -DCURSES_LIBRARY=/usr/lib/x86_64-linux-gnu/libncurses.so -DCURSES_INCLUDE_PATH=/usr/include/ -DCMAKE_BUILD_TYPE=Debug .
RUN make -j $(nproc)
#./programs/witness_node/witness_node

#git clone https://github.com/akio-outori/graphene-ui

# Fix sources that don't pull correctly
#cd graphene/libraries
#rm -rf fc
#git clone https://github.com/FollowMyVote/fc.git --recursive

# install js dependencies for ui
#cd ~/graphene-ui/dl
#npm install minimatch
#npm install glob
#npm install coffeescript
#npm install coffee-script
#npm install

#cd web/ && npm install && cd ..

# Build graphene
#cd ~/graphene/
#cmake -G Ninja -DCMAKE_CXX__COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/opt/graphene
#ninja
