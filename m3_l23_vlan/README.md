# Сетевые пакеты. VLAN'ы. LACP

Строим бонды и вланы
в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами
в internal сети testLAN

```
- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1
- testServer2- 10.10.10.1
```

равести вланами

```
testClient1 <-> testServer1
testClient2 <-> testServer2
```

между centralRouter и inetRouter
"пробросить" 2 линка (общая inernal сеть) и объединить их в бонд
проверить работу c отключением интерфейсов
*************

Сетевая топология для данного задания:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l23_vlan/screen/vlan.png)

настройка vlan и bonding выполнена конфигурационными файлами через ansible

### Проверка настройки Vlan:

после `ping testClient1 --> testRouter1` в arp таблице на `testClient1` появляестя мак адрес `testRouter1`

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l23_vlan/screen/client1.png)

после `ping testClient2 --> testRouter2` в arp таблице на `testClient1` появляестя мак адрес `testRouter2`

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l23_vlan/screen/client2.png)

как мы видим на хостах с одинаковым `ip 10.10.10.1` но в разных `vlan` разными являются и мак адреса.


### Проверка настройки bonding  c отключением интерфейсов:

при `ping inetRouter --> centralL3` на `centralL3` активным портом сначала являестя `eth1`, затем после отключения этого порта активным становится: `eth2`

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l23_vlan/screen/downport.png)

на стороне `inetRouter` при смене активного порта на `centralL3` наблюдается непрерывность `ping` с небольшой разовой задержкой:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m3_l23_vlan/screen/ping.png)

