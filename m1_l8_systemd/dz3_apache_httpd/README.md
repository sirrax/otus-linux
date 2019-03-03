#### Дополнить юнит-файл apache httpd возможностью запустить несколько инстансов сервера с разными конфигами

`yum install httpd -y`
Взял за основу базовый файл сервиса
`cp /usr/lib/systemd/system/httpd.service /etc/systemd/system/httpd@.service`
добавил измения в 2-х строчках: `ExecStart` и `ExecReload`
##### httpd@.service:
```
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd
ExecStart=/usr/sbin/httpd -f %i.conf -DFOREGROUND
ExecReload=/usr/sbin/httpd -f %i.conf -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
Файлы конфигурации:
за основу взят файл `/etc/httpd/conf/httpd.conf` в нем только были изменены 2 строки:
ServerRoot "/etc/httpd"
Listen 80
на:
`/etc/httpd/first.conf`
Pidfile "/etc/httpd/run/first.pid"
Listen 8001
`/etc/httpd/second.conf`
Pidfile "/etc/httpd/run/second.pid"
Listen 8080
еще пришлось открыть порт 8001 т.к. по умолчанию для apache открыты :80, 81, 443, 488, 8008, 8009, 8443, 9000
`yum -y install policycoreutils-python`
`semanage port -a -t http_port_t -p tcp 8001`
Старт сервисов и проверка статусов:
`systemctl daemon-reload`
`systemctl start httpd@first.service`
`systemctl start httpd@second.service`
`systemctl status httpd@first.service`
`systemctl status httpd@second.service`
и проверка прослушиваемых портов:
`ss -tnulp | grep httpd`
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m1_l8_systemd/dz3_apache_httpd/media/httpd.png)
