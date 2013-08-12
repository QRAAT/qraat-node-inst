
Setting up installatin media
============================

To install a ramdisk distribution of ttylinux on a flash drive, mount the 
vfat formatted partition, move to the directory, untar ramdisk.tgz, and 
run syslinux. Assuming the device is /dev/sdb1 and the mountpoint is 
~/mnt/flash: 

  $ sudo mkfs.vfat /dev/sdb1
  $ sudo blkid /dev/sdb1             ---> get <UUID>
  $ sudo mount /dev/sdb1 ~/mnt/flash
  $ cd ~/mnt/flash && sudo tar -zxf ramdisk.tgz
  $ sudo syslinux -d boot/syslinux /dev/sdb1
  $ sudo vi boot/syslinux/syslinux.cfg

Set the ttylinux-flash paramter in the kernel boot paramters for ttylinux 
to <UUID>. 

The default boot option creates a ramdisk with 256 MB and uses 1024x768x16
for the terminal screen mode. 

fixups
======

These files are copied to the target file system after the operating system
is extracted. Note: when copying fixups/etc/sudoers to the installation 
media, be sure to change its permissions with 'chmod 0440 etc/sudoers'. 
