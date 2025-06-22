# Palwolrd-Server-RPI-4
An automated script for creating a Palworld server on a Raspberry Pi 4.

## Note: This script is for Debian 12 aka Bookworm on a 64-BIT version.


From a fresh install of Debian 12 Bookworm boot RPI 4.

In the CLI type the following.

    sudo apt install git -y
###
    git clone https://github.com/AKABigDinner/Palwolrd-Server-RPI-4.git
Enter user and token:

Now that the install file is downloaded type the following.

    cd Palwolrd-Server-RPI-4
###
    sudo chmod +x Install1.sh Install2.sh
###
    ./Install1.sh
###
    ./Install2.sh

## Below is the path for the server setting:

    sudo nano ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    
    
## Manual Install


    sudo apt update
###
    sudo apt upgrade -y
###
    sudo apt install curl
###
    sudo apt update
###
    sudo apt upgrade
###
    sudo apt install git build-essential cmake -Y
###
    git clone https://github.com/ptitSeb/box86
###
    sudo dpkg --add-architecture armhf
###
    sudo apt update
###
    sudo apt install gcc-arm-linux-gnueabihf libc6:armhf
###
    cd ~/box86
###
    mkdir build
###
    cd build
###
    cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
###
    make -j$(nproc)
###
    sudo make install
###
    sudo systemctl restart systemd-binfmt
###
    sudo reboot
###
    sudo apt update
###
    sudo apt upgrade -y
###
    sudo apt install git build-essential cmake
###
    git clone https://github.com/ptitSeb/box64.git
###
    cd ~/box64
###
    mkdir build
###
    cd build
###
    cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
###
    make -j$(nproc)
###
    sudo make install
###
    sudo systemctl restart systemd-binfmt
###
    sudo reboot
###
    sudo useradd palworld -m
###
    sudo -u palworld -s
###
    mkdir ~/steamcmd
###
    cd ~/steamcmd
###
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
###
    ./steamcmd.sh
###
    quit
###
    ./steamcmd.sh +force_install_dir ~/steamworkssdk +@sSteamCmdForcePlatformType linux +login anonymous +app_update 1007 validate +quit
###
    mkdir -p ~/.steam/sdk64
###
    cp ~/steamworkssdk/linux64/steamclient.so ~/.steam/sdk64/
###
    ./steamcmd.sh +force_install_dir ~/palworldserver +@sSteamCmdForcePlatformType linux +login anonymous +app_update 2394010 validate +quit
###
    cd ~/palworldserver/
###
    ./PalServer.sh
###
    cp ~/palworldserver/DefaultPalWorldSettings.ini ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
###
    nano ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
###
    exit
###
    sudo nano /etc/systemd/system/palworld.service
###
    [Unit]
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
    WantedBy=multi-user.target
###
    sudo systemctl enable palworld
###
    sudo systemctl start palworld

    
