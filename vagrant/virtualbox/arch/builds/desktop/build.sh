#!/bin/bash

# Configure repositories for ZFS
ZFS=$(cat << ZFS

[archzfs]
Server = http://archzfs.com/$repo/$arch
ZFS
)

if ! grep -q zfs /etc/pacman.conf; then
    echo '' >> /etc/pacman.conf
    echo '[archzfs]'  >> /etc/pacman.conf
    echo 'Server = http://archzfs.com/$repo/$arch' >> /etc/pacman.conf
fi

# Import keys for ZFS
pacman-key -r F75D9D76
pacman-key --lsign-key F75D9D76

# Update and install ZFS
pacman -Sy --noconfirm
pacman -S zfs-dkms --noconfirm

# Change to home dir
cd ~/

# Copy blacklist to the iso
mkdir -p ~/archiso/airootfs/etc/modprobe.d
#cat << BLACKLIST > ~/archiso/airootfs/etc/modprobe.d/broadcom-wl.conf
# wireless drivers (conflict with Broadcom hybrid wireless driver 'wl')
#blacklist ssb
#blacklist bcma
#blacklist b43
#blacklist brcmsmac
#BLACKLIST

# Add packages to build
cat << PACKAGES > ~/archiso/packages.x86_64
base
base-devel
awk
linux-headers
linux-firmware
xf86-input-synaptics
dialog
wpa_supplicant
xorg
xorg-server
deepin
deepin-extra
mesa
PACKAGES

# DDE Setup
mkdir -p ~/archiso/airootfs/etc/lightdm
cat << DDE > ~/archiso/airootfs/etc/lightdm/lightdm.conf
[LightDM]
run-directory=/run/lightdm

[Seat:*]
greeter-session=lightdm-deepin-greeter
session-wrapper=/etc/lightdm/Xsession

[XDMCPServer]

[VNCServer]
DDE

# Copy install script to build
cp /vagrant/builds/desktop/install.sh ~/archiso/airootfs/root/

# Build the iso
cd ~/archiso
./build.sh -v
