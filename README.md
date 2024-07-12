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
    sudo chmod +x PalWorld-Install.sh
###
    ./PalWorld-Install_v2.sh

### Below is the path for the server setting:

    sudo nano ~/palworldserver/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
