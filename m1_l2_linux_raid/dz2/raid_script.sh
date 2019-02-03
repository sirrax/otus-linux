#!/bin/bash


validtype=true
while [ $validtype ]
do
echo "Enter type  Raid (1,5,6,10)"
read typeraid
if [ $typeraid -eq 1 ];
then
break
elif [ $typeraid -eq 5 ];
then
break
elif [ $typeraid -eq 6 ];
then
break
elif [ $typeraid -eq 10 ];
then
break
else
echo "Error type reenter pls"
fi
done


validcount=true
while [ $validcount ]
do
echo "Enter count disk in Raid only eq - 2,3,4,5"
read countdisc
if [ $countdisc -eq 2 ];
then
sudo mdadm --create /dev/md$typeraid --level=$typeraid --raid-devices=$countdisc /dev/sd[b-c]
break
elif [ $countdisc -eq 3 ];
then
sudo mdadm --create /dev/md$typeraid --level=$typeraid --raid-devices=$countdisc /dev/sd[b-d]
break
elif [ $countdisc -eq 4 ];
then
sudo mdadm --create /dev/md$typeraid --level=$typeraid --raid-devices=$countdisc /dev/sd[b-e]
break
elif [ $countdisc -eq 5 ];
then
sudo mdadm --create /dev/md$typeraid --level=$typeraid --raid-devices=$countdisc /dev/sd[b-f]
break
else
echo "Error count reenter pls"
fi
done

sudo mkfs.ext4 /dev/md$typeraid
sudo mkdir /raid$typeraid
sudo mount /dev/md$typeraid /raid$typeraid
sudo echo /dev/md$typeraid /raid$typeraid ext4 defaults 0 0 >> /etc/fstab
sudo mdadm --detail --scan --verbose >> /etc/mdadm.conf


