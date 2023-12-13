CREATE TABLE your_table (
    user_id SERIAL PRIMARY KEY,
    challenging INT CHECK (int_field1 BETWEEN 1 AND 5),
    fun INT CHECK (int_field2 BETWEEN 1 AND 5),
    json_level JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
