# Prepares an Ubuntu Budgie 17 VM instance to be exported as a Vagrant box.
# 
# Part 1: OS and kernel upgrades.
# Part 2: Install tons of software and apply Vagrant hacks.
# Part 3: Clean system.
# 
# This script needs superman powers. Run like so:
# 
#   sudo sh prepare_box_part2.sh
# 
# Last edit: 2017-12-29

VBOX_VERSION=5.2.4

# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x

ukuu --remove v4.13.0-16.19
ukuu --remove v4.13.0.21.22
ukuu --remove v4.13.0-21.24

apt install -y libelf-dev gcc make
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop,ro VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run
umount /mnt
rm VBoxGuestAdditions_$VBOX_VERSION.iso
unset VBOX_VERSION

# "Passwords and keys" GUI app
apt install -y seahorse

# Annoying sidebar that makes zero sense
apt --purge -y autoremove plank

add-apt-repository -y ppa:ubuntubudgie/backports
apt update
apt install budgie-screenshot-applet

apt-add-repository -y ppa:tista/adapta
apt update
apt install -y adapta-gtk-theme

add-apt-repository -y ppa:papirus/papirus
apt update
apt install -y papirus-icon-theme

apt install fonts-hack-ttf

# Make taskbar just a tiny bit transparent
echo '.budgie-panel {background-color: rgba(0, 0, 0, 0.8);}' > /home/vagrant/.config/gtk-3.0/gtk.css

# Use a wallpaper stolen from Solus
SRC=https://github.com/martinanderssondotcom/box-ubuntu-budgie-17/raw/master/Crags.png
DEST=/usr/share/backgrounds/Xplo_by_Hugo_Cliff.png
sudo wget $SRC -O $DEST

# Authorize Vagrant's insecure public SSH key
wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown vagrant: /home/vagrant/.ssh/authorized_keys

# Set root password to "vagrant"
echo root:vagrant | chpasswd

# Passwordless sudo
echo $'\nvagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install an SSH server
apt install -y openssh-server

# Install extra stuff for backwards compatibility with Vagrant < 2.0.2
# Fixes https://github.com/hashicorp/vagrant/issues/9134
apt install -y net-tools ifupdown