#!/usr/bin/env bash

function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_bash4() {
  brew install bash
  echo "Adding BASH 4 to /etc/shells (requires sudo):"
  sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'

  if [ -e bash_profile ]; then
    cp ./bash_profile ~/.bash_profile
  else
    echo "No BASH profile found!"
  fi
}

function install_git() {
  brew install git
  mkdir -p git-projects/TR
  mkdir -p git-projects/personal
  mkdir -p git-projects/clients
  if [ -e config ]; then
    cp ./config ~/.ssh/config
  else 
    echo "No SSH config found!"
  fi
}

function install_system_python() {
  brew install wget 
  wget https://bootstrap.pypa.io/get-pip.py
  echo "Escalating to root to install python-pip:"
  sudo python ./get-pip.py
  echo "Installing YAML support:"
  sudo pip install pyyaml
  echo "Installing Jinja support:"
  sudo pip install jinja2
}

function install_virtualbox() {
  brew install Caskroom/cask/virtualbox
}

function install_vagrant() {
  brew install Caskroom/cask/virtualbox
}

function install_terraform() {
  brew install terraform
}

function install_groovy() {
  brew install Caskroom/cask/java
  brew install groovy
}

function install_chefdk() {
  brew install Caskroom/cask/chefdk
}

function install_slack() {
  brew install Caskroom/cask/slack
}

function install_alfred() {
  brew install Caskroom/cask/alfred
}

function install_flux() {
  brew install Caskroom/cask/flux
}

function install_vim() { 
   mkdir -p ~/.vim/bundle
   mkdir -p ~/.vim/autoload
   wget https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -O ~/.vim/autoload/pathogen.vim
   git clone git@github.com:altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized
   git clone https://github.com/scrooloose/syntastic ~/.vim/bundle/syntastic
   #git clone https://github.com/valloric/youcompleteme ~/.vim/bundle/youcompleteme
   if [ -e vim/vimrc ]; then
     cp -f vim/vimrc ~/.vimrc
   else
     echo "No vimrc file found!"
   fi
}

which brew &> /dev/null || install_homebrew

OPTION="$1"

case $OPTION in 
  "bash")
          install_bash4
          ;;
  "git")
          install_git
          ;;
  "vim")
          install_vim
          ;;
  "system-python")
          install_system_python
          ;;
  "virtualbox")
          install_virtualbox
          ;;
  "vagrant")
          install_vagrant
          ;;
  "terraform")
          install_terraform
          ;;
  "groovy")
          install_groovy
          ;;
  "chef-dk")
          install_chefdk
          ;;
  "slack")
          install_slack
          ;;
  "alfred")
          install_alfred
          ;; 
  "flux")
          install_flux
          ;;
  "all")
          install_bash4
          install_git
          install_system_python
          install_virtualbox
          install_vagrant
          install_terraform
          install_groovy
          install_chefdk
          install_slack
          install_alfred
          install_flux
          ;;
  *)
          echo "Response not understood.  Available options are:"
          echo "*  bash"
          echo "*  git"
          echo "*  vim"
          echo "*  virtualbox"
          echo "*  vagrant"
          echo "*  terraform"
          echo "*  groovy"
          echo "*  chef-dk"
          echo "*  slack"
          echo "*  alfred"
          echo "*  flux"
          ;;
esac

