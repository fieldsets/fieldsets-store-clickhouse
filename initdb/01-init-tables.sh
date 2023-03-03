#!/bin/bash
set -e

#clickhouse-client --host 127.0.0.1 --user $CLICKHOUSE_USER --password $CLICKHOUSE_PASSWORD --database $CLICKHOUSE_DB -n <<-EOSQL
#    SET allow_experimental_object_type = 1;
#    CREATE TABLE IF NOT EXISTS pipeline.events
#    (
#        event_id		UUID DEFAULT generateUUIDv4(),
#        pipeline        LowCardinality(String),
#        event_token     LowCardinality(String),
#        event_status    Enum('pending' = 1, 'processing' = 2, 'error' = 3, 'failed' = 4, 'passed' = 5, 'reprocess' = 6, 'waiting' = 7, 'review' = 8, 'complete' = 9),
#        meta_data       JSON,
#        created         DateTime64(3,'${TIMEZONE}') DEFAULT now64(3, '${TIMEZONE}'),
#        updated         DateTime64(3,'${TIMEZONE}') DEFAULT now64(3, '${TIMEZONE}')
#    )
#    ENGINE = MergeTree()
#    PARTITION BY toYYYYMM(created)
#    ORDER BY (pipeline,event_token, event_status, toStartOfHour(created))
#    SETTINGS index_granularity = 8192;
#
#    CREATE TABLE IF NOT EXISTS pipeline.logs
#    (
#        log_id			UUID DEFAULT generateUUIDv4(),
#        pipeline        LowCardinality(String),
#        log             JSON,
#        created         DateTime64(3,'${TIMEZONE}') DEFAULT now64(3, '${TIMEZONE}')
#    )
#    ENGINE = MergeTree()
#    PARTITION BY toYYYYMM(created)
#    ORDER BY (pipeline, toStartOfHour(created));
#EOSQL



