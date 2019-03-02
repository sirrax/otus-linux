#!/bin/bash

oldvg=$(vgs | awk '{print $1}' | tail -1)
echo "Current VG name $oldvg"
echo "Return new VG name:"
read newvg
vgrename $oldvg $newvg


sed -i "s/\/${oldvg}-/\/${newvg}-/g" /etc/fstab
sed -i "s/\([/=]\)${oldvg}\([-/]\)/\1${newvg}\2/g" /boot/grub2/grub.cfg
sed -i "s/\([/=]\)${oldvg}\([-/]\)/\1${newvg}\2/g" /etc/default/grub
sleep 5
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
sleep 5
reboot
