#!/bin/bash
# Script will allign the VBox Extension Pack with currently installed VBox version
# Good idea to run it after VBox update ;-)
set -eo pipefail

VBOXVER=$(vboxmanage --version | cut -f1 -d"r" | cut -f1 -d"_")
VBOXEXTPACKVER=$(vboxmanage list extpacks | grep Version | awk '{print $2}')

if [ "$VBOXVER" != "$VBOXEXTPACKVER" ]; then
  wget "https://download.virtualbox.org/virtualbox/$VBOXVER/Oracle_VM_VirtualBox_Extension_Pack-$VBOXVER.vbox-extpack" -P /tmp/
  echo "y"| vboxmanage extpack install --replace "/tmp/Oracle_VM_VirtualBox_Extension_Pack-$VBOXVER.vbox-extpack"
  VBOXEXTPACKVER=$(vboxmanage list extpacks | grep Version | awk '{print $2}')
  if [ "$VBOXVER" == "$VBOXEXTPACKVER" ]; then
    logger "VirtualBox Extension Pack has been updated to version $VBOXEXTPACKVER"
    rm "/tmp/Oracle_VM_VirtualBox_Extension_Pack-$VBOXVER.vbox-extpack"
  fi
fi
