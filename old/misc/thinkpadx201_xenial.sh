#!/bin/sh

# .SCRIPTDOC

# Performs provisioning steps specific to running Linux/xenial on the Thinkpad
# X201, most importantly configuring thinkfan.

# .ENDOC

SCRIPTDIR="$(dirname "$0")"
sudo apt install --yes thinkfan
sudo echo "options thinkpad_acpi experimental=1 fan_control=1" >> /etc/modprobe.d/thinkpad.conf
sudo systemctl enable thinkfan.service
sudo cp "$SCRIPTDIR/thinkfan.conf" "/etc/thinkfan.conf"
