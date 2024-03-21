/**
 * Enumerated Fields
 * Uses native low-cardinality data type
 */
CREATE TABLE IF NOT EXISTS fieldsets.enums (
    id          UInt64, -- References fieldset id
    token       LowCardinality(String), -- References fieldset token
    field_id    UInt64,
    field_token LowCardinality(String),
    created     DateTime64(3) DEFAULT now64(3)
)
ENGINE = ReplacingMergeTree(created)
PARTITION BY field_id
PRIMARY KEY (field_id, id)
ORDER BY (field_id, id)
SETTINGS clean_deleted_rows='Always';