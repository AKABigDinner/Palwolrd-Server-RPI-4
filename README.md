# Palwolrd-Server-RPI-4
An automated script for creating a Palworld server on a Raspberry Pi 4.

## Note: This script is for Debian 12 aka Bookworm on a 64-BIT version.


From a fresh install of Debian 12 Bookworm boot RPI 4.

In the CLI type the following.

    sudo apt install git -y
###
    curl -O https://raw.githubusercontent.com/AKABigDinner/Palwolrd-Server-RPI-4/main/install-palworld.sh
Now that the install file is downloaded type the following.
###
    sudo chmod +x install-palworld.sh
    
###
NOTE: When running this command you will need to run it 3 times.
The first will load x86 box. Then it will automatically reboot.
Next you will run it again for the second time. it will load x64 box.
Then it will automatically reboot. Finally run it one more time to install 
STEAMCND along with the palworld server data.

    ./install-palworld.sh
### This will set the auto startup for the service to be enabled.

    sudo systemctl enable palworld
### This will start the service for the server
    sudo systemctl start palworld
### Any time you want to ssh in to the rpi you can run this to see the server logs.
    journalctl -u palworld.service -f
##

## Below is the path for the server setting:

    sudo nano ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    
##
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
    sudo apt install git build-essential cmake -y
### Installing box86
    git clone https://github.com/ptitSeb/box86
###
    sudo dpkg --add-architecture armhf
###
    sudo apt update
###
    sudo apt install gcc-arm-linux-gnueabihf libc6:armhf -y
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
### Installing box64
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
### Create a user and directory
    sudo useradd palworld -m
### Switches to the new user with it's corresponding shell
    sudo -u palworld -s
###
    mkdir ~/steamcmd
###
    cd ~/steamcmd
### downloads and extracts steamcdn "steamcli"
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
### starts and updates steam
    ./steamcmd.sh
### While in the steam cli and after its update enter quit to exit.
    quit
### Installs steamworkssdk and exits 
    ./steamcmd.sh +force_install_dir ~/steamworkssdk +@sSteamCmdForcePlatformType linux +login anonymous +app_update 1007 validate +quit
###
    mkdir -p ~/.steam/sdk64
###
    cp ~/steamworkssdk/linux64/steamclient.so ~/.steam/sdk64/
### Installs palworldserver and exits
    ./steamcmd.sh +force_install_dir ~/palworldserver +@sSteamCmdForcePlatformType linux +login anonymous +app_update 2394010 validate +quit
###
    cd ~/palworldserver/
###
    ./PalServer.sh
### 
    cp ~/palworldserver/DefaultPalWorldSettings.ini ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
###
    nano ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
### exits the palworld user
    exit
###
    sudo nano /etc/systemd/system/palworld.service
### paste into the palworld.service file
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
### This will set the auto startup for the service to be enabled.
    sudo systemctl enable palworld
### This will start the service for the server
    sudo systemctl start palworld
## Any time you want to ssh in to the rpi you can run this to see the server logs.
###
    journalctl -u palworld.service -f

    
