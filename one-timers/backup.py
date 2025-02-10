import os

dir = "plinko_backups"

os.mkdir(f"/{dir}")


# original /etc files + packages (easy to find new ones installed only at root, not "real" solution to problem)
os.system(f"ls -l /etc >> /{dir}/original_etc_stuff.txt")
os.system(f"ls -l /opt >> /{dir}/original_opt_stuff.txt")

# see original TCP connections / network configurations
# this will help us later identify any beacons being opened
os.system(f"netstat -planet >> /{dir}/netstat_planet.txt")
os.system(f"netstat -tulpn >> /{dir}/netsta_tulpn.txt")
os.system(f"ip route > /{dir}/routing_table_backup.txt")
os.system(f"iptables-save > /{dir}/iptables.txt")


def backup_mysql(user: str, passwd: str):
    print(f"[ Backing up MYSQL database... ]")
    os.system(f"mysqldump -u {user} -p'{passwd}' --all-databases >> /{dir}/backup.sql")

def backup_file_paths(paths: list):
    for path in paths:
        print(f"[ Backing up {path} ]")
        if os.path.isfile(path) == True:
            os.system(f"cp {path} /{dir} >> status.txt")
            # Too lazy to use Popen
            os.system(f"cat status.txt")
        elif os.path.isdir(path) == True:
            os.system(f"cp -r {path} /{dir} >> status.txt")
            os.system(f"cat status.txt")
        else:
            print(f"[*** Don't know what this path type is ( not a file/dir ! )  \"{path}\" ***]")
def root_crontab_backup():
    os.system(f"crontab -l >> /{dir}/root_crontab_backup.txt")

if __name__ == "__main__":
    backup_mysql('hkeating', 'hkeating')
    root_crontab_backup()

    paths_to_backup = [
        # user + permission configurations:
        "/etc/ssh", "/etc/shadow", "/etc/passwd", "/etc/group", "/etc/sudoers", "~/.ssh"
        # all of the original crontabs
        "cron.d", "cron.daily", "cron.hourly", "cron.monthly", "cron.weekly", "cron.yearly", "crontab",
        # network configurations:
        "/etc/hosts", "/etc/NetworkManager/", "/etc/resolv.conf", "/etc/network/interfaces",
        # other important files:
        "/etc/sysctl.conf", "/etc/fail2ban"
        
    ]
    backup_file_paths(paths_to_backup)
