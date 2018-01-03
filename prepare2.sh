# Prepares an Ubuntu Budgie 17 VM instance to be exported as a Vagrant box.
# 
# Part 1: Install tons of software and apply Vagrant hacks.
# Part 2: Clean system.
# 
# This script needs superman powers. Run like so:
# 
#   sudo sh prepare_box_part2.sh
# 
# Last edit: 2017-12-31

# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x

apt --purge -y autoremove arc-theme

apt --purge autoremove
apt-get clean

rm -rf /var/log/*
rm -rf /home/vagrant/.cache/*
rm -rf /root/.cache/*
rm -rf /var/cache/*
rm -rf /var/tmp/*
rm -rf /tmp/*

# Clear recent bash history
cat /dev/null > /home/vagrant/.bash_history
cat /dev/null > /root/.bash_history

# Fill empty space with zeroes
set +e
# This is supposed to crash with an error message:
#   "dd: error writing 'zerofile': No space left on device"
dd if=/dev/zero of=zerofile bs=1M
set -e

rm -f zerofile
sync

set +x
echo '\nAll done. Shutdown and package the box!'
history -c    # <-- clear this sessions's bash history