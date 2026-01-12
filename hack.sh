#!/bin/bash
# ----------------------------------------------------------
# Script Name:     hack.sh
# Description:     Sets up 1337 hacking environment
# Author:          0x64azana
# Created:         2025-08-31
# Version:         2.1
# ----------------------------------------------------------
# Requirements: sway/i3, wtype/xdotool, i3-sensible-terminal, cherrytree
# ----------------------------------------------------------

####################
# SESSION DETECT
####################
if [[ -n $WAYLAND_DISPLAY ]] && command -v swaymsg &>/dev/null; then
    S=wayland
elif [[ -n $DISPLAY ]] && command -v i3-msg &>/dev/null; then
    S=x11
else
    echo "[!] No supported WM found (i3 or sway)"
    exit 1
fi

####################
# HELPERS
####################
mimis(){ sleep 0.3; }

key_escape(){ [[ $S == wayland ]] && wtype -k Escape || xdotool key Escape; }

term(){ i3-msg "exec i3-sensible-terminal"; mimis; }

run(){
    if [[ $S == wayland ]]; then
        wtype "$1" -k Return
    else
        xdotool type "$1"
        xdotool key Return
    fi
    mimis
    zoomout
}

zoomout(){
    [[ $S == wayland ]] && wtype -M ctrl -k minus -m ctrl || xdotool key ctrl+minus
}

####################
# USER INPUT
####################
env_chosen=$(zenity --list --title="Select an environment" --column="Environment" \
    "OffSec" "HTB-Academy" "HTB-Labs" "THM" "Hack-Smarter")

set_ip=$(zenity --entry --title="Target IP" --text="Enter target IP:")

####################
# ENVIRONMENT MAP
####################
case "$env_chosen" in
  "OffSec")        vpn="$HOME/VPNs/os.ovpn";            dest="$HOME/Templates/OSTemp/PG" ;;
  "HTB-Academy")   vpn="$HOME/VPNs/htb-academy.ovpn";  dest="$HOME/Templates/HTBTemp/Misc" ;;
  "HTB-Labs")      vpn="$HOME/VPNs/htb-lab.ovpn";      dest="$HOME/Templates/HTBTemp/Machines" ;;
  "THM")           vpn="$HOME/VPNs/thm.ovpn";          dest="$HOME/Templates/THMTemp" ;;
  "Hack-Smarter")  vpn="$HOME/VPNs/challenge_lab_*";   dest="$HOME/Templates/HackSmarTemp" ;;
  *) echo "[!] Unknown environment"; exit 1 ;;
esac

####################
# WORKSPACE SETUP
####################
key_escape
i3-msg "workspace 3: Terminal"
mimis

####################
# TERMINALS & LAYOUT
####################
cmd="ip=$set_ip; IP=$set_ip; clear"

# t1: VPN in tab
term
run "sudo openvpn $vpn"
i3-msg "layout tabbed"
mimis

# t2: top-left
term
run "cd $dest; $cmd"

# t3: bottom-left
i3-msg "split v"
term
run "$cmd"

# tab bottom row: t3 & t4
i3-msg "split h"
term
run "$cmd"
i3-msg "layout tabbed"

# t5: top-right
i3-msg "focus left"
i3-msg "focus up"
i3-msg "split h"
term
run "$cmd"

####################
# NOTES
####################
i3-msg "workspace 4: Notes"
i3-msg "exec cherrytree"

