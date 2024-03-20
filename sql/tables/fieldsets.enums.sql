/**
 * Enumerated Fields
 * Uses native low-cardinality data type
 */
CREATE TABLE IF NOT EXISTS fieldsets.enums (
    id          UInt64, -- References fieldset id
    token       LowCardinality(String), -- References fieldset token
    field_id    UInt64,
    field_token LowCardinality(String)
)
ENGINE = MergeTree()
PARTITION BY field_id
ORDER BY (id, token);