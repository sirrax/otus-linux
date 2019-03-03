#### Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
`spawn-fcgi` используется для запуска удаленных и локальных `FastCGI` процессов.
Интерфейс FastCGI — клиент-серверный протокол взаимодействия веб-сервера и приложения, дальнейшее развитие технологии CGI. По сравнению с CGI является более производительным и безопасным. В отличие от иных решений, в кластере должен находиться только FastCGI-процесс, а не целый веб-сервер.Почему лучше использовать spawn-fcgi:
* Разделение привилегий без необходимости suid-исполняемого файла или запуска сервера с привилегиями root.
* Возможность отдельного перезапуска как fastcgi приложения, так и сервера
* Возможность запуска в изолированном окружении ( chroot ).
* FastCGI приложение не зависит от используемого веб сервера что дает возможность, использовать различные веб серверы.

Устанавливаем spawn-fcgi и необходимые для него пакеты:
`yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y`
Здесь находится сам Init скрипт, который будет переписываться
`etc/rc.d/init.d/spawn-fcg`
Но перед этим необходимо раскомментировать строки с переменными в `/etc/sysconfig/spawn-fcg`
Получается так:
```
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u apache -g apache -s $SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cgi"
```
Сам юнит файл:
cat /etc/systemd/system/spawn-fcgi.service
```
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
```
Убеждаемся что все успешно работает
`systemctl start spawn-fcgi`
`systemctl status spawn-fcgi`
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m1_l8_systemd/dz2_spawn_fcgi/media/spawn-fcgi.jpg)
