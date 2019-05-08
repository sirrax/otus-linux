###  DHCP - настройка и обслуживание

Настраиваем `split-dns` взять стенд https://github.com/erlong15/vagrant-bind добавить еще один сервер `client2` завести в зоне `dns.lab` имена:

```
web1 - смотрит на клиент1
web2 - смотрит на клиент2
```

завести еще одну зону `newdns.lab`
завести в ней запись `www` - смотрит на обоих клиентов

настроить  `split-dns`

 `client1` - видит обе зоны, но в зоне `dns.lab` только `web1` 

`client2` видит только `dns.lab`
**********

Настройка выполнена при помощи `ansible-playbook` ниже приведена схема и конфигурационные файлы:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l19_dns/screen/splitdns.png)

