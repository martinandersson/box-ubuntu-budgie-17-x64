# Prepares an Ubuntu Budgie 17 VM instance to be exported as a Vagrant box.
# 
# Part 1: Install tons of software and apply Vagrant hacks.
# Part 2: Clean system.
# 
# This script needs superman powers. Run like so:
# 
#   sudo sh prepare1.sh
# 
# Last edit: 2018-01-02

VBOX_VERSION=5.2.4

# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x



# Fixes this: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/issues/3
DIR=/etc/systemd/system/apt-daily.timer.d
mkdir $DIR

echo '[Timer]
OnCalendar=
OnBootSec=15min
OnUnitActiveSec=1d
AccuracySec=1h
RandomizedDelaySec=30min
Persistent=false' > $DIR/delayed-start-after-boot.conf



apt install -y gcc make
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop,ro VBoxGuestAdditions_$VBOX_VERSION.iso /mnt

# Yes, it is expected this guy fails..
set +e
/mnt/VBoxLinuxAdditions.run
set -e

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

apt install -y fonts-noto

apt install fonts-hack-otf

# Make taskbar just a tiny bit transparent
echo '.budgie-panel {background-color: rgba(0, 0, 0, 0.8);}' > /home/vagrant/.config/gtk-3.0/gtk.css

# Use a wallpaper stolen from Solus
SRC=https://github.com/martinanderssondotcom/box-ubuntu-budgie-17/raw/master/Crags.png
DEST=/usr/share/backgrounds/Xplo_by_Hugo_Cliff.png
sudo wget $SRC -O $DEST

# Authorize Vagrant's insecure public SSH key
mkdir /home/vagrant/.ssh/
chmod 700 /home/vagrant/.ssh/
wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh/

# Set root password to "vagrant"
echo root:vagrant | chpasswd

# Passwordless sudo
echo '\nvagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install an SSH server
apt install -y openssh-server

# Install extra stuff for backwards compatibility with Vagrant < 2.0.2
# Fixes https://github.com/hashicorp/vagrant/issues/9134
apt install -y net-tools ifupdown

set +x
echo '\nSoftware packages are now up to date.'
echo Manually finish the customization of the OS before running part 2.