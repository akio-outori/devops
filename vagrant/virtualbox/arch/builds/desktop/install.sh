#!/bin/bash

# Copies the contents of the livecd to the newly configured system
# should create a 1 to 1 copy of the livecd on the partition mounted as /mnt

# Things that should be done before running ./install.sh
# * Create /root and /boot partitions
# * Mount /root on /mnt
# * Mount /boot on /mnt/boot

# Path to the root partition of the new system
ROOT="$1"

# Variables to set up the new_root command
HOSTNAME="zaku2"
INSTALL="arch-chroot $ROOT"

# User to install on the new system
USER="char" 

function new_root() {
  eval $INSTALL ${*}
}

# Set a default directory of /mnt for the install path
test -z $ROOT && ROOT='/mnt'

# Install System
pacstrap /mnt base base-devel linux-headers

# Install Utils
new_root pacman -S --noconfirm sudo grub-efi-x86_64 awk dialog wpa_supplicant net-tools

# Install Drivers
new_root pacman -S --noconfirm broadcom-wl-dkms xf86-input-synaptics mesa 
 
# Install GUI
new_root pacman -S --noconfirm xorg xorg-server deepin deepin-extra

# Install GUI Applications
new_root pacman -S --noconfirm chromium

# Install Development Tools
new_root pacman -S --noconfirm git vagrant terraform virtualbox virtualbox-host-modules-arch virtualbox-guest-iso docker

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Set localtime
new_root rm /etc/localtime
new_root ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime

# Set clock
new_root hwclock --systohc

# Set locale
new_root sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
new_root locale-gen
echo "LANG=en_US.UTF-8" >> /$ROOT/etc/locale.conf
new_root chown root:root /etc/locale.conf

# Set Hostname
echo "$HOSTNAME" > /$ROOT/etc/hostname
new_root chown root:root /etc/hostname

# Add /etc/hosts file
cat << HOSTS > /$ROOT/etc/hosts
127.0.0.1 localhost.localdomain localhost
::1       localhost.localdomain localhost

127.0.0.1 $HOSTNAME
HOSTS

new_root chown root:root /etc/hosts

# Set the root password for the new install
echo "Specify a root password for the new install:"
new_root passwd

# Create USER and set password
new_root useradd -m -g users -G wheel -s /bin/bash $USER
echo "Specify a password for user - $USER"
new_root passwd $USER

# DDE Setup
new_root mkdir -p /$ROOT/etc/lightdm/lightdm.conf
cat << DDE > /$ROOT/etc/lightdm/lightdm.conf
[LightDM]
run-directory=/run/lightdm

[Seat:*]
greeter-session=lightdm-deepin-greeter
session-wrapper=/etc/lightdm/Xsession

[XDMCPServer]

[VNCServer]
DDE

# Generate initramfs
new_root mkinitcpio -p linux

# Generate grub config
new_root grub-mkconfig -o /boot/grub/grub.cfg

# Inform the user that install is complete
echo "Installation Complete!"
echo "You can now reboot into your new system."
