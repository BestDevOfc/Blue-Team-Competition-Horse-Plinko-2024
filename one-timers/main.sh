#!/bin/bash

# alimuhammadsecured Horse Plinko 2024 (inspiration: 2023 script by Oatz, Ardian Peach)

# TODO: live kernel patch (find command online, doesn't require a reboot, 
#  will SIGNIFICANTLY reduce attack surface with kernel-level privescs)

################################################################################

# modify (deny FTP, HTTP, and a few more services we don't want or need!):

ufw default deny incoming
ufw allow OpenSSH
ufw allow 22 tcp

ufw allow mysql
ufw allow 3306 tcp

ufw reload
ufw enable

echo "*** [ Status of UFW should NOT SAY INACTIVE ] ***"
ufw status verbose



################################################################################
#  Dealing with vsftp, ftpd, proftpd:

# Check and stop vsftpd
echo "Checking if vsftpd is running and stopping it...";
if systemctl is-active --quiet vsftpd; then
    echo "Stopping vsftpd service..."
    systemctl stop vsftpd
	systemctl disable vsftpd
else
    echo "vsftpd is not running."

# Check and stop ftpd
echo "Checking if ftpd is running and stopping it...";
if systemctl is-active --quiet ftpd; then
    echo "Stopping ftpd service..."
    systemctl stop ftpd
	echo "Disabling ftpd service..."
	systemctl disable ftpd
else
    echo "ftpd is not running."

# Check and stop proftpd
echo "Checking if proftpd is running and stopping it...";
if systemctl is-active --quiet proftpd; then
    echo "Stopping proftpd service..."
    systemctl stop proftpd
	echo "Disabling proftpd service..."
	systemctl disable proftpd
else
    echo "proftpd is not running."

echo "All FTP services have been disabled."



################################################################################



# changing all user account above 999 (usually non-defaults, likely created)
# and changes their passwords to PASSWORD! (need to modify the script to ask us for the passwd in CLI,
                                # so once we kill a beacon we can easily cycle all credentials)

################################################################################
# Dealing with Password STUFF HERE:
for user in $( sed 's/:.*//' /etc/passwd);
	do
	  if [[ $( id -u $user) -ge 999 && "$user" != "nobody" ]]
	  then
		(echo "PASSWORD!"; echo "PASSWORD!") |  passwd "$user"
	  fi
done

# locks /etc/passwd
pwck


# good practice, won't save us from their shells. ensures connecting client has proper permissions
# and not a world writeable home directory (might just be a little annoying to some red teamers)
# depending on how they have their setup bcs they have to pwn many servers
grep -q "^StrictModes yes" /etc/ssh/sshd_config || echo "StrictModes yes" | sudo tee -a /etc/ssh/sshd_config


# will not kill the SSHD connection :D
systemctl restart sshd

echo "[ *** RUN ssh -V, if it's outdated run: sudo apt install --only-upgrade openssh-server *** ]"
echo "Latest version should be OpenSSH_9.7p1 Debian-7, OpenSSL 3.3.2 3 Sep 2024 !!!"
################################################################################
