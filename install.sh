#!/bin/bash

function help(){
  cat <<!EOF!

usage: install.sh --site-no --target [-h,--fs-type]

  This script installs the QRAAT-node software distribution 
  to the destination disk. This includes the Ubuntu Server 
  12.04 i386 operating system, GNU Radio, our software, and
  some customizations for running this node in a QRAAT
  deployment. WARNING: As this script writes a new partition
  table and master boot record, be sure to back up any
  important data.

  --site-no=N            Site number for the target machine. 

  --target=/dev/sdK      Destination disk for QRAAT installation. 
                         This will override the partition table and 
                         master boot record.

  --fs-type=TYPE         Filesystem type to use for main installation
                         partition. (Default is 'ext2'.) 

  -h                     Print this help. 

!EOF!
}



