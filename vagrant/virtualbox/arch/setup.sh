#!/bin/bash

# Update and download packages
pacman -Syu --noconfirm
pacman -S --noconfirm archiso

# Move files into place
cp -r /usr/share/archiso/configs/releng ~/archiso
ln -s /vagrant ~/archiso/out
