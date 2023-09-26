import uvicorn
from fastapi import FastAPI
from reviews import ListofStrings
import numpy as np
import pandas as pd

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/predict")
async def predict(data:ListofStrings):
    print(data)