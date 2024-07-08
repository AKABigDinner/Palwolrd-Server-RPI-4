#!/bin/bash
set -x
sudo apt update
sudo apt install curl
sudo apt update
sudo apt upgrade -y
sudo apt install git build-essential cmake -y
git clone https://github.com/ptitSeb/box86
sudo dpkg --add-architecture armhf
sudo apt update
sudo apt install gcc-arm-linux-gnueabihf libc6:armhf -y
cd ~/box86
mkdir build
cd build
cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)
sudo make install
sudo systemctl restart systemd-binfmt
cd ~
sudo apt update && apt upgrade -y
sudo apt install git build-essential cmake
git clone https://github.com/ptitSeb/box64.git
cd ~/box64
mkdir build
cd build
cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
echo "##########box64 install#############"
read -p "Press Enter to continue..."
make -j$(nproc)
sudo make install
sudo systemctl restart systemd-binfmt
sudo useradd palworld -m
sudo -u palworld -s
echo "##########check at this point##########"
read -p "Press Enter to continue..."
sudo -u palworld mkdir ~/steamcmd
cd ~/steamcmd

curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
quit
./steamcmd.sh +force_install_dir ~/steamworkssdk +@sSteamCmdForcePlatformType linux +login anonymous +app_update 1007 validate +quit
mkdir -p ~/.steam/sdk64
cp ~/steamworkssdk/linux64/steamclient.so ~/.steam/sdk64/
./steamcmd.sh +force_install_dir ~/palworldserver +@sSteamCmdForcePlatformType linux +login anonymous +app_update 2394010 validate +quit

cd ~/palworldserver/
./PalServer.sh
kill $PID
cp ~/palworldserver/DefaultPalWorldSettings.ini ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
exit
echo "[Unit]
Description=Palworld Server
Wants=network-online.target
After=network-online.target

[Service]
User=palworld
Group=palworld
WorkingDirectory=/home/palworld/
ExecStartPre=/home/palworld/steamcmd/steamcmd.sh +force_install_dir '/home/palworld/palworldserver' +login anonymous +app_update 2394010 +quit
ExecStart=/home/palworld/palworldserver/PalServer.sh -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS > /dev/null
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/palworld.service
sudo systemctl enable palworld
sudo systemctl start palworld