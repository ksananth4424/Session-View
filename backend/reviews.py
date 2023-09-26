from fastapi import FastAPI,Request
from fastapi.responses import HTMLResponse,FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from typing import List

app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:8000",
    "http://10.42.0.1:8000",  
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class String(BaseModel):
    string: str

class ListofStrings(String):
    reviews: List[String]

@app.post("/receive")
async def receive(data:String):
    ListofStrings.reviews.insert(data)