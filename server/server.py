import os

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from openai import OpenAI
from pydantic import BaseModel

load_dotenv()

client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

app = FastAPI()

class LevelGenerationRequest(BaseModel):
    prompt: str = "Write a simple web server in roc-lang."

@app.post("/generate-level/")
async def generate_text(data: LevelGenerationRequest):
    try:
        response = client.completions.create(
          model="text-davinci-003",
          prompt=data.prompt,
          max_tokens=2000
        )
        return {"level": response.choices[0].text.strip()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

