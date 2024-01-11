import json
import logging
import os

import uvicorn

from apscheduler.schedulers.background import BackgroundScheduler
from contextlib import asynccontextmanager
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from openai import OpenAI
from pydantic import BaseModel
from typing import Optional

from cache import MemoryCache, RedisCache
from models.ratings import RatingCreate, Rating, create_rating

load_dotenv()
logger = logging.getLogger("uvicorn")

# initialize cache
redis_cluster_nodes = [{"host": "127.0.0.1", "port": "6379"}]
cache = MemoryCache() if os.getenv('ENVIRONMENT') != "prod" else RedisCache(redis_cluster_nodes)

# initialize app and background worker
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
scheduler = BackgroundScheduler()

PROMPT = """
I have created a game where the goal is to get a ball to a goal. A level of the
game starts with a ball suspended in the air. At this point, the user is allowed
to draw a maximum number of lines in the scene. The lines act as platforms for
the ball to roll on and the goal is for the player to draw the correct lines to
get the ball to the goal. There will be obstacles in the way of the goal from
the starting position of the ball that the player will have to draw lines
around. The user then presses the "Play" button to turn on the gravity for the
ball and the ball will fall on the lines and obstacles and, hopefully, get to
the goal line. Here are some example levels in JSON format:

Example 1:
{
  "ball": {
    "position_x": 350,
    "position_y": 50
  },
  "goal": {
    "position_x": 700,
    "position_y": 1300
  },
  "max_lines": 3,
  "obstacles": [
    { "end_point_x": 300, "end_point_y": 300, "start_point_x": 100, "start_point_y": 300 },
    { "end_point_x": 500, "end_point_y": 500, "start_point_x": 300, "start_point_y": 500 },
    { "end_point_x": 300, "end_point_y": 900, "start_point_x": 100, "start_point_y": 700 },
    { "end_point_x": 600, "end_point_y": 1000, "start_point_x": 400, "start_point_y": 800 },
    { "end_point_x": 900, "end_point_y": 1300, "start_point_x": 700, "start_point_y": 1100 },
    { "end_point_x": 400, "end_point_y": 1440, "start_point_x": 200, "start_point_y": 1400 },
    { "end_point_x": 700, "end_point_y": 1440, "start_point_x": 500, "start_point_y": 1440 }
  ]
}

Example 2:
{
  "ball": {
    "position_x": 600,
    "position_y": 100
  },
  "goal": {
    "position_x": 900,
    "position_y": 1300
  },
  "max_lines": 3,
  "obstacles": [
    { "end_point_x": 400, "end_point_y": 400, "start_point_x": 200, "start_point_y": 400 },
    { "end_point_x": 800, "end_point_y": 600, "start_point_x": 600, "start_point_y": 600 },
    { "end_point_x": 400, "end_point_y": 1000, "start_point_x": 200, "start_point_y": 800 },
    { "end_point_x": 800, "end_point_y": 1200, "start_point_x": 600, "start_point_y": 1000 },
    { "end_point_x": 400, "end_point_y": 1200, "start_point_x": 200, "start_point_y": 1200 }
  ]
}

Example 3:
{
  "ball": {
    "position_x": 200,
    "position_y": 100
  },
  "goal": {
    "position_x": 740,
    "position_y": 1000
  },
  "max_lines": 3,
  "obstacles": [
    { "end_point_x": 400, "end_point_y": 300, "start_point_x": 200, "start_point_y": 300 },
    { "end_point_x": 500, "end_point_y": 500, "start_point_x": 300, "start_point_y": 500 },
    { "end_point_x": 400, "end_point_y": 900, "start_point_x": 200, "start_point_y": 700 },
    { "end_point_x": 600, "end_point_y": 1000, "start_point_x": 400, "start_point_y": 800 },
    { "end_point_x": 900, "end_point_y": 1300, "start_point_x": 700, "start_point_y": 1100 },
    { "end_point_x": 400, "end_point_y": 1240, "start_point_x": 200, "start_point_y": 1200 },
    { "end_point_x": 700, "end_point_y": 1240, "start_point_x": 500, "start_point_y": 1240 }
  ]
}

The maximum level size could be 1080x1440 pixels. Generate a new level within
that range for the x and y axis and respond with only JSON. Remove any
formatting like newlines and tabs.
"""

def generate_level():
    if cache.length("levels") > 99:
        return

    response = client.chat.completions.create(
        model="gpt-3.5-turbo-1106",
        messages=[
            {
                "role": "user",
                "content": PROMPT,
            }
        ],
        response_format={
            "type": "json_object"
        }
    )
    logger.info("Generating new level from GPT API.")
    cache.push("levels", json.loads(response.choices[0].message.content))
    logger.info("Added new level to cache.")

@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup events that happen before the yielding
    scheduler.add_job(generate_level, 'interval', seconds=10)
    scheduler.start()
    yield
    # run shutdown events when lifespan yields
    scheduler.shutdown()

app = FastAPI(lifespan=lifespan)

@app.get("/levels/")
async def generate_text():
    try:
        return cache.pop("levels")
    except:
        raise HTTPException(status_code=404, detail=f"Level number {level_number} not found")

@app.post("/ratings/", response_model=Rating)
async def create_rating_endpoint(rating: RatingCreate):
    new_rating = await create_rating(rating)
    if new_rating is None:
        raise HTTPException(status_code=400, detail="Error creating rating")
    return new_rating

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)