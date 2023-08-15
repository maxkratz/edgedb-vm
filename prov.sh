#!/bin/bash

#
# Config
#

set -e
START_PWD=$PWD

#
# Utils
#

# Displays the given input including "=> " on the console.
log () {
	echo "=> $1"
}

#
# Script
#

log "Start provisioning."

# Updates
log "Installing updates."
sudo apt-get update
sudo apt-get upgrade -y

# Packages for building a new kernel
sudo apt-get install -y gcc make perl curl

# https://www.edgedb.com/docs/guides/deployment/bare_metal#debian-ubuntu-lts
sudo mkdir -p /usr/local/share/keyrings && \
  sudo curl --proto '=https' --tlsv1.2 -sSf \
  -o /usr/local/share/keyrings/edgedb-keyring.gpg \
  https://packages.edgedb.com/keys/edgedb-keyring.gpg

echo deb [signed-by=/usr/local/share/keyrings/edgedb-keyring.gpg] \
  https://packages.edgedb.com/apt \
  $(grep "VERSION_CODENAME=" /etc/os-release | cut -d= -f2) main \
  | sudo tee /etc/apt/sources.list.d/edgedb.list

sudo apt-get update && sudo apt-get install -y edgedb-3

sudo systemctl enable --now edgedb-server-3

log "Clean-up"
sudo apt-get remove -yq \
        snapd \
        libreoffice-* \
        thunderbird \
        pidgin \
        gimp \
        evolution
sudo apt-get autoremove -yq
sudo apt-get clean cache

log "Finished provisioning."
