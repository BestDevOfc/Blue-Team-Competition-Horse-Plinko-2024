#!/bin/bash

# TODO: install and run an AV

echo "[ Installing all packages and updates... ]";

apt update -y                   # updates our packages
apt install ufw -y              # firewall ( "uncomplicated firewall" )
apt install ranger -y 			# UI for file enumerations
apt install fail2ban -y			# for SSH banning, will stop bruteforce attacks
apt install tmux -y	
apt install curl -y
apt install whowatch -y			# see who's logged in via SSH

# ones I added:
sudo apt install debsums -y
apt install btop -y				# glorified task manager
apt install htop -y


echo "[ * Installing PSPY * ]";
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64
chmod +x pspy64
