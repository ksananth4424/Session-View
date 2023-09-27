from fastapi import APIRouter,HTTPException,Request,Response,status
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse
import asyncio
from typing import List
import firebase_admin
from firebase_admin import credentials,firestore
from pydantic import BaseModel
from . import deploy
cred = credentials.Certificate('hackathon2-4d029-firebase-adminsdk-ckc2q-6771c29c2a.json')
firebase_admin.initialize_app(cred)

class Form_data(BaseModel):
    review:str

clubs={
    "club1":{'counter':0,
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
        clubs[session.club_id]['counter']=clubs[session.club_id]['counter']+1
        print(tags)
        #pass this list to ml model u will get result
        for sublist in tags:
                clubs[session.club_id][sublist[0]] = (clubs[session.club_id][sublist[0]]*(clubs[session.club_id]['counter']-1)+sublist[1])/clubs[session.club_id]['counter']

        update(clubs[session.club_id],session)
        return clubs[session.club_id]

    

@router.post("/stop")
async def toggle_form_submission(club_id:str):
    for key in clubs[club_id].keys():
         clubs[club_id][key]=0

db=firestore.client()
def update(result:dict,session:session_data):
    try:
        doc=db.collection("clubs").document(session.club_id).collection("sessions").document(session.session_id)
        doc.set(result,merge=True)

    except Exception as e:
         raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,detail=f"Error:{str(e)}")
