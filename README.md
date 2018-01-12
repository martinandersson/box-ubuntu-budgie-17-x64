# A Vagrant box with Ubuntu Budgie 17 (x64)

The artifact of this project is a manually packaged `.box` file with [Ubuntu
Budgie 17][intro-1] installed<sup>1</sup>.

Actually, the box is already packaged for you and distributed on
[Vagrant's website][intro-2].

_This GitHub project_ is used as an issue tracker as well as a notepad on how
exactly the box was prepared.

I've added stuff like Oracle's Guest Additions and the `vagrant` user account
(password `vagrant`). I've also taken the liberty to change the appearance of
the distribution as to more closely resemble [Solus 3][intro-3]; the original
Budgie distribution. For example, the space-stealing [Plank][intro-4] dock has
been removed and the app icons are put back where they belong, in the taskbar.

Only software packages necessary to get the VM running has been installed, i.e.,
no bloat. You will get a VM that is pritty much a bare Ubuntu Budgie 17 as
originally intended, except it will look a hell of a lot better.

![The Budgie Desktop][intro-img-1]

<sub><sup>1</sup> The semantical concept captured here is elsewhere described as
a "minimal" and/or "base" box. I refrain from using either term since 1.67 GB
with a full office suite installed et cetera is hardly "minimal" nor am I
convinced that all use-cases of this box are to derive yet another box as
implied by the word "base". We are building a box. Period.</sub>

[intro-1]: https://ubuntubudgie.org/
[intro-2]: https://app.vagrantup.com/pristine/boxes/ubuntu-budgie-17-x64
[intro-3]: https://solus-project.com/
[intro-4]: https://launchpad.net/plank

[intro-img-1]: screenshots/intro/1-final-desktop.png

## Using the box

Make sure you have [Vagrant][using-1] installed, [VirtualBox][using-2] installed
together with the Extension Pack, then, in theory, all you should have to do in
order to get a Virtual Machine up and running with Ubuntu Budgie 17 is:

    vagrant init pristine/ubuntu-budgie-17-x64
    vagrant up

**Be warned**: A few noteworthy issues exist with products in the ecosystem we
depend on.

For starters, Vagrant < 2.0.2 can't configure a hostname and network on Ubuntu
17.10 (see this [issue][using-3]). `net-tools` and `ifupdown` have been added to
the box for backward compatibility with older Vagrant versions.

The added packages do not fully solve the problem. The first `vagrant up` call
does not crash and Internet will work during the first user session, but the VM
will not be accessible using the new hostname or static IP until after a VM
restart. Plus, what normally is a Wi-Fi icon in the bottom right corner of the
screen will be switched to a spinning circular icon. The icon will reset to
normal after a few minutes.

Another issue is that VirtualBox's 3D acceleration is like broken and if
enabled, will probably make the machine so slow it's not going to be usable
anymore. Don't enable it. See [this issue][using-4].

[using-1]: https://www.vagrantup.com/
[using-2]: https://www.virtualbox.org/wiki/Downloads
[using-3]: https://github.com/hashicorp/vagrant/issues/9134
[using-4]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/issues/1

## Steps to reproduce the distributed box

1. [Create the Virtual Machine](#create-the-virtual-machine)
1. [Install OS](#install-os)
1. [Upgrade the system](#upgrade-the-system)
1. [Theming and customization](#theming-and-customization)
1. [Package the box](#package-the-box)
1. [Test the box](#test-the-box)
1. [Publish the box](#publish-the-box)

## Create the Virtual Machine

Create a new VM instance. Name it `ubuntu-budgie-17`. Select type `Linux`,
version `Ubuntu (64-bit)`. Set memory size to `4096 MiB`.

![Create VM][create-img-1]

Smack in a dynamically allocated disk with max size `40 GB`, type `VMDK`.

Notes:

- 40 GB as limit seems to be what most people online use.
- VMDK is the final format used inside the exported box. It is okay to create
  the VM using another format. If so, then the disk will be converted to VMDK
  during export (original disk file remains intact).

![Create VMDK disk][create-img-2]

Open settings. Enable a bidirectional clipboard.

![Bidirectional clipboard][create-img-3]

Floppy disk?? There's nothing to be discussed here. Get rid of that shit.

![Disable boot-from floppy][create-img-4]

Use two CPUs (no particular reason). Click "OK" to save the new settings and
close the dialog.

Do **not** go into "Display" and enable 2D- or 3D acceleration. 2D acceleration
is for Windows guests only <sup>[[source][create-1]]</sup> and 3D acceleration
is broken <sup>[[GitHub issue][create-2]]</sup>.

![Use two CPUs][create-img-5]

Using the terminal on your host machine, bump the video memory to `256 MiB`:

    VBoxManage modifyvm ubuntu-budgie-17 --vram 256

Notes:

- On my Windows host, VBoxManage is located in
  `C:\Program Files\Oracle\VirtualBox`.
- I have not been able to decipher what effect - if any - various different
  video memory sizes have. I certainly do not know why VirtualBox limit the GUI
  control to 128 MiB.

[create-1]: https://www.virtualbox.org/manual/ch04.html#guestadd-2d
[create-2]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/issues/1

[create-img-1]: screenshots/create/1-create-vm.png
[create-img-2]: screenshots/create/2-create-vmdk-disk.png
[create-img-3]: screenshots/create/3-bidirectional-clipboard.png
[create-img-4]: screenshots/create/4-disable-floppy-boot.png
[create-img-5]: screenshots/create/5-use-two-cpus.png

## Install OS

Mount the OS installation's ISO file (grab it [here][install-1]). Click on the
little CD icon to the right in the next picture. Then select "Choose Virtual
Optical Disk File...".

The file I mounted was named: `ubuntu-budgie-17.10-desktop-amd64.iso`.

![Mount the Ubuntu ISO][install-img-1]

![Welcome][install-img-2]

![Preparing to install Ubuntu Budgie][install-img-3]

![Installation type][install-img-4]

![Installation type][install-img-5]

![Region][install-img-6]

On this particular screen, I had to drag the window to the left in order to
reveal the "Continue" button lol.

![Keyboard layout][install-img-7]

Password = `vagrant`.

![Setup user][install-img-8]

![Installing][install-img-9]

![Restart prompt][install-img-10]

After restart, Ubuntu asks you to remove the installation medium. For whatever
reason - and maybe this is only a phenomena local to my machine - but when I
clicked on "Restart Now", my installation medium will automagically unmount. So
all I need to do on this screen is to hit ENTER.

![Remove medium][install-img-11]

[install-1]: https://ubuntubudgie.org/downloads

[install-img-1]: screenshots/install/1-mount-ubuntu-iso.png
[install-img-2]: screenshots/install/2-welcome.png
[install-img-3]: screenshots/install/3-prepare.png
[install-img-4]: screenshots/install/4-installation-type.png
[install-img-5]: screenshots/install/5-installation-type.png
[install-img-6]: screenshots/install/6-region.png
[install-img-7]: screenshots/install/7-keyboard.png
[install-img-8]: screenshots/install/8-user.png
[install-img-9]: screenshots/install/9-installing.png
[install-img-10]: screenshots/install/10-restart.png
[install-img-11]: screenshots/install/11-remove-medium.png

## Upgrade the system

Open a terminal and run:

    sudo apt update
    sudo apt full-upgrade -y

If the upgrade crash because a lock file is being in use, then it's probably
cuz `unattended-upgrades` is running in the background. It's possible to
circumvent this obstacle by manually deleting lock files `/var/lib/dpkg/lock`
and `/var/cache/apt/archives/lock`. I could never cheat the system, however.
Deleting the lock files never made me able to fully complete the upgrade without
additional problems. My advice is to wait a few minutes (actually, more like
5-10 minutes) and then try again ([more info][upgrade-1]).

After the upgrade completes, **restart**. If you don't restart, there will be a
lot of problems lol. Especially so if the kernel was upgraded.

Open a terminal and run:

    wget https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/raw/master/prepare1.sh
    sudo sh prepare1.sh

One of the things this script does is to install Oracle's Guest Additions. This
software stack will not - reportedly - install successfully. Something like this
will be visible somewhere in the output of the script:

> VirtualBox Guest Additions: modprobe vboxsf failed

According to this message, the Linux kernel module `vboxsf` failed to install
and this guy is sort of responsible for shit related to "shared folders".
Luckily, this message appears to be a false flag. `lsmod` would, after a fresh
reboot, list `vboxsf`. Plus, as will become evident later, Vagrant's shared
folder feature *does* work. So, I'd say it's safe to ignore the message.

[upgrade-1]: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/issues/3

## Theming and customization

The setup script we executed (one of two parts/scripts in total) removed the
dock app "Plank". This dock is still visible because we haven't restarted the
machine after running the script. Either, 1) restart or 2) manually quit the
dock (Ctrl + right mouse button to bring up the menu). I chose number 2.

If we did restart, and then opened the Chromium web browser, it would also
become evident that Chromium insists on asking the user for a password to unlock
a "keyring".

![Chromium asking for keyring password][theming-img-1]

Turns out that when our OS user logs in automagically, the "login" keyring is
*not* automagically unlocked and Chromium, who uses this keyring to store
passwords and what not, will simply harass the user for the user password. Once
for each OS session; which kind of annihilate any utility we got out from the
autologin feature in the first place. Big annoyance!

One of all involved parties has from a security point-of-view, fuct up. A rule
of thumb when it comes to security design is to not piss in the user's face.
When productivity is hindered by security, the user will simply find his way to
disable the security and be at an even greater risk than what was first
intended. Of course, that is exactly what we shall do by removing the password.

Open the "Passwords and Keys" GUI app. Change the login keyring's password from
`vagrant` to blank. <sup>[[source][theming-1]]</sup>

![Change keyring password][theming-img-2]

Open "Budgie Desktop Settings".

In the *Style* page, set the following:

- Widgets: `Adapta-Eta`
- Icons: `Papirus`
- Dark theme: `off`
- Built-in theme: `hell no`
- Animations: `on`

![Style][theming-img-3]

In the *Desktop* page, enable the Trash desktop icon.

In the *Fonts* page, set the following:

- Window Titles: `Noto Sans UI Bold 10`
- Documents: `Noto Sans UI Regular 10`
- Interface: `Noto Sans UI Regular 10`
- Monospace: `Hack Regular 10`

![Fonts][theming-img-4]

In the *Autostart* page, remove Caffeine Indicator.

In the *Top Panel* page, *Settings* tab, set the following:

- Position: `Bottom`
- Shadow: `off`

Same page, *Applets* tab.. rearrange the taskbar nightmare into something more
soothing.

Notes:

- "Places" and all separators and all spacers are removed.
- "Icon Task List" is added.

![Rearrangement][theming-img-5]

Unpin the LibreOffice Writer app launcher icon and pin Tilix (terminal).

![Taskbar][theming-img-6]

At this point, the desktop looks almost like the finished product. The script
we ran a bit earlier did make the taskbar just a tiny bit transparent which is
not noticeable before a restart. Similarly, the tremendously nonsensical and
bloated Caffeine Indicator is still visible in the taskbar before a restart.

But, we don't need to restart for the benefit of this box setup.

Increase audio volume to max.

Open the "Budgie Welcome" app and check "Show this dialog on startup".

[theming-1]: https://nullroute.eu.org/~grawity/gnome-keyring-autologin.html

[theming-img-1]: screenshots/theming/1-chromium.png
[theming-img-2]: screenshots/theming/2-keyring.png
[theming-img-3]: screenshots/theming/3-style.png
[theming-img-4]: screenshots/theming/4-fonts.png
[theming-img-5]: screenshots/theming/5-rearrangement.png
[theming-img-6]: screenshots/theming/6-taskbar.png

## Package the box

Open a terminal and run:

    wget https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/raw/master/prepare2.sh
    sudo sh prepare2.sh
    rm prepare?.sh
    history -c

Shut down the machine (or let Vagrant do that automagically when running the
next command).

On the host machine, download [this Vagrantfile][package-1] and put it in the
working directory. Then run:

    vagrant package --base ubuntu-budgie-17 --output ubuntu-budgie-17.box --vagrantfile Vagrantfile

[package-1]: https://raw.githubusercontent.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/master/Vagrantfile

## Test the box

    mkdir test-vm
    cd test-vm
    vagrant init ../ubuntu-budgie-17.box

Add a customized hostname to the generated Vagrantfile and also some random
network settings. For example:

> config.vm.hostname = 'xxx'  
> config.vm.network 'private_network', ip: '192.168.66.66'

Run:

    vagrant up

Make sure:

- The hostname and network settings has an effect.
- The project folder is synced back and forth.
- The clipboard is bidirectional.

Run:

    vagrant destroy -f
    vagrant box remove ../ubuntu-budgie-17.box
    cd..
    rm test-vm -r

## Publish the box

Go to [this page][publish-1] and upload the box file.

Here's a few commands needed for the description(s):

- Budgie desktop: `budgie-desktop --version`
- Ubuntu: `lsb_release -r`
- Linux kernel: `uname -r`
- Guest Additions: `sudo VBoxService --version`

[publish-1]: https://app.vagrantup.com/boxes/new