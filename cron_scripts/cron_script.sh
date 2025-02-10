#!/bin/bash


################################################################################
# keep running this in crontabs (every 1 minute)

passwd -l root


# run this command and remove bad actors just keep an eye on PSPY + after beacon kills good practice to run this ^^^

# in case they have modified our configs
chattr -i /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config

#SSH whitelist
echo "AllowUsers hkeating" | tee -a /etc/ssh/sshd_config

chattr +i /etc/ssh/sshd_config

# Removing nopasswdlogon group
chattr -i /etc/group

echo "Removing nopasswdlogon group"
sed -i -e '/nopasswdlogin/d' /etc/group
chmod 644 /etc/passwd

chattr +i /etc/group


# making sure our critical services are running
systemctl enable mysql
systemctl enable ssh
systemctl enable sshd

# Making files immutable:

chattr +i /etc/sudoers
chattr +i /etc/group
chattr +i /etc/passwd
chattr +i /etc/ssh/sshd_config


# don't want attackers modifying cronjobs 
chattr +i /var/spool/cron

# security through obscurity... I know 😫
chattr +i /tmp/.ftab.lock

################################################################################
