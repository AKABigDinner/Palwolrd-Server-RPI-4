#!/bin/bash
set -x
mkdir ~/steamcmd && cd ~/steamcmd
sleep 5
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
./steamcmd.sh & pid=$!
sleep 5m
kill -TSTP $pid
#./steamcmd.sh +force_install_dir ~/steamworkssdk +@sSteamCmdForcePlatformType linux +login anonymous +app_update 1007 validate +quit
./steamcmd.sh +force_install_dir ~/steamworkssdk +@sSteamCmdForcePlatformType linux +@sSteamCmdForcePlatformBitness 64 +login anonymous +app_update 1007 validate +quit
mkdir -p ~/.steam/sdk64 && cp ~/steamworkssdk/linux64/steamclient.so ~/.steam/sdk64/
#./steamcmd.sh +force_install_dir ~/palworldserver +@sSteamCmdForcePlatformType linux +login anonymous +app_update 2394010 validate +quit
./steamcmd.sh +force_install_dir ~/palworldserver +@sSteamCmdForcePlatformType linux +@sSteamCmdForcePlatformBitness 64 +login anonymous +app_update 2394010 validate +quit

cd ~/palworldserver/
./PalServer.sh & pid=$!
sleep 5m
kill -TSTP $pid
sleep 5
cp ~/palworldserver/DefaultPalWorldSettings.ini ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
sleep 5

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

