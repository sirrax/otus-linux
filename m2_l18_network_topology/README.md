
# Архитектура сетей.

### Теоретическая часть
- Найти свободные подсети
- Посчитать сколько узлов в каждой подсети, включая свободные
- Указать broadcast адрес для каждой подсети
- проверить нет ли ошибок при разбиении

### Практическая часть
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
- при нехватке сетевых интервейсов добавить по несколько адресов на интерфейс

**********************************************************************************************************************

Ниже приведена сетевая топология макета с адресацией:

![](https://raw.githubusercontent.com/sirrax/otus-linux/master/m2_l18_network_topology/screen/networktopology.png)

### office1

192.168.2.0/26 - dev

```
Netmask:          255.255.255.192 = 26 
Address net:      192.168.2.0
Firstaddress:     192.168.2.1          
Lastaddress:      192.168.2.62         
Broadcastaddress: 192.168.2.63         
Counthosts:       62                    
```

192.168.2.64/26 - test servers

```
Netmask:         255.255.255.192 = 26 
Address net:     192.168.2.64        
Firstaddress:    192.168.2.65       
Lastaddress:     192.168.2.126       
Broadcast:       192.168.2.127       
Counthosts:      62                   
```

192.168.2.128/26 - managers

```
Netmask:        255.255.255.192 = 26
Address net:    192.168.2.128        
Firstaddress:   192.168.2.129        
Lastaddress:    192.168.2.190       
Broadcast:      192.168.2.191       
Counthosts:     62                    
```

192.168.2.192/26 - office hardware

```       
Netmask:       255.255.255.192 = 26 
Address net:   192.168.2.192 
Firstaddress:  192.168.2.193        
Lastaddress:   192.168.2.254       
Broadcast:     192.168.2.255        
Counthosts:    62                   
```

******************************************************************

### office2

192.168.1.0/25 - dev

```    
Netmask:       255.255.255.128 = 25 
Address net:   192.168.1.0      
Firstaddress:  192.168.1.1          
Lastaddress:   192.168.1.126       
Broadcast:     192.168.1.127        
Counthosts:    126                  
```

192.168.1.128/26 - test servers

```
Netmask:       255.255.255.192 = 26 
Address net:   192.168.1.128 
Firstaddress:  192.168.1.129       
Lastaddress:   192.168.1.190        
Broadcast:     192.168.1.191       
Counthosts:    62                    
```

192.168.1.192/26 - office hardware

```
Netmask:       255.255.255.192 = 26 
Address net:   192.168.1.192
Firstaddress:  192.168.1.193
Lastaddress:   192.168.1.254       
Broadcast:     192.168.1.255       
Counthosts:    62                  
```

***************************************************************

### central

192.168.0.0/28 - directors

```
Netmask:       255.255.255.240 = 28 
Address net:   192.168.0.0  
Firstaddress:  192.168.0.1         
Lastaddress:   192.168.0.14         
Broadcast:     192.168.0.15         
Counthosts:    14                 
```

192.168.0.32/28 - office hardware

```
Netmask:       255.255.255.240 = 28 
Address net:   192.168.0.32   
Firstaddress:  192.168.0.33         
Lastaddress:   192.168.0.46         
Broadcast:     192.168.0.47         
Counthosts:    14                    
```

192.168.0.64/26 - wifi

```
Netmask:       255.255.255.192 = 26 
Address net:   192.168.0.64
Firstaddress:  192.168.0.65        
Lastaddress:   192.168.0.126       
Broadcast:     192.168.0.127       
Counthosts:    62                   
```