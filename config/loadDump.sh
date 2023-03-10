#! /bin/bash

# source ./settings.sh

function load_dump {

    logs_loadDump="../logs/logs_loadDump"
    exec > >(tee -a $logs_loadDump) 2>&1

    if [ -z ${SCHEMA} ]; then
        PGPASSWORD=${DB_USER_PASS} ${PG_RESTORE} --dbname=${DB_NAME} --host=${DB_HOSTNAME} --port=${DB_PORT} --username=${DB_USER} --verbose -F d --jobs=${N_JOBS} ${FULL_PATH_BACKUP_DIR}
    else
        PGPASSWORD=${DB_USER_PASS} ${PG_RESTORE} --dbname=${DB_NAME} --host=${DB_HOSTNAME} --port=${DB_PORT} --username=${DB_USER} --verbose -F d --schema=${SCHEMA} --jobs=${N_JOBS} ${FULL_PATH_BACKUP_DIR} 
    fi
}