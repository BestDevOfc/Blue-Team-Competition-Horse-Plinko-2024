import os
MYSQL_USER = "hkeating"
CURRENT_PASSWORD = input("[ Enter old password ]: ")

new_passwd = input("[ Enter new password for mySQL ]: ")
os.system(f"mysql -u {MYSQL_USER} -p'{CURRENT_PASSWORD}' -e \"ALTER USER '{MYSQL_USER}'@'localhost' IDENTIFIED BY '{new_passwd}'\" >> status.txt")
os.system(f"cat status.txt")

print(f"[ DONE. ]")