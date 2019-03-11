 #### Запретить всем пользователям, кроме группы admin логин в выходные и праздничные дни
Для решения задачи возпользуемся следующими модулями PAM:
`pam_succeed_if.so` - 
В нашем случае проводит тест находится ли пользователь который аутентифицируется в группе admin и на основе этого выбирает загружать ли другие два модуля: pam_script.so и pam_time.so. Если пользователь находится в группе admin то эти два модуля в дальнейшем не участвуют в процессе, тем самым к пользователю не применяются условия прописанный в time.conf и все из группы admin попадают в систему в любой день. В противном случае цепочка продолжается выполнением модуля:
`pam_script.so` - 
Его по умолчанию не присутствовало в системе, поэтому пришлось его усановить:
`yum install pam_script -y`
Данный модуль нужен здесь для анализа текущей даты и сравнения ее с пулом праздничных дней, если текущий день являестя праздничным скрипт возвращает 1 тем самым вызывая не успех выполнения модуля.
```
#!/bin/bash

DAT=$(date +"%m%d")
for i in 0101 0223 0308 0501 0509 1107 1231
do
 if [ $DAT == $i ]
 then
  exit 1
 fi
done
 exit 0
```
`pam_time.so`
Для этого модуля редактируем файл конфигурации `/etc/security/time.conf` добавляем правило запрещающее  логин по консоли и все другие типы, всем пользователям в выходные дни.
`*;*;*;!Wd0000-2400`
Ну и редактируем `/etc/pam.d/login`, добавив 3 строки 
#%PAM-1.0
auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so
auth       substack     system-auth
auth       include      postlogin
account    required     pam_nologin.so
`account [success=2 default=ignore] pam_succeed_if.so user ingroup admin`
`account    required     pam_script.so onner=succes dir=/etc/`
`account    required     pam_time.so`
account    include      system-auth
password   include      system-auth
session    required     pam_selinux.so close
session    required     pam_loginuid.so
session    optional     pam_console.so
session    required     pam_selinux.so open
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    include      system-auth
session    include      postlogin
-session   optional     pam_ck_connector.so
