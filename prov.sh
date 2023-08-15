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

# Install EdgeDB
log "Install EdgeDB server."

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

# Add link to the WebUI to the desktop
touch /home/vagrant/Desktop/edgedb-admin-ui.desktop
printf "
[Desktop Entry]
Encoding=UTF-8
Name=EdgeDB Admin UI
Type=Link
URL=https://127.0.0.1:5656/ui
Icon=web-browser
" > /home/vagrant/Desktop/edgedb-admin-ui.desktop

chmod u+x /home/vagrant/Desktop/*.desktop

# Enable the admin UI
sudo sed -i '/Environment=EDGEDATA=\/var\/lib\/edgedb\/3\/data\//a Environment=Environment=EDGEDB_SERVER_ADMIN_UI=enabled' /etc/systemd/system/edgedb-3-server.service
sudo systemctl daemon-reload
sudo systemctl restart edgedb-3-server

# Set an EdgeDB admin password
sudo edgedb --port 5656 --tls-security insecure --admin  --unix-path /run/edgedb query "ALTER ROLE edgedb SET password := 'edgedb'"

# Clean up
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
