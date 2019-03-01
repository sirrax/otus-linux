# Попасть в систему без пароля несколькими способами
******************************************************************************
### Cпособ 1
Основан на подмене процесса с которого стартует ядро `init=/bin/sh` перезагружаемся с установленными параметрами `ctrl+x`

![](https://github.com/sirrax/otus-linux/blob/master/m1_l7_grub2/1_change_password/screen/1_1_variant.png)

Попадаем в систему. Рутовая файловая система при этом монтируется в режиме Read-Only
перемонтировать ее в режим Read-Write можно воспользоваться командой:
```sh
sh-4.2#	mount -o remount,rw /
```
Меняем пароль от `root`
```sh
sh-4.2#	passwd
```
Что же, пароль сменен, но при следующей загрузке система обеспечения безопасности SELinux обнаружит факт модификации системного файла, поэтому следует сообщить ей о необходимости обновления контекстов всех элементов корневой файловой системы. Для этого в корневой файловой системе должен быть создан скрытый файл с именем `.autorelabel` с помощью следующей команды:
```sh
sh-4.2# touch /.autorelabel
```
перемонтируем обратно в Read-Only
```sh
sh-4.2# mount -o remount,ro /
```
![](https://github.com/sirrax/otus-linux/blob/master/m1_l7_grub2/1_change_password/screen/1_2_variant.png)


перезагружаемся с новым паролем root
**********************************************************************************
### Способ 2
Хотя старый способ прерывания процесса загрузки `init=/bin/sh` все еще работает, он больше не рекомендуется. Systemd использует `rd.break` для прерывания загрузки
`rd.break enforcing=0`

![](https://github.com/sirrax/otus-linux/blob/master/m1_l7_grub2/1_change_password/screen/2_1_variant.png)

на счет `enforcing=0` - существуют три режима работы SELinux, которые могут быть указаны в соответствующем параметре конфигурационного файла:
Один из них Enforcing. Выбор этого значения приводит к применению текущей политики SELinux, при этом будут блокироваться все действия, нарушающие политику. 
```sh
switch_root:/# mount -o remount,rw /sysroot
switch_root:/# chroot /sysroot
sh-4.2# echo “newroot111” | passwd --stdin root
sh-4.2# touch /.autorelabel
sh-4.2# reboot -f
```
![](https://github.com/sirrax/otus-linux/blob/master/m1_l7_grub2/1_change_password/screen/2_3_variant.png)

*******************************************************************************
### Способ 3
Заменяем `ro` на `rw init=/sysroot/bin/sh`

![](https://github.com/sirrax/otus-linux/blob/master/m1_l7_grub2/1_change_password/screen/3_1_variant.png)

файловая система сразу смонтирована в режим Read-Write
```sh
:/# chroot /sysroot
:/# echo “111” | passwd --stdin root
:/# touch /.autorelabel
:/# reboot -f
```

![](https://github.com/sirrax/otus-linux/blob/master/m1_l7_grub2/1_change_password/screen/3_2_variant.png)


