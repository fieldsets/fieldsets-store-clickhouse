#!/usr/bin/env bash

#===
# 01-create-tables.sh: Create Data Tables
#
#===

set -eEa -o pipefail

#===
# Variables
#===

export PRIORITY=01

##
# init: execute our sql
##
init() {
    local f
    for f in /usr/local/fieldsets/sql/tables/*.sql; do
        clickhouse-client --host 0.0.0.0 --user ${CLICKHOUSE_USER} --password ${CLICKHOUSE_PASSWORD} --database ${CLICKHOUSE_DB} -nm --queries-file ${f}
    done
}

#===
# Main
#===
init

trap '' 2 3
trap traperr ERR
