# Bacula

Система резервирования данных Bacula состоит из четырёх основных элементов: `Director Daemon`, `Storage Daemon`, `File Daemon` и `Bacula Console`. Все эти элементы реализованы в виде самостоятельных приложений.

`Director Daemon (DD)` – это центральный элемент системы, осуществляющий управление её остальными компонентами. В его задачи входит управление процессом резервирования/восстановления данных, обеспечение интерфейса управления для администраторов и многое другое. Говоря проще – это диспетчер, который инициирует все процессы и отслеживает ход их выполнения.

`Storage Daemon (SD)` – приложение, отвечающее за чтение/запись данных непосредственно на устройства хранения информации. Принимает управляющие команды от DD, а также резервируемые данные от/к File Daemon.

`File Daemon (FD)` – этот элемент ещё можно назвать Агентом. Ведь именно он работает в рамках операционной системы, данные которой необходимо резервировать. File Daemon выполняет всю рутину, осуществляя обращение к резервируемым файлам и их дальнейшую передачу к SD. Также на стороне FD выполняется шифрование резервных копий, если это определено конфигурацией.

`Bacula Console (BC)` – интерфейс администратора сиcтемы. По своей сути, это командный интерпретатор для управления Bacula. Строго говоря, Bacula Console может быть расширена с помощью графических систем управления, которые, как правило, являются всего лишь надстройкой над BC. К таким системам можно отнести Tray Monitor и Bat. Первая устанавливается на компьютере администратора системы и осуществляет наблюдение за работой системы резервирования, а вторая обеспечивает возможность управления посредством графического интерфейса.

`Bacula Catalog` – база данных, в которой хранятся сведения обо всех зарезервированных файлах и их местонахождении в резервных копиях. Каталог необходим для обеспечения эффективной адресации к требуемым файлам. Поддерживаются MySql, PostgreSql и SqLite.

Такое структурное деление позволяет организовать очень гибкую систему резервирования, когда Storage Daemon разворачивается на выделенном сервере с несколькими устройствами хранения данных. Также Bacula Director может управлять несколькими экземплярами SD, обеспечивая резервирование части данных на одно устройство хранения, а части – на другое.
Если ваша инфраструктура включает в себя всего один сервер, то все необходимые элементы могут быть развёрнуты на нём

Прежде, чем начать настройку системы, необходимо определить основные термины, используемые в системе Bacula.

`Задача (Job)` – операция создания архива файлов или восстановления информации с архиву.

`Том (Volume)` – единица хранения информации, представляет собой отдельный файл, магнитную ленту, CD, DVD. Один том может содержать несколько задач, или одна задача может занимать несколько томов.

`Пул (Pool)` – группа томов.

`Набор файлов (FileSet)` – списки директорий и отдельных файлов, которые должны быть заархивированы. Могут содержать регулярные виражения.

`Уведомление (Messages)` – информация о состоянии компонентов Bacula и задач. Могут передаваться по электронной почте, либо записываться в журнал.

`Файл начальной загрузки (bootstrap)` – специальный текстовый файл, содержащий информацию об архивированных файлах и томах. Этот файл используется во время операции восстановления.

Типы резервного копирования

`Полное копирование (Full backup)` — производится копирование данных в полном объеме. Самый надежный способ копирования. В случае выхода из строя свежей копии данные можно восстановить из предыдущих копий. Эффективный и быстрый метод восстановления. Недостаток — требует носителей большого объема и длительного времени выполнения.

`Дифференциальное копирование (Differential backup)` — копируются файлы, изменившиеся после последнего Full backup. Данные копируются «нарастающим итогом», так что последняя копия всегда будет содержать все изменения с момента последнего `Full backup`. Выполняется быстрее чем `Full backup`, при повреждении одной из копий не приводит к потере всех данных за последующий и предыдущий период (при наличии живого `Full backup`). Так или иначе требуется регулярный `Full backup` и бывает что последняя копия (при длительной работе) по размеру изменений приближается к `Full backup`.

`Инкрементное копирование (Incremental backup)` — выполняется копирование только информации, измененной после выполнения предыдущего Incremental backup. Это самый быстрый метод резервирования и занимает меньше всего объема, но и самый ненадежный метод. В случае повреждения одной из копий все последующие становятся шлаком. И соответственно при повреждении Full backup все становиться негодным. Восстановление данных занимает продолжительное время.

