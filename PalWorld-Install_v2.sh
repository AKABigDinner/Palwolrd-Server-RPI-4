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
sudo mkdir build
cd ~/box86/build
sudo cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
sudo make -j$(nproc)
sudo make install
sudo systemctl restart systemd-binfmt
cd ~
sudo git clone https://github.com/ptitSeb/box64.git
cd ~/box64
sudo mkdir build
cd ~/box64/build
sudo cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo			   
sudo make -j$(nproc)
sudo make install
sudo systemctl restart systemd-binfmt
sudo useradd palworld -m
cd ~
sudo mkdir /home/palworld/steamcmd
sudo cd /home/palworld/steamcmd
cd /home/palworld/steamcmd && sudo curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
sudo /home/palworld/steamcmd/./steamcmd.sh & pid=$!
sleep 5m
kill -TSTP $pid
sudo /home/palworld/steamcmd./steamcmd.sh +force_install_dir /home/palworld/steamworkssdk +@sSteamCmdForcePlatformType linux +login anonymous +app_update 1007 validate +quit
cd /home/palworld/ && sudo mkdir -p .steam/sdk64
sudo cp /home/palworld/steamworkssdk/linux64/steamclient.so /home/palworld/.steam/sdk64/
sudo /home/palworld/./steamcmd.sh +force_install_dir /home/palworld/palworldserver +@sSteamCmdForcePlatformType linux +login anonymous +app_update 2394010 validate +quit
cd /home/palworld/palworldserver/
sudo /home/palworld/palworldserver/./PalServer.sh & pid=$!
sleep 5m
kill -TSTP $pid
sudo cp /home/palworld/palworldserver/DefaultPalWorldSettings.ini /home/palworld/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

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
#sudo chmod 644 /etc/systemd/system/palworld.service
sudo cd
#sudo systemctl daemon-reload
sudo systemctl enable palworld
sudo systemctl start palworld
sleep 30
sudo reboot now -h