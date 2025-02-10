#!/bin/bash

echo "[ *** Authorized SSH keys, make sure there aren't any malicious *** ]"
echo "[ *** Even if credentials are changed, they can still SSH into the machine! *** ]"
grep -Ri "ssh-rsa" /home/*/.ssh/authorized_keys



sudo debsums