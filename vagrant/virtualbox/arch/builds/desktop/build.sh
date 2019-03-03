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

# Copy pacman config to the new live cd
cp -f /etc/pacman.conf ~/archiso/pacman.conf

# Change to home dir
cd ~/

# Configure Loadable Modules
mkdir -p ~/archiso/airootfs/etc/modprobe.d
echo "zfs" > ~/archiso/airootfs/etc/modprobe.d/zfs

# Add packages to build
cat << PACKAGES > ~/archiso/packages.x86_64
base
base-devel
awk
linux-headers
linux-firmware
xf86-input-synaptics
xf86-video-nouveau
dialog
wpa_supplicant
xorg
xorg-server
deepin
deepin-extra
zfs-dkms
efibootmgr
arch-install-scripts
vim
cpio
dhcpcd
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

# DNS Setup
cat << DNS > ~/archiso/airootfs/etc/resolv.conf
nameserver 8.8.8.8
nameserver 4.2.2.1
DNS

# Custom Services Setup
cat << CUSTOM > ~/archiso/airootfs/root/customize_airootfs.sh
systemctl enable dhcpcd
systemctl enable lightdm
CUSTOM

# Copy install script to build
cp /vagrant/builds/desktop/install.sh ~/archiso/airootfs/root/

# Build the iso
cd ~/archiso
./build.sh -v
