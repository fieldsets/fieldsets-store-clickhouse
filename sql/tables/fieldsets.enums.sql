/**
 * Enumerated Fields
 * Uses native low-cardinality data type
 */
CREATE DICTIONARY IF NOT EXISTS fieldsets.enums (
    id          UInt64, -- References fieldset id
    token       String, -- References fieldset token
    field_id    UInt64,
    field_token String,
    created     DateTime64(3)
)
PRIMARY KEY field_token, token
SOURCE(PostgreSQL(
    NAME 'fieldsets_db_connection'
    TABLE 'enums'
    DB 'fieldsets'
))
LAYOUT(HASHED())
LIFETIME (MIN 1 MAX 2);