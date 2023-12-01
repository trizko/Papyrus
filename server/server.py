import json
import os


from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from openai import OpenAI
from pydantic import BaseModel
from typing import Optional

load_dotenv()

client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

app = FastAPI()

class LevelGenerationRequest(BaseModel):
    prompt: Optional[str] = """
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


@app.post("/generate-level/")
async def generate_text(data: LevelGenerationRequest):
    try:
        response = client.chat.completions.create(
          model="gpt-3.5-turbo-1106",
          messages=[
              {
                  "role": "user",
                  "content": data.prompt,
              }
          ],
          response_format={
            "type": "json_object"
          }
        )
        return json.loads(response.choices[0].message.content)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

