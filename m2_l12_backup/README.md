# Настраиваем бэкапы

Настроить стенд Vagrant с двумя виртуальными машинами server и client.

Настроить политику бэкапа директории /etc с клиента:

1) Полный бэкап - раз в день

2) Инкрементальный - каждые 10 минут

3) Дифференциальный - каждые 30 минут

Запустить систему на два часа. Для сдачи ДЗ приложить `list jobs, list files jobid=<id>` и сами конфиги bacula-*

В данном задании вагрантом разворачивались только 2 машины без предустановки `bacula` и `mysql` Я решил все это установить и настроить вручную согласно конспекту.

В прилагаемом файле `list_jobs.txt` решение задания начинается с `jobid(28)` Т.е. Полный бэкап, инкрементный - каждые 10 мин и дифференциальный - каждые 30 минут

Для данной реализации в секцию `schedule` было прописанно следующее: 

```
Schedule {
  Name = "DailyFull2"
  Run = Full Daily at 18:45
  Run = Differential hourly at 0:05
  Run = Differential hourly at 0:35
  Run = Incremental hourly at 0:00
  Run = Incremental hourly at 0:10
  Run = Incremental hourly at 0:20
  Run = Incremental hourly at 0:30
  Run = Incremental hourly at 0:40
  Run = Incremental hourly at 0:50  
}
```

Команды для получения отчетов по работ:

```
echo "list jobs" | bconsole > /root/list_jobs.txt

echo "list files jobid=28" | bconsole > /root/list_files_jobid_28.txt
echo "list files jobid=32" | bconsole > /root/list_files_jobid_32.txt
echo "list files jobid=35" | bconsole > /root/list_files_jobid_35.txt
echo "list files jobid=43" | bconsole > /root/list_files_jobid_43.txt
echo "list files jobid=44" | bconsole > /root/list_files_jobid_44.txt
```
