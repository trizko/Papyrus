import asyncio
import json
import os

from pydantic import BaseModel, Json
from datetime import datetime

import asyncpg


class RatingCreate(BaseModel):
    challenge_rating: int
    fun_rating: int
    impossible: bool = False
    json_level: Json


class Rating(RatingCreate):
    rating_id: int
    created_at: datetime = datetime.now()
    modified_at: datetime = datetime.now()


async def create_rating(rating: RatingCreate) -> Rating:
    json_level_str = json.dumps(rating.json_level)
    conn = await asyncpg.connect(os.getenv("PG_URI"))
    row = await conn.fetchrow(
        "INSERT INTO ratings (challenge_rating, fun_rating, impossible, json_level) VALUES ($1, $2, $3, $4) RETURNING *",
        rating.challenge_rating,
        rating.fun_rating,
        rating.impossible,
        json_level_str,
    )
    await conn.close()

    return Rating(**row)
