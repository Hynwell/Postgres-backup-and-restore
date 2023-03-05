
CONTAINER_NAME="zabbix-postgres"
DB_NAME='zabbix_db'

# Пользователь БД
DB_USER='zabbix_user'
DB_USER_PASS='1111'

docker exec -i $CONTAINER_NAME PGPASSWORD=$DB_USER_PASS pg_dump --username $DB_USER $DB_NAME > /tmp/dump_zabbix.sql
