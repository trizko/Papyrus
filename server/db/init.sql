CREATE TABLE ratings (
    user_id SERIAL PRIMARY KEY,
    challenge_rating INT CHECK (challenge_rating BETWEEN 1 AND 5),
    fun_rating INT CHECK (fun_rating BETWEEN 1 AND 5),
    json_level JSON,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Function to update modified_at on row update
CREATE OR REPLACE FUNCTION update_modified_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update modified_at
CREATE TRIGGER update_modified_at_before_update
BEFORE UPDATE ON ratings
FOR EACH ROW
EXECUTE FUNCTION update_modified_at();
