import asyncio
import json

from pydantic import BaseModel, Json
from datetime import datetime

import asyncpg

class RatingCreate(BaseModel):
    challenge_rating: int
    fun_rating: int
    json_level: Json

class Rating(RatingCreate):
    id: int
    created_at: datetime = datetime.now()
    modified_at: datetime = datetime.now()

async def create_rating(rating: RatingCreate) -> Rating:
    json_level_str = json.dumps(rating.json_level)
    conn = await asyncpg.connect('postgresql://postgres:postgres@localhost:5432/papyrus')
    row = await conn.fetchrow(
        'INSERT INTO ratings (challenge_rating, fun_rating, json_level) VALUES ($1, $2, $3) RETURNING *',
        rating.challenge_rating, rating.fun_rating, json_level_str
    )
    await conn.close()
    
    return Rating(**row)