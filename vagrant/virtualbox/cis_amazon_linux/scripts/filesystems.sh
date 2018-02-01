#!/bin/bash

## Creates the required mount points for CIS compliance,
## Mounts them, and copies over any data required for the 
## next reboot

# Partition disks
for disk in sdb sdc sdd sde sdf sdg; do
  (
    echo o # Create a new empty DOS partition table
    echo n # Add a new partition
    echo p # Primary partition
    echo 1 # Partition number
    echo   # First sector (Accept default: 1)
    echo   # Last sector (Accept default: varies)
    echo w # Write changes
  ) | fdisk /dev/$disk
done

# Format Disks
mkfs.ext4 /dev/sdb1
mkfs.ext4 /dev/sdc1
mkfs.ext4 /dev/sdd1
mkfs.ext4 /dev/sde1
mkfs.ext4 /dev/sdf1
mkfs.ext4 /dev/sdg1

# Mount new /tmp, /home, and /var in /root
for folder in 'tmp' 'home' 'var'; do
  mkdir -p /root/$folder
done

mount /dev/sdb1 /root/tmp
mount /dev/sdc1 /root/home
mount /dev/sdd1 /root/var

# mount subdirs for /var
for folder in 'var/tmp' 'var/log'; do
  mkdir -p /root/$folder
done

mount /dev/sde1 /root/var/tmp
mount /dev/sdf1 /root/var/log

# Finally mount /var/log/audit partition
mkdir -p /root/var/log/audit
mount /dev/sdg1 /root/var/log/audit

# Migrate data from old to new partitions
for mount in '/tmp' '/home' '/var'; do
  cp -apx $mount/* /root/$mount/
  mv $mount $mount.bak
  mkdir -p $mount
done

# Unmount temporary mounts for new filesystems
umount /root/var/log/audit
umount /root/var/log
umount /root/var/tmp
umount /root/var
umount /root/home
umount /root/tmp

# Mount the new devices
mount /dev/sdb1 /tmp
mount /dev/sdc1 /home
mount /dev/sdd1 /var
mount /dev/sde1 /var/tmp
mount /dev/sdf1 /var/log
mount /dev/sdg1 /var/log/audit

# Replace /etc/fstab
cp -f /vagrant/files/fstab /etc/fstab
