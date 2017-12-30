# Prepares an Ubuntu Budgie 17 VM instance to be exported as a Vagrant box.
# 
# Part 1: OS and kernel upgrades.
# Part 2: Install tons of software and apply Vagrant hacks.
# Part 3: Clean system.
# 
# This script needs superman powers. Run like so:
# 
#   sudo sh prepare_box_part1.sh
# 
# Last edit: 2017-12-29

EXPECT_KERNEL=4.13.0-16-generic

# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x

apt update
apt -y full-upgrade

# (Kernel must be upgraded before Guest Additions or VBoxService will fail to start)

set +x
if [ "$(uname -r)" != $EXPECT_KERNEL ]; then
  echo '\nYour kernel is not the one expected lol.'
  echo '  Expected:' $EXPECT_KERNEL
  echo '  Found:   ' $(uname -r)
  echo I.e. lots of stuff in this script is kind of out of date.
  echo Please create a new issue: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17
  echo Aborting..
  exit 1
fi
set -x

apt-add-repository -y ppa:teejee2008/ppa
apt update
apt install -y ukuu
ukuu --install v4.14.9
# (old kernels removed in part 2)

echo System upgraded. Please reboot and run part 2.