Предпочтителен Full backup но это»дорого» обходиться. Если данные не очень ценны или ресурсов мало то используйте Incremental backup. Differential backup это компромисс, но бывает что последняя копия приближается объему полного копирования так что следите за ним. Есть еще и другие типы копирования такие как VirtualFull и Base вы можете познакомиться с ними сами.

Bacula поддерживает следующие типы сообщений:
информационное (info)
предупреждение (warning)
ошибка (error)
критическая ошибка (fatal)
остановка (terminate)
перечень пропущенных файлов (skipped);
список файлов, сохраненных без ошибок (saved)
список файлов, которые не удалось сохранить (notsaved)
перечень восстановленных файлов (restored)
потребность подключить новый том (mount)
ошибка авторизации (security)
все типы (all).

Для отправки сообщений Bacula использует собственный средство – bsmtp, который может отправлять сообщения не только локальным пользователям, но и на удаленный smtp-сервер.

## 1.Установка Bacula

Установка Bacula Director, Bacula Storage Daemon, Bacula File Daemon, bacula-console на Bacula-сервере

Ubuntu: `apt-get install bacula`

При установке будет предложено настроить базу данных bacula
При подтверждении создания будет создана база данных с именем bacula, mysql пользователь bacula с доступом к этой базе и с паролем, указанным Вами
Эти данные автоматичски пропишутся в секцию Catalog { } В файле
`/etc/bacula/bacula-dir.conf` после успешной настройки проверяем наличие базы и таблиц в ней `mysql -u root -p  -e "use bacula; show tables"`

Centos
`yum install bacula-director-mysql bacula-console bacula-client bacula-storage-mysql`

В отличии от Ubuntu в Centos нужно вручную создавать базу bacula и таблицы в ней, пользователя с доступом к этой базе. Для этого воспользуемся штатными скриптами
В данном случаем используем рутовый MySQL-аакаунт

`/usr/libexec/bacula/grant_mysql_privileges -u root -p`

`/usr/libexec/bacula/create_mysql_database -u root -p`

`/usr/libexec/bacula/make_mysql_tables -u root -p`

`/usr/libexec/bacula/grant_bacula_privileges -u root -p`

Задаем пароль для пользователя bacula

`mysql -u root -p`

`mysql> UPDATE mysql.user SET password=PASSWORD("baculapassword") WHERE user='bacula';`

`mysql> flush privileges;`

### 2. Настройка Bacula Director Daemon

Конфигурационный файл Директора `bacula-dir.conf`, как и остальные конфигурационных файлов Bacula, состоит из логических разделов, описывающих отдельные ресурсы. Раздел каждого ресурса взят в фигурные скобки {}. Строки с комментариями начинаются с символа #

В ключах регистр и пробелы полностью игнорируются. Поэтому ключи: name, Name, и N a m e полностью индентичны. Пробелы до и после знака «равно» игнорируются. Если «значение» содержит пробелы, оно должно быть заключено в двойные кавычки, а пробелы должны быть экранированы обратным слешем.

`cp /etc/bacula/bacula-dir.conf /etc/bacula/bacula-dir.conf~`

`vim /etc/bacula/bacula-dir.conf`

```
Director {                            
  Name = bacula-dir                      # Имя директора
  DIRport = 9101                         # Порт который слушает DIR
  QueryFile = "/usr/libexec/bacula/query.sql"
  WorkingDirectory = "/var/spool/bacula" # Директория, в которой лежат статус-файлы Директора
  PidDirectory = "/var/run"
  Maximum Concurrent Jobs = 1            # Максимальное количество параллельных заданий.Не рекомендуется одновременно запускать более одного задания
  Password = "directorpassword"          # Пароль директора (для привилегированной консоли - bconsole)
  Messages = Daemon
}
```

Этот ресурс хранит задачу-шаблон, которую потом могут расширять и изменять Job-ресурсы

Дефолтное задание, "шаблон"

```
JobDefs {
  Name = "DefaultJob"                           # Имя задания
  Type = Backup                                 # Тип (backup, restore и т.д.)
  Level = Differential                          # Уровень бэкапа (Full, Incremental,
  Differential и т.п)
  Client = localhost-fd                         # Имя клиента
  FileSet = "localhost-fs"                      # Набора файлов для сохранения
  Schedule = "WeeklyDiffCycle"                  # Расписание, по которому 
  запускается создание бекапов
  Storage = File                                # Файловое хранилище
  Messages = Standard                           # Поведение уведомлений
  Pool = File                                   # Пул, куда будем писать бэкапы.Если мы хотиим сделать отдельный пул для каждого клиента, или использовать префиксы, тогда пул указывается в Job для каждого клиента переопределяя тем самым эту настройку
  Priority = 10                                # Приоритет. Давая заданиям приоритеты от 1 (max) до 10 (min), можно регулировать последовательность выполнения.
  Write Bootstrap = "/var/spool/bacula/%c.bsr"  # Файл хранит информацию откуда извлекать данные при восстановлении

}
```

