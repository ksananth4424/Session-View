from fastapi import APIRouter,HTTPException,Request,Response,status
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse
import asyncio
from typing import List
from firebase_admin import firestore
from pydantic import BaseModel
from . import deploy

class Form_data(BaseModel):
    review:str

clubs={
    "club1":{
         'Advanced':0,'Bad':0,'Bad Management':0,'Beginner Friendly':0,'Overall Good':0,'Good Management':0,'Good Resources':0,'Informative and Knowledgeable':0,'Lengthy':0,'Short':0
    },
    "club2":{}
}



class session_data(BaseModel):
    club_id:str
    session_id:str

router=APIRouter()

form_data_queue = asyncio.Queue()  


@router.post("/submit_form")
async def submit_form(request: Request, form_data: Form_data,session:session_data):
    
        tags=deploy.predict(form_data.review)
        #pass this list to ml model u will get result
        # update(result,session)
        for sublist in tags:
             if sublist[1]>0.1:
                clubs[session.club_id][sublist[0]] = clubs[session.club_id][sublist[0]]+1

        return clubs[session.club_id]

    

@router.post("/stop")
async def toggle_form_submission(club_id:str):
    clubs[club_id].clear()

db=firestore.client()
def update(result:dict,session:session_data):
    try:
        doc=db.collection("clubs").document(session.club_id).collection("sessions").document(session.session_id)
        doc.set(result,merge=True)

    except Exception as e:
         raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,detail=f"Error:{str(e)}")
