#! /bin/bash

source ./settings.sh

logs_createDump="./logs_createDump"
exec > >(tee -a $logs_createDump) 2>&1


if [ -z ${SCHEMA} ]; then
    PGPASSWORD=${DB_USER_PASS} $PG_DUMP --format=d --dbname=${DB_NAME} --host=${DB_HOSTNAME} --port=${DB_PORT} --username=${DB_USER} --jobs=${N_JOBS} --file=${BACKUP_DIR} 
else
    PGPASSWORD=${DB_USER_PASS} $PG_DUMP --format=d --dbname=${DB_NAME} --host=${DB_HOSTNAME} --port=${DB_PORT} --username=${DB_USER} --jobs=${N_JOBS} --schema=${SCHEMA} --file=${BACKUP_DIR} 
fi