По умолчанию, одновременно запускается только 1 задание, остальные ставятся в очередь. Это регулируется параметром `Maximum Concurrent Jobs = number`, которое офф. мануал не рекомендует ставить больше еденицы.

```
Job {
  Name = "BackupCatalog"
  JobDefs = "DefaultJob"
  Level = Full
  FileSet="Catalog"
  Schedule = "WeeklyCycleAfterBackup"
  # This creates an ASCII copy of the catalog
  # Arguments to make_catalog_backup.pl are:
  #  make_catalog_backup.pl <catalog-name>
  RunBeforeJob = "/usr/libexec/bacula/make_catalog_backup.pl MyCatalog"
  # This deletes the copy of the catalog
  RunAfterJob  = "/usr/libexec/bacula/delete_catalog_backup"
  Write Bootstrap = "/var/spool/bacula/%n.bsr"
  Priority = 11                   # run after main backup
}

FileSet {
  Name = "Catalog"
  Include {
    Options {
      signature = MD5
    }
    File = "/var/spool/bacula/bacula.sql"
  }
}
```

Здесь указываем путь и учетные данные для доступа к базе данных. На Ubuntu создается автоматически

```
Catalog {
  Name = MyCatalog
  dbname = "bacula"; dbuser = "bacula"; dbpassword = "baculapassword"
}
Job {
  Name = "RestoreFiles"
  Type = Restore
  Client=localhost-fd
  FileSet="localhost-fs"
  Storage = File
  Pool = Default
  Messages = Standard
  Where = /bacula/restore
}
```

Описывает, когда будет запускаться Задание (Job) по выполению бекапа. Так же скорее всего будет свой для каждого клиента

```
Schedule {
 Name = "WeeklyDiffCycle"
#  Run = Full 1st sun at 23:05
#  Run = Differential 2nd-5th sun at 23:05
#  Run = Incremental mon-sat at 23:05
 Run = Full sun at 23:05
 Run = Differential mon-sat at 23:05
}

Schedule {
  Name = "DailyFull"
  Run = Full sun-sat at 23:05
}

# This schedule does the catalog. It starts after the WeeklyCycle
Schedule {
  Name = "WeeklyCycleAfterBackup"
  Run = Full sun-sat at 23:10
}

# Definition of file storage device
Storage {
  Name = File                                   # имя хранилища 
  Address = <Externak-IP-address-Storage-ser ver>  # fqdn имя сервера ИЛИ ВНЕШНИЙ IP-адрес Storage-демона.Do not use "localhost" here. В данном случае Bacula Director и Bacula Storage Daemon запускаются на одном сервере
  SDPort = 9103                                 # порт оставляем стандартный
  Password = "storagepassword"                  #  пароль хранилища
  Device = FileStorage                          # имя устройства хранения, которое описано в файле bacula-sd.conf
  Media Type = File                             # Указывает, устройство хранения - это файл (то бишь - не лента).Также должно совпадать с тем,что описано в файле bacula-sd.conf
}

# Reasonable message delivery -- send most everything to email address
#  and to the console
Messages {
  Name = Standard                               # Имя Отправителя
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: %t %e of %c %l\" %r"                # Команда отправки сообщений
  operatorcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula: Intervention needed for %j\" %r"
  mail = pol_mtg@email = all, !skipped            # Отправлять на этот почтовый адрес все сообщения, за исключением пропущенных
  operator = pol_mtg@email = mount
  console = all, !skipped, !saved                       # Выводить на консоль сообщения за исключением пропущенных и сохраненных
  append = "/var/spool/bacula/log" = all, !skipped      # Записывать сообщения в файл, за исключением пропущенных
  catalog = all
}

# Message delivery for daemon messages (no job).
Messages {
  Name = Daemon
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula daemon message\" %r"
  mail = pol_mtg@email = all, !skipped
  console = all, !skipped, !saved
  append = "/var/log/bacula.log" = all, !skipped
}

# Определение пула по умолчанию
# Pool - отдельное описание для каждого набора томов (лент, DVD, файлов)
# используется при описании задания для указания пула из которого
# должен быть взят том. В каждый пул может входить несколько томов.
Pool {
  Name = Default
  Pool Type = Backup
  Recycle = yes                                   
  AutoPrune = yes                             
  Volume Retention = 32 days         
}

# Определения пула файлов
Pool {
  Name = File
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 32 days         # how long store backup files
  Maximum Volume Jobs = 1            # one task = one file
  Maximum Volumes = 32               # Limit number of Volumes in Pool
  LabelFormat = "File-MyCatalog"
}

# Определения пула Scratch
# Scratch зарезервировано для пула запасных том - при необходимости
# система самостоятельно переводит том из него в требуемый пул
Pool {
  Name = Scratch
  Pool Type = Backup
}

# Ограниченная консоль, используемая в трей мониторе для получения
# статуса директора DIR
#
Console {
  Name = bacula-mon
  Password = "consolepassword"
  CommandACL = status, .status
}
```

