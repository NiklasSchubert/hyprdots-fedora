#!/bin/bash
#|---/ /+-----------------------------------+---/ /|#
#|--/ /-| Script to enable copr             |--/ /-|#
#|-/ /--| Prasanth Rangan                   |-/ /--|#
#|/ /---+-----------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
else
    # swww & swaylock-effects
    sudo dnf copr enable -y trs-sod/swaylock-effects
    sudo dnf copr enable -y alebastr/sway-extras
    sudo dnf copr enable -y aeiro/nwg-shell
    sudo dnf copr enable -y solopasha/hyprland

    # grimblast
    sudo wget https://raw.githubusercontent.com/hyprwm/contrib/main/grimblast/grimblast -O /usr/bin/grimblast
    sudo chmod +x /usr/bin/grimblast

    # vscode
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
fi
