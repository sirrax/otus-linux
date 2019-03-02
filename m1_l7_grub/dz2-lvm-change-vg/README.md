## Установить систему с LVM, после чего переименовать VG
******************************************************************************
##### Первым делом посмотрим текущее состояние системы:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m1_l7_grub/dz2-lvm-change-vg/media/lvm3.jpg)

Вся процедура по переименованию группы lvm,пересоздаем initrd image, чтобы он знал новое название Volume Group и внесению изменений в файлы:
* /etc/fstab
* /etc/default/grub
* /boot/grub2/grub.cfg
выполняется в скрипте который на старте показывает текущее имя VG и запрашивает новое для внесения изменений.


```sh
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
```
##### Проверяем измененое состояние системы после выполнения скрипта:
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m1_l7_grub/dz2-lvm-change-vg/media/lvm4.jpg)

