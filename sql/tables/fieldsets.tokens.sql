CREATE DICTIONARY IF NOT EXISTS fieldsets.tokens (
    id          UInt64,
    token       String
)
PRIMARY KEY id
SOURCE(PostgreSQL(
    NAME 'postgres_connection'
    TABLE 'tokens'
    DB 'fieldsets'
))
LAYOUT(HASHED())
LIFETIME (MIN 1 MAX 2);