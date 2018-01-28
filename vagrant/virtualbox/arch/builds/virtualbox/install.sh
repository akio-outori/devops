#!/bin/bash

# Copies the contents of the livecd to the newly configured system
# should create a 1 to 1 copy of the livecd on the partition mounted as /mnt

# Things that should be done before running ./install.sh
# * Create /root and /boot partitions
# * Mount /root on /mnt
# * Mount /boot on /mnt/boot

HOSTNAME="arch-builder"
ROOT="/mnt"
MOUNT='/dev/sda'
INSTALL="arch-chroot $ROOT"
USER="vagrant" 

function new_root() {
  eval $INSTALL ${*}
}

# Install System
pacstrap /mnt base base-devel sudo grub awk wget linux-headers openssh

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

# Create USER and set password
new_root useradd -m -g users -G wheel -s /bin/bash $USER
echo "Specify a password for user - $USER"
new_root passwd $USER --stdin "$USER"

# Add insecure ssh-key for vagrant
new_root wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub 

# Create new cpio image
new_root mkinitcpio -p linux

# Install grub config
new_root grub-mkconfig -o /boot/grub/grub.cfg
new_root grub-install $MOUNT

# Configure any necessary services
new_root systemctl enable dhcpcd.service

# Inform the user that install is complete
echo "Installation Complete!"
echo "You can now reboot into your new system."
