#!/bin/bash


echo -e  "PID \t |MEM \t |STAT \t |TIME \t |CMD"
echo -e  "    \t |%*10\t |     \t |s/100\t |   "
array=($(ls -al /proc/ | awk {'print $9'}))
# echo "Array size: ${#array[*]}"  # Выводим размер массива
arraypid=()

for item in ${array[*]}
 do
 if [ -n "$item" ] && [ "$item" -eq "$item" ] 2>/dev/null;
 then
     	arraypid+=( $item )
 fi
 done

globmem=( $(cat /proc/meminfo | grep MemTotal | awk {'print $2'}) )

for pid in ${arraypid[*]}
do

if [ $(cat /proc/$pid/status 2>/dev/null | grep VmRSS | awk {'print $2'} ) ];
then
        memproc=( $(cat /proc/$pid/status | grep VmRSS | awk {'print $2'}) )
        statproc=( $(cat /proc/$pid/status | grep Stat | awk {'print $2'}) )
        procent=$(($memproc*1000/$globmem))
        time=( $(cat /proc/$pid/stat | awk {'print $14'}) + $(cat /proc/$pid/stat | awk {'print $15'}))
#	cmd=( $(cat /proc/$pid/cmdline))
        cmd=$(tr -d '\0' <  /proc/$pid/cmdline)
        echo -e  "$pid \t |$procent \t |$statproc \t |$time \t |$cmd"
fi
done

