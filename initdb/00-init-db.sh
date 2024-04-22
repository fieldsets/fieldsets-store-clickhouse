#!/bin/bash
set -e

###
# Execute arbitrary SQL here for clickhouse initialization.
# This is the spot where you want to manage creating users, defining custom functions, tables views and anything else
# that would need to be defined before the core data architecture is built.
###
timeout 90s bash -c "until pg_isready -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER; do printf '.'; sleep 5; done; printf '\n'"

clickhouse-client --host 0.0.0.0 --user $CLICKHOUSE_USER --password $CLICKHOUSE_PASSWORD --database system -n <<-EOSQL
    CREATE DATABASE IF NOT EXISTS $CLICKHOUSE_DB;

    CREATE DATABASE IF NOT EXISTS postgres
    ENGINE = PostgreSQL('$POSTGRES_HOST:$POSTGRES_PORT', '$POSTGRES_DB', '$POSTGRES_USER', '$POSTGRES_PASSWORD', 'public', 1);

EOSQL
