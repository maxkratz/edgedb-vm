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

sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.edgedb.com | sh

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