Для каждого компьютера, файлы которого архивируются, мы будем создавать отдельный ресурс `Client`, `FileSet`, `Pool`, `Job Backup` и `Job Restore`( Storage будет один для всех клиентов) В конфигурационном файле вы должны описать к примеру работу для одного клиента несколькими переменными такими как `Job`, `Pool`, `Client`, `FileSet`, `Storage`, `Schedule`. Каждой переменной присваивается понятное имя и далее в Job указываются необходимые имена переменных чтобы это было законченной задачей и могло работать согласно вашим указаниям. Рабочий клиент состоит из 6ти элементов:

`Job (Работа)` — это объект которому присваивают понятное имя и это совокупность вещей и указаний как, кого, что и куда будем резервировать. По его имени эту задачу можно определять, исполнять и вызывать из консоли.

`Client (Клиент)` — здесь указывается имя клиента для этой работы, сам клиент и его имя определяется отдельно.

`FileSet (Набор файлов)` — указывается набор файлов\директорий и их исключений для этой работы, сам набор файлов и его имя определяется отдельно.

`Schedule (Планировщик)` — планировщик для этой работы, в нем описываем периодичность работы и перераспределение ресурсов это когда делать полное копирование когда дифференциальное и тд. Сам планировщик и его имя определяется отдельно и вы можете для удобства завести отдельный конфиг.

`Storage (Хранилище)` — Определение устройства хранения файлов для этой работы. В этом хранилище есть секция Device (см по имени) в котором есть указание, где будем хранить резервные копии.

`Pool (Пул)` — определяем для работы нужный нам Пул это отдельное описание для каждого набора томов (лент, DVD, файлов)


Это приводит разрастания конфигурационного файла до довольно больших размеров, поэтому удобнее описывать эти ресурсы в отдельном файле, который включается в `bacula-dir.conf` с помощью директивы `@`. Например, ресурсы `Client, FileSet, Pool, Job Backup и Job Restore` для сервера, на котором установлена система Bacula, можно поместить в файл `localhost.conf`, и включить его в `bacula-dir.conf`:
`@/etc/bacula/conf.d/localhost.conf` У каждого клиента будет свой пул – метки на тома в этом пуле будут выставляться согласно меткам для каждого пула клиента автоматически(опция LabelFormat в пуле клиента).Это возможно благодаря опции
`LabelMedia = yes`; в файле `bacula-sd.conf` т.е нет необходимости вручную размечать тома

Для того,чтобы не повторять одни и теже опции в задании для всех клиентов

```
Type = Backup
Storage = File
Messages = Standard
Priority = 10
Используется шаблон DefaultJob
Параметры, которые меняются – уникальны для каждого клиента
Client
FileSet
Pool
Job
Job Restore
```

Все шаблоны расписаний описаны в файле `bacula-dir.conf`, эти шаблоны применяются при создании Job-задании бекапа клиента

`mkdir /etc/bacula/conf.d`

Создаем каталоги для сохранения бекапа всех клиентов и для восстановления из бекапа локального сервера

`mkdir -p /bacula/{backup,restore}`

`chown -R bacula:bacula /bacula/`

`chgrp -R bacula /etc/bacula/conf.d/`

`vim /etc/bacula/conf.d/localhost.conf`

Описывает задание по созданию бекапа

