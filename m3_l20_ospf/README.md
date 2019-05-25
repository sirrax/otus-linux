# OSPF

- Поднять три виртуалки
- Объединить их разными vlan

1. Поднять OSPF между машинами на базе Quagga
2. Изобразить ассиметричный роутинг
3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным
*************

Сетевая топология для данного задания:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l20_ospf/screen/ospf_topology.png)

Настройка vlan выполнена по принципу саб интерфейсов. Вся установка осуществляется с помощью конфигурационных файлов через ansible. При поднятии макета и входа в quagga мы видем следующие таблицы маршрутизации по ospf:

`Router R1:`
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l20_ospf/screen/r1_ospf_n.png)

`Router R2:`
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l20_ospf/screen/r2_ospf_n.png)

`Router R3:`
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l20_ospf/screen/r3_ospf_n.png)

Про анализировав данные таблицы видим к примеру что пакеты с роутера `R2` в сеть `10.3.0.0/16` будут ходить через интерфейс `eth2.23` роутера R2. Ответы на эти пакеты с роутера `R3` так же будут возвращаться тем же путем.

Изменим настройки сетевых интерфесов на роутерах. А именно поднимем cost до 500. Что приведет к пересчету метрик в таблицах маршрутизаций роутеров:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l20_ospf/screen/ospf_topology_assim.png)

В данном случае видимследующие таблицы маршрутизации по ospf:

`Router R1:`
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l20_ospf/screen/r1_ospf_assim.png)

`Router R2:`
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l20_ospf/screen/r2_ospf_assim.png)

`Router R3:`
![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l20_ospf/screen/r3_ospf_assim.png)

Про анализировав сейчас данные таблицы видим что пакеты с роутера `R2` в сеть `10.3.0.0/16` будут так же ходить через интерфейс `eth2.23` роутера `R2`. А ответы на эти пакеты с роутера `R3` уже будут возвращаться совершенно другим маршрутом. И ответ на `R2` придет в другой интерфейс отличный от интерфейса который сгенирировал исходящий пакет.