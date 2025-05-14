# Notes for building Qt 6 in Ubuntu 18.04 docker container

docker run -it ubuntu:18.04 bash

apt update && apt install -y sudo

# Get a newer version of cmake
apt install -y gpg wget software-properties-common lsb-release ca-certificates
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ bionic main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
apt-get update
rm /usr/share/keyrings/kitware-archive-keyring.gpg
apt-get install kitware-archive-keyring
apt install -y cmake


# Qt 6 needs at least GCC 9.2
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get update
apt install gcc-9 g++-9

# Setup default compiler
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 30
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 30

update-alternatives --config gcc
update-alternatives --config g++

# Install some dependencies 
apt install git patchelf

# Install qt dependencies
apt install \
    libfontconfig1-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxcb-cursor-dev \
    libxcb-glx0-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-shape0-dev \
    libxcb-shm0-dev \
    libxcb-sync-dev \
    libxcb-util-dev \
    libxcb-xfixes0-dev \
    libxcb-xkb-dev \
    libxcb1-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxrender-dev \
    libgl1-mesa-dev \
    libssl-dev

# Clone repo and build
cd
git clone https://github.com/smistad/FAST-dependencies/
cd FAST-dependencies
mkdir build
cd build
cmake ..
make -j8 qt6
