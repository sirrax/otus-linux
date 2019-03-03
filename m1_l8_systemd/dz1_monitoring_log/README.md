#### Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig
Здесь в Vagrant файле задается директория /root которая будет синхронизироваться с папкой на хостовой машине.
```
Vagrant.configure("2") do |config|
 config.vm.box = "centos/7"
 config.vm.box_version = "1804.02"
 $VAR = <<SCRIPT
  pwd
SCRIPT
 $script = <<SCRIPT
 cp /root/timer/watchlog /etc/sysconfig/
 cp /root/timer/watchlog.log /var/log/
 cp /root/timer/watchlog.sh /opt/
 cp /root/timer/watchlog.service /etc/systemd/system/
 cp /root/timer/watchlog.timer /etc/systemd/system/
 systemctl daemon-reload
 systemctl start watchlog.timer
SCRIPT
 config.vm.synced_folder "#{ENV['VAR']}", "/root"
 config.vm.box_check_update = false
 config.vm.provision "shell", inline: $script
end
```
*****************************************************
Юнит для таймера: watchlog.timer
cat /etc/systemd/system/watchlog.timer 
```
[Unit]
Description=Run watchlog script every 5 second
[Timer]
OnUnitActiveSec=5
Unit=watchlog.service
[Install]
WantedBy=multi-user.target
```
******************************************************
Юнит для сервиса watchlog.service
cat /etc/systemd/system/watchlog.service 
```
[Unit]
Description=My watchlog service
[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
```
**************************************************
Файл с конфигурацией для сервиса в директории /etc/sysconfig - из неё сервис будет брать необходимые переменные
cat /etc/sysconfig/watchlog 
```
WORD="ALERT"
LOG=/var/log/watchlog.log
```
************************************************************
Файл с тестовым логом плюс ключевое слово ‘ALERT’
cat /var/log/watchlog.log 
```
dddldl
ALERT
LLLK
```
***************************************************************
cat /opt/watchlog.sh 
```
#!/bin/bash
WORD=$1
LOG=$2
DATE=`date`
if grep $WORD $LOG &> /dev/null
then
	logger "$DATE: I found word, Master!"
# Команда logger отправляет лог в системный журнал
else
	exit 0
fi
```
*************************************************************
