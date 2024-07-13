#!/bin/bash
set -x
cd ~
sudo apt update
sudo apt install curl -y
sudo apt update
sudo apt upgrade -y
sudo apt install git build-essential cmake -y
sudo git clone https://github.com/ptitSeb/box86
sudo dpkg --add-architecture armhf
sudo apt update
sudo apt install gcc-arm-linux-gnueabihf libc6:armhf -y
cd ~/box86
sudo mkdir build && cd build
sudo cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
sudo make -j$(nproc)
sudo make install
sudo systemctl restart systemd-binfmt
cd ~
sudo git clone https://github.com/ptitSeb/box64.git
cd ~/box64
sudo mkdir build && cd build
sudo cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo			   
sudo make -j$(nproc)
sudo make install
sudo systemctl restart systemd-binfmt
sudo useradd palworld -m
cd ~
sudo mv /home/pi/Palwolrd-Server-RPI-4/install2.sh /home/palworld/
