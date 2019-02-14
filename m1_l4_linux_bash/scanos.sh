#!/bin/bash

logfile="./scan-os.txt"

os_id=""

echo "" > $logfile
echo "Type OS    IP HOST   " > $logfile

type_os(){
	if [ $1 -eq 64 ];
        then
            	os_id="Linux  "
        elif [ $1 -eq 128 ];
        then
            	os_id="Windows"
        elif [ $1 -eq 255 ];
        then
            	os_id="Cisco  "
        else
            	os_id="unknown"
        fi

echo "$os_id   $2   " >> $logfile
return 0

}

oct1=$(ip addr|grep "inet "| grep -v '127.0.0.1' | awk '{print $2}' | sed 's/\./ /'| sed 's/\./ /'| sed 's/\./ /'|sed 's/\// /'| awk '{print $1}')
oct2=$(ip addr|grep "inet "| grep -v '127.0.0.1' | awk '{print $2}' | sed 's/\./ /'| sed 's/\./ /'| sed 's/\./ /'|sed 's/\// /'| awk '{print $2}')
oct3=$(ip addr|grep "inet "| grep -v '127.0.0.1' | awk '{print $2}' | sed 's/\./ /'| sed 's/\./ /'| sed 's/\./ /'|sed 's/\// /'| awk '{print $3}')

    for host in {1..16}
    do
      	host_ip=$oct1.$oct2.$oct3.$host
        echo $host_ip
        ttl=`ping -c 1 $host_ip | awk '{print $6}'| grep ttl | sed 's/ttl=//'`
#        name=`nslookup $host_ip | grep "name = " | sed 's/name = //' | awk '{print $2}'`
        if [ $ttl > 0 ];
        then
            	type_os $ttl $host_ip

        fi

	clear
	cat ~/scan-os.txt
done

exit 0
