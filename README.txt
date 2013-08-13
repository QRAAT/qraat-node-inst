This file has instructions for setting up QRAAT nodes. To make this process
consistent -- but also to avoid the pitfalls of creating and distributing a
raw disk image -- we prove instructions and a script for setting up an 
installer thumb drive. The files we need are: 

 install-node -- QRAAT node installation script. 

 ttylinux.tgz -- bootable installation environment. 

 qraat-fs.tgz -- A tarball containing Ubuntu Server (and costumizations), GNU 
                 Radio, and the QRAAT software. (Note this file is not
                 distributed because it's too big.)  

 fixups/ -- a directory containing OS configuration files that will be
            installed after the OS is extracted. 



1 Setting up installation media
===============================

We boot the target system with ttylinux, a minimalistic distribution of
GNU/Linux which fits neatly into memory. These instructions will help you
install the bootable system and the files needed for installing/configuring
the node.

1.1 ttylinux 
------------

The file 'ttylinux.tgz' in this directory corresponds to a distribution of
ttylinux which runs in memory. Be sure that the partition on the flash drive
is marked bootable. Assuming the device is /dev/sdb1 and the mountpoint is 
/media/ttylinux: 

  $ sudo mkfs.vfat /dev/sdb1 -n ttylinux
  $ sudo blkid /dev/sdb1             ---> get <UUID>
  $ sudo mount -t vfat /dev/sdb1 /media/ttylinux
  $ cd /media/ttylinux && sudo tar -zxf ttylinux.tgz
  $ sudo syslinux -d boot/syslinux /dev/sdb1
  $ sudo vi boot/syslinux/syslinux.cfg

Set the ttylinux-flash paramter in the kernel boot paramters for ttylinux 
to <UUID>. 
 
  $ sudo umount

The default boot option creates a ramdisk with 256 MB and uses 1024x768x16
for the terminal screen mode. 

1.2 install files 
-----------------

It's recommended that you store the qraat distribution tarball on a separate
partition: 

  $ sudo mkfs.ext4 /dev/sdb2 -L "qraat-inst"
  $ sudo mount /dev/sdb2 /media/qraat-inst
  $ cp -R install-node fixups qraat-fs.tgz /media/qraat-inst

IMPORTANT: The directory 'fixups/' contains files that will be copied over to 
the target system after the distribution (qraat-fs.tgz) is extracted. After
copying fixups/etc/sudoers to the installation media, be sure to change its 
permissions with 'chmod 0440 etc/sudoers'. 



2 Installing the system
=======================

We plan to add a bunch more features to the installation process as time
progresses; for now it's very simple. Boot the target system from the flash 
drive. Type 'root'/'password' at the login prompt. First things first; mount
the partition with the installer files: 

  # mkdir /mnt/qraat-inst && mount /dev/sdb2 /mnt/qraat-inst 
  # cd /mnt/qraat-inst

There are two ways to install QRAAT:

 (1) Specify the target disk with the --target-disk option. This will
     automatically partition the entire disk thusly: 
       /dev/sda1 -- primary partition (where OS will be installed) 
       /dev/sda2 -- 512 MB swap 

 (2) Alternatively you can use fdisk to manually parition the disk. You'll
     then have to specify the primary and swap partitions with --parimary-part
     and --swap-part respectively. 

2.1 install-node
----------------

install-node performs the following tasks:

 (1) Partition the disk (if necessary).
 (2) Format the primary and swap partitions (use labels instead of UUIDs). 
 (3) Extract the filesystem (qraat-fs.tgz) to the primary partition. 
 (4) Copy some site-specific operating system configuration files (fixups/).
 (5) Remove persistent udev rules. 
 (6) Update grub on the target partition.      

To run install-node, you will need to pass the site number of the node with
--site-no. This should be a number between 0 and 255, since it will also be
used for the IP address eth0 interface. 

Type 'install-node -h' for additional options. You must run install-node in
the directory containing the installation files (fixups/ and qraat-fs.tgz). 
Some example runs: 
 
  # ./install-node --target-disk=/dev/sda --site-no=99 --fs-type=ext4
  # ./install-node --primary-part=/dev/sda2 --swap-part=/dev/sda5 --site-no=99

Running the following won't format or install anything; it will only run a
grub update on the target partition. 

  # ./install-node --target-disk=/dev/sda1 --fix-grub 

2.2 fixups/
-----------

A more in-depth explanation of this directory would be useful. fixups/ has
operating system configuration files corresponding to paramters we may want to
have configurable in the installation process. For example: 
 
 etc/fstab -- the filesystem type of the primary partition is configuratble, 
              may want to be able to configure the size of the ramdisk. 

 etc/hosts, /etc/hostname -- site specific.

 etc/network/interfaces -- site specific. 

It also includes OS costumizations we have found useful. 



3 TODOs
=======

 (1) Some of the files included in fixups/ may be foolish. Look into this as
     soonas the new build is done. 

 (2) install-node: there is a line that calculates the size of qraat-fs.tgz
     it's on disk. Currently this is commented out because it takes way too
     long. A better way to do this?  


4 Future features
=================

As stated, we plan on developing the installation process as more site- and 
environment-specific configurations become necessary. Some things we
definitely want to add: 

 (1) Seemless installation process that doesn't require you to drop to the
     terminal. (Leave this as an option.)

 (2) Use serial console for field installations. 

 (3) Install over network (netboot).

 (4) cfdisk.  






This document was written by Chris Patton for QRAAT. 
