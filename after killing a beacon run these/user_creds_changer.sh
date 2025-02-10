#!/bin/bash

# TODO: change credentials (ask us for new ones)

# make the files mutable again:
chattr -i /etc/shadow
chattr -i /etc/passwd
chattr -i /etc/group
chattr -i /etc/sudoers

# Dealing with Password STUFF HERE:
for user in $( sed 's/:.*//' /etc/passwd);
	do
	  if [[ $( id -u $user) -ge 999 && "$user" != "nobody" ]]
	  then
		(echo "PasswordSuperSecure123!"; echo "PasswordSuperSecure123!") |  passwd "$user"
	  fi
done

# locks /etc/passwd
pwck

# make them immutable:
chattr +i /etc/shadow
chattr +i /etc/passwd
chattr +i /etc/group
chattr +i /etc/sudoers