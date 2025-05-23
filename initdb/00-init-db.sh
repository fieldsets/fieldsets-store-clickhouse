#!/bin/bash
set -e

###
# Execute arbitrary SQL here for clickhouse initialization.
# This is the spot where you want to manage creating users, defining custom functions, tables views and anything else
# that would need to be defined before the core data architecture is built.
###
timeout 90s bash -c "until pg_isready -h ${FIELDSETS_DB_HOST} -p ${FIELDSETS_DB_PORT} -U ${FIELDSETS_DB_USER}; do printf '.'; sleep 5; done; printf '\n'"

clickhouse-client --host 0.0.0.0 --user ${CLICKHOUSE_USER} --password ${CLICKHOUSE_PASSWORD} --database system -n <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${CLICKHOUSE_DB};

    CREATE DATABASE IF NOT EXISTS postgres
    ENGINE = PostgreSQL('${FIELDSETS_DB_HOST}:${FIELDSETS_DB_PORT}', '${FIELDSETS_DB_NAME}', '${FIELDSETS_DB_USER}', '${FIELDSETS_DB_PASSWORD}', '${FIELDSETS_DB_SCHEMA}', 1);
EOSQL
