#! /bin/bash

# Путь к файлу дампа
PATH_BACKUP_DIR='/tmp/'
NAME_BACKUP_DIR='backup'
FULL_PATH_BACKUP_DIR=${PATH_BACKUP_DIR}${NAME_BACKUP_DIR}

# Пути к утилитам снятия/восстановления дампа
PG_RESTORE=$(which pg_restore)
PG_DUMP=$(which pg_dump)

# Подключение к БД
DB_HOSTNAME='localhost'
DB_PORT='5432'
DB_NAME='zabbix'

# Пользователь БД
DB_USER='zabbix'
DB_USER_PASS='1111'

# Схема
SCHEMA= 

# Количество потоков
N_JOBS='2'
