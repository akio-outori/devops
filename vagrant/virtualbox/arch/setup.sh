#!/bin/bash

# Fix upstream ISO issues (age)
pacman -Rsd xorg-server --noconfirm
pacman -Sy archlinux-keyring --noconfirm

# Update and download packages
pacman -Syu --noconfirm
pacman -S --noconfirm archiso

# Move files into place
cp -r /usr/share/archiso/configs/releng ~/archiso
ln -s /vagrant ~/archiso/out
