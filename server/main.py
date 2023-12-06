import json
import logging
import os

import uvicorn

from apscheduler.schedulers.background import BackgroundScheduler
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from openai import OpenAI
from pydantic import BaseModel
from typing import Optional

from cache.redis import RedisCache
from cache.memory import MemoryCache

load_dotenv()
logger = logging.getLogger("uvicorn")

# initialize cache
redis_cluster_nodes = [{"host": "127.0.0.1", "port": "6379"}]
cache = MemoryCache() if os.getenv('ENVIRONMENT') != "prod" else RedisCache(redis_cluster_nodes)

# initialize app and background worker
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
scheduler = BackgroundScheduler()

app = FastAPI()

PROMPT = """
I have created a game where the goal is to get a ball to a goal. A level of the
game starts with a ball suspended in the air. At this point, the user is allowed
to draw a maximum number of lines in the scene. The lines act as platforms for
the ball to roll on and the goal is for the player to draw the correct lines to
get the ball to the goal. There will be obstacles in the way of the goal from
the starting position of the ball that the player will have to draw lines
around. The user then presses the "Play" button to turn on the gravity for the
ball and the ball will fall on the lines and obstacles and, hopefully, get to
the goal line. Here is an example level in JSON format:

{
  "max_lines": 2,
  "ball": {
    "position_x": 100.0,
    "position_y": 50.0
  },
  "obstacles": [
    {"start_point_x": 100.0, "start_point_y": 300.0, "end_point_x": 300.0, "end_point_y": 300.0},
    {"start_point_x": 300.0, "start_point_y": 500.0, "end_point_x": 500.0, "end_point_y": 500.0},
    {"start_point_x": 100.0, "start_point_y": 700.0, "end_point_x": 300.0, "end_point_y": 900.0},
    {"start_point_x": 400.0, "start_point_y": 800.0, "end_point_x": 600.0, "end_point_y": 1000.0},
    {"start_point_x": 700.0, "start_point_y": 1100.0, "end_point_x": 900.0, "end_point_y": 1300.0},
    {"start_point_x": 200.0, "start_point_y": 1400.0, "end_point_x": 400.0, "end_point_y": 1600.0},
    {"start_point_x": 500.0, "start_point_y": 1500.0, "end_point_x": 700.0, "end_point_y": 1700.0},
  ],
  "goal": {
    "position_x": 950.0,
    "position_y": 1800.0
  }
}

The maximum level size could be 1080x1920 pixels. Generate a new level within
that range for the x and y axis and respond with only JSON. Remove any
formatting like newlines and tabs.
"""

def generate_level():
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
    return json.loads(response.choices[0].message.content)

def update_db():
    cache.push("levels", generate_level())
    logger.info("Added new level to cache.")

@app.on_event("startup")
def start_scheduler():
    scheduler.add_job(update_db, 'interval', seconds=5)
    scheduler.start()

@app.on_event("shutdown")
def stop_scheduler():
    scheduler.shutdown()

@app.get("/levels/")
async def generate_text():
    try:
        return cache.pop("levels")
    except:
        raise HTTPException(status_code=404, detail=f"Level number {level_number} not found")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)