#! /bin/bash

source ./settings.sh

function base_create_dump {

    logs_createDump="../logs/logs_createDump"
    exec > >(tee -a $logs_createDump) 2>&1

    if [ -z ${SCHEMA} ]; then
        PGPASSWORD=${DB_USER_PASS} $PG_DUMP --format=d --dbname=${DB_NAME} --host=${DB_HOSTNAME} --port=${DB_PORT} --username=${DB_USER} --jobs=${N_JOBS} --file=${FULL_PATH_BACKUP_DIR} 
    else
        PGPASSWORD=${DB_USER_PASS} $PG_DUMP --format=d --dbname=${DB_NAME} --host=${DB_HOSTNAME} --port=${DB_PORT} --username=${DB_USER} --jobs=${N_JOBS} --schema=${SCHEMA} --file=${FULL_PATH_BACKUP_DIR} 
    fi
}

function create_dump {

    if [ ! -d "${FULL_PATH_BACKUP_DIR}" ]; then

        base_create_dump

    else

        echo "Папка бэкапа с таким именем \"$NAME_BACKUP_DIR\" уже существует"
        read -p "Хотите ли поменять название папки бэкапа?(y/n?): " xo
        if [ "$xo" == "y" ]; then
            read -p "Укажите новое название папки: " NEW_NAME_BACKUP_DIR
            sed -i "s/NAME_BACKUP_DIR=.*/NAME_BACKUP_DIR="\'$NEW_NAME_BACKUP_DIR\'"/" ./settings.sh
            echo "Новый путь бэкапа: $PATH_BACKUP_DIR$NEW_NAME_BACKUP_DIR"
            source ./settings.sh
            base_create_dump
            echo "Бэкап готов: $FULL_PATH_BACKUP_DIR"
            
        else
            echo "Выход!"
            exit
        fi

    fi
}
