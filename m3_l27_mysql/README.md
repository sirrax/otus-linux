# Mysql развернуть базу из дампа и настроить репликацию

Равертование стенда выполнено через `vagrant+ansible`. В котором происходит установка `Percona` из репозитария,а так же настройка конфигураций `master` и `slave`. И смена пароля `root` для входа в `mysql`.

GTID (global transaction identifier) репликация
(GTID) является уникальным идентификатором, создаваемым и связанным с каждой транзакцией, когда это фиксируется на сервере источника (ведущее устройство). Этот идентификатор уникален не только для сервера, на котором он произошел, но и уникален через все серверы в данной установке репликации. 

### Некоторые пункты настройки конфигурации:    

`binlog-format = "MIXED"`

Бывает трех видов — `STATEMENT`, `MIXED` и `ROW`

`Statement` пишет в бинлог по сути sql запросы. Преимущества — старый формат, оттестированный, лог небольшой, можно посмотреть запросы. Недостатки — проблемы с функциями и триггерами, запросы вида update user set a=1 order by rand(), а так же еще некоторые могут некорректно отрабатываться.

`ROW`  — пишет в логи измененные бинарные данные. Преимущества — отлично логируются все виды запросов. Недостатки — огромный лог.

`Mixed` — промежуточный формат, который старается использовать statement, когда возможно, а когда нет — row. Говорят, что глючит на каких то очень сложных запросах. 

`gtid-mode = On` включает GTID mode репликацию

`server-id = 1` Уникальный номер для каждого сервера

`enforce-gtid-consistency = On` Запрещает все, что может поломать транзакции. 

`gtid-mode=on` Собственно и включает ту самую GTID mode репликацию

`log-slave-updates = On` Указывает подчиненному серверу,чтобы тот вел записи об обновлениях, происходящих на подчиненном сервере, в двоичном журнале. По умолчанию эта опция выключена. Ее следует включить, если требуется организовать подчиненные серверы в гирляндную цепь.

`replicate-do-db = bet` Указываем что именно мы будем реплицировать

### Создадим пользователя для репликации и даем ему права на эту самую репликацию:

```
mysql> CREATE USER 'repl'@'%' IDENTIFIED BY '!OtusLinux2019';
mysql> SELECT user,host FROM mysql.user where user='repl';
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY '!OtusLinux2019';
```

На этом настройка мастера закончена.

### Настройка слейва

подключаем и запускаем слейв:
```
mysql> CHANGE MASTER TO MASTER_HOST = "10.0.10.2", MASTER_PORT = 3306, MASTER_USER = "repl", MASTER_PASSWORD = "!OtusLinux2019", MASTER_AUTO_POSITION = 1;
mysql> START SLAVE;
mysql> SHOW SLAVE STATUS\G
```

Статус slave:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l27_mysql/screen/slave-status.png)


Ниже приведен скрин таблиц БД bet, поля таблицы bookmaker до и после добавления строк. Master:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l27_mysql/screen/master.png)


Cкрин таблиц БД bet, поля таблицы bookmaker до и после добавления строк. Slave:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l27_mysql/screen/slave.png)