```
Job {
Name = "BackupLocalhostFD" # имя задания
JobDefs = "DefaultJob" # Используем шаблон
Client = localhost-fd     # имя клиента
FileSet="localhost-fs"    # имя файл-сета(там рассказано что бекапить, а что не бекапить)
Pool = LocalhostFDPool    # имя пула(для разных клиентов разные пулы томов(volume) куда пишутся сами бекапы)
Schedule = "WeeklyDiffCycle" # расписание бекапа,определенное в файле bacula-dir.conf
#ClientRunBeforeJob = "/root/sh/before_bg_db_backup.sh"  # скрипт запускающийся ДО выполнения задания (путь до скрипта  -это путь НА КЛИЕНТЕ!)
#ClientRunAfterJob = "/root/sh/after_bg_db_backup.sh" # скрипт запускающийся ПОСЛЕ выполнения задания
# в этом файле содержится информация о том, какие файлы должны будут
# востанавливаться, на каком вольюме находятся файлы,
# где конкретно они находятся - это очень важные файлы, их нужно бэкапить.
# Этот файл позволит восстановить копии в случае каких-либо проблем с sql-каталогом
Write Bootstrap = "/var/spool/bacula/localhost-fd.bsr"
}

# Шаблон восстановления
# Стандартный шаблон восстановления, который может изменен консольной программой
# Только одно такое задание необходима для всех Job/Client/Storage...
Job {
  Name = "RestoreLocalhostFiles"
  Type = Restore
  Client=localhost-fd
  FileSet="localhost-fs"
  Storage = File
  Pool = LocalhostFDPool
  Messages = Standard
## Это путь НА КЛИЕНТЕ, куда будут восстановлены файлы. Если он пустой
## или /  - файлы восстановятся на свои места и перазапишут (!!!) существующие файлы
## Должен начинаться со слеша.
  Where = /bacula/restore
}

# Описывает, какие файлы будут бекапится с клиента. У каждой клиентской машины будет свой FileSet
Name = "localhost-fs"
  Include {
    Options {
      signature = MD5
      Compression=GZIP
    }
# При наличии в пути пробелов нужно использовать двойные кавычки
# Слэш нужно всегда экранировать, или можно использовать бэкслэш.
File = /etc
File = /usr/local/nagios
File = /usr/lib64/nagios/plugins
File = /var/lib/cacti
File = /usr/share/cacti
File = /var/www/html
File = /home/users
 }
Exclude {
File = /home/users/kamaok/kamaok.org.ua/wp-content/backupwordpress-d0ae06f24f-backups
 }
}

# Описывает физическую машину - клиента, которая будет бекапится

Client {
Name = localhost-fd           # имя
Address = 127.0.0.1        # ip адрес клиента
FDPort = 9102              # порт, который клиент слушает
Catalog = MyCatalog        # имя mysql базы данных Bacula
Password = "localclientpassword"          # пароль для FileDaemon, указанный в файле backup-fd.conf
File Retention = 32 days   # период, в течении которого информация о ФАЙЛАХ хранится в базе данных, по истечению периода эта информация  удаляется(но не сам$
Job Retention = 32 days    # тоже самое, только для ЗАДАНИЙ
AutoPrune = yes            # удалять записи из каталога(бд mysql) старше вышеуказанных значений
}
Pool {
Name = LocalhostFDPool        # имя пула, указывается в заданиях резервного копирования
Pool Type = Backup         # тип пула (может быть только Backup)
Recycle = yes              # повторно использовать тома(сначала пишет в 1-ый, потом в 2-ой,потом 3-й, 3-й закончился - снова в 1-й)
AutoPrune = yes            # удалять записи из bacula catalog(из mysql базы бакулы) старше нижеуказанных значений
  # Период в течении которого информация о томах(volumes)
  # хранится в базе данных, по истечению периода эта информация удаляется.
  # То есть можно восстановить файлы за Х дней
Volume Retention = 1 months

#Это будет означать, что в рамках одного носителя данных могут быть размещены резервные данные, пол$
#Носитель данных – это устройство, на которое непосредственно записываются данные (оптические диски$
#Если размер созданной резервной копии много меньше размера носителя, то имеет смысл сохранить на н$
#Но если мы говорим о файлах, то желательно придерживаться правила "один файл – одна копия", т.е. в$
#Для каждого последующего будут создаваться новые файлы.
Maximum Volume Jobs = 1

# максимальное количество томов в пуле
Maximum Volumes = 32
  # с каких символов начинается имя тома. Удобно использовать для каждого клиента свой префикс.
  # Тогда нужно описать столько пулов, сколько клиентов. Если у вас разные пулы для фул и
  # инкрементал бекапов, возможно, вы захотите использовать такие названия, как Full- и Incr-)
LabelFormat = "File-LocalhostFDPool"
}
```

