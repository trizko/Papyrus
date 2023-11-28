from fastapi import FastAPI, HTTPException
import openai

app = FastAPI()

openai.api_key = 'super-secret-key'

@app.post("/generate-text/")
async def generate_text(prompt: str):
    try:
        response = openai.Completion.create(
          engine="text-davinci-003",
          prompt=prompt,
          max_tokens=50
        )
        return {"generated_text": response.choices[0].text.strip()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

