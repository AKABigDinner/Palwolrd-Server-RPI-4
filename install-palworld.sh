#!/bin/bash

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install necessary packages
sudo apt install curl git build-essential cmake -y

# Clone and install box86 if not already installed
if [ ! -d "$HOME/box86" ]; then
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
    # Reboot only if necessary
    sudo reboot
fi

# Clone and install box64 if not already installed
if [ ! -d "$HOME/box64" ]; then
    sudo apt update
    sudo apt upgrade -y
    git clone https://github.com/ptitSeb/box64.git
    cd ~/box64
    mkdir build
    cd build
    cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
    make -j$(nproc)
    sudo make install
    sudo systemctl restart systemd-binfmt
    # Reboot only if necessary
    sudo reboot
fi

# Create a new user for palworld if not already created
if ! id "palworld" &>/dev/null; then
    sudo useradd palworld -m
    sudo -u palworld -s << 'EOF'
    mkdir ~/steamcmd
    cd ~/steamcmd
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
    
    # Run SteamCMD with commands
    ./steamcmd.sh +force_install_dir ~/steamworkssdk +@sSteamCmdForcePlatformType linux +login anonymous +app_update 1007 validate +quit
    
    mkdir -p ~/.steam/sdk64
    cp ~/steamworkssdk/linux64/steamclient.so ~/.steam/sdk64/
    
    # Install Palworld server
    ./steamcmd.sh +force_install_dir ~/palworldserver +@sSteamCmdForcePlatformType linux +login anonymous +app_update 2394010 validate +quit
    
    cd ~/palworldserver/
    
    # Start the PalServer
    ./PalServer.sh
    
    # Copy settings file
    cp ~/palworldserver/DefaultPalWorldSettings.ini ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    exit
EOF
fi

# Create systemd service for palworld if not already created
if [ ! -f "/etc/systemd/system/palworld.service" ]; then
    sudo bash -c 'cat << EOF > /etc/systemd/system/palworld.service
[Unit]
Description=Palworld Server
Wants=network-online.target
After=network-online.target

[Service]
User =palworld
Group=palworld
WorkingDirectory=/home/palworld/
ExecStartPre=/home/palworld/steamcmd/steamcmd.sh +force_install_dir "/home/palworld/palworldserver" +login anonymous +app_update 2394010 +quit
ExecStart=/home/palworld/palworldserver/PalServer.sh -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS > /dev/null
Restart=always

[Install]
WantedBy=multi-user.target
EOF'
fi