### 3.Настройка Хранителя (Bacula Storage Daemon)

`cp /etc/bacula/bacula-sd.conf /etc/bacula/bacula-sd.conf~`

`vim /etc/bacula/bacula-sd.conf`

```
Storage {
  Name = bacula-sd                                                # имя для SD
  SDPort = 9103                                                      # порт стандартный
  WorkingDirectory = "/var/spool/bacula"        # рабочая директория процесса(для статус файлов)
  Pid Directory = "/var/run"                                  # расположение pid файла
  Maximum Concurrent Jobs = 20
}

Director {
  Name = bacula-dir                            # имя BD, того самого, который был описан ранее
  Password = "directorpassword"     # пароль из файла /etc/bacula/bacula-dir.conf в секции Storage
}

Director {
  Name = bacula-mon
  Password = "consolepassword"
  Monitor = yes
}


Device {
  Name = FileStorage                              # Уникальное имя подключенного устройства – совпадает с Device в файле /etc/bacula/bacula-dir.conf в секции Storage
  Media Type = File                                  # тип – совпадает с Media Type, описанным в файле /etc/bacula/bacula-dir.conf в секции Storage
  Archive Device = /bacula/backup       # Путь к каталогу, в котором будут размещаться резервные копии
  LabelMedia = yes;                                  # Автоматическое маркирование носителей информации. Новые тома будут обзываться согласно настроек Pool'а
  Random Access = Yes;                           # Указывает на возможность случайной (непоследовательной) адресации. Для устройства типа File должно быть yes
  AutomaticMount = yes;                        # если устройство открыто, использовать его
  RemovableMedia = no;                         # возможно ли извлечение устройства хранения. Необходимо для Tape, CD и т.д. Для файлов устанавливается no
  AlwaysOpen = no;                                  # открывать только тогда, когда стартует соответствующие задание
}
Messages {
  Name = Standard
  director = bacula-dir = all
}
```

### 4. Настройка клиента локального (Bacula File Daemon)

`cp /etc/bacula/bacula-fd.conf /etc/bacula/bacula-fd.conf~`

`vim /etc/bacula/bacula-fd.conf`

```
Director {
  Name = bacula-dir                     # имя из bacula-dir.conf секция Director
  Password = "localclientpassword"     # пароль из /etc/bacula/conf.d/localhost.conf секция Client
}

Director {
  Name = backup-mon                     # имя из bacula-dir.conf секция Console
  Password = "consolepassword"     # пароль из bacula-dir.conf секция Console
  Monitor = yes
}

FileDaemon {
  Name = localhost-fd
  FDport = 9102
  WorkingDirectory = /var/spool/bacula
  Pid Directory = /var/run
  Maximum Concurrent Jobs = 20
  FDAddress = 127.0.0.1
}

# Send all messages except skipped files back to Director
Messages {
  Name = Standard
  director = bacula-dir = all, !skipped, !restored
}
```

### 5.Настройка консоли управления bconsole

`cp /etc/bacula/bconsole.conf /etc/bacula/bconsole.conf~`

`vim /etc/bacula/bconsole.conf`

```
Director {
  Name = bacula-dir             # имя Bacula Director,указанного в файле bacula-dir.conf в секции Director   
  DIRport = 9101
  address = localhost
  Password = "directorpassword"  # пароль Bacula Director,указанного в файле bacula-dir.conf в секции Director
}
```

### 6.Тестирование конфигурационных файлов, запуск и добавление сервисов в автозагрузку.

```
sudo bacula-dir -tc /etc/bacula/bacula-dir.conf
sudo bacula-sd -tc /etc/bacula/bacula-sd.conf
sudo bacula-fd -tc /etc/bacula/bacula-fd.conf

systemctl start bacula-dir.service
systemctl start bacula-sd.service 
systemctl start bacula-fd.service 

systemctl status bacula-dir.service
systemctl status bacula-sd.service 
systemctl status bacula-fd.service

systemctl enable bacula-dir.service
systemctl enable bacula-sd.service 
systemctl enable bacula-fd.service 

```

`ps ax | grep [b]acula`

`netstat -nlpt | grep [b]acula`