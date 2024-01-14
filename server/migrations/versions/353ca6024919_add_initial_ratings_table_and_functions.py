"""add initial ratings table and functions

Revision ID: 353ca6024919
Revises: 
Create Date: 2024-01-11 23:10:41.694084

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "353ca6024919"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute(
        """
    CREATE TABLE IF NOT EXISTS ratings (
        rating_id SERIAL PRIMARY KEY,
        challenge_rating INT CHECK (challenge_rating BETWEEN 0 AND 5),
        fun_rating INT CHECK (fun_rating BETWEEN 0 AND 5),
        impossible BOOLEAN,
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
    CREATE OR REPLACE TRIGGER update_modified_at_before_update
    BEFORE UPDATE ON ratings
    FOR EACH ROW
    EXECUTE FUNCTION update_modified_at();
    """
    )


def downgrade() -> None:
    op.execute(
        """
    DROP TABLE IF EXISTS ratings;
    DROP FUNCTION IF EXISTS update_modified_at;
    DROP TRIGGER IF EXISTS update_modified_at_before_update ON ratings;
    """
    )
