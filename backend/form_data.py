from fastapi import APIRouter,HTTPException,status
import asyncio
from typing import List
import firebase_admin
from firebase_admin import credentials,firestore
from pydantic import BaseModel
from deploy import predict
cred = credentials.Certificate('hackathon-9f5f7-firebase-adminsdk-1vfic-eb2298f178.json')
firebase_admin.initialize_app(cred)

class Form_data(BaseModel):
    review:str

clubs={}

class session_data(BaseModel):
    club_id:str
    session_id:str
    review_id:str

class session(BaseModel):
    club_id:str
    session_id:str

router=APIRouter()

form_data_queue = asyncio.Queue()  

db=firestore.client()
def fixup(tags):
    tags[4].append(tags[1][1])
    tags[5].append(tags[2][1])
    tags[8].append(tags[9][1])
    # for sublist in tags:
    #     if sublist[0]=='Bad':del sublist
    #     elif sublist[0]=='Bad Management':del sublist
    #     elif sublist[0]=='Good Resources':del sublist
    #     elif sublist[0]=='Short':del sublist
    #     elif sublist[0]=='Advanced':sublist.append(0)
        # elif sublist[0]=='Informative and Knowledgeable':sublist.append(0)
    han=[sublist for sublist in tags  if(sublist[0]!='Bad' and sublist[0]!='Bad Management' and sublist[0]!='Good Resources' and sublist[0]!='Short')]
    for sublist in han:
        if sublist[0]=='Informative and Knowledgeable': sublist.append(0)
        elif sublist[0]=='Advanced': sublist.append(0)
        elif sublist[0]=='Beginner Friendly': sublist.append(0)
        
    print(han)
    return han

@router.post("/submit_form")
async def submit_form(session:session_data):
    review=db.collection("clubs").document(session.club_id).collection("sessions").document(session.session_id).collection("reviews").document(session.review_id)
    doc=review.get()
    global clubs
    field=doc.to_dict().get("text")
    tags=predict(field)
    if session.club_id not in clubs:
         clubs[session.club_id]={}

    if session.session_id not in clubs[session.club_id]:
        clubs[session.club_id][session.session_id] = {'counter': 0}
    
    clubs[session.club_id][session.session_id]['counter'] += 1

    tags=fixup(tags)
    for sublist in tags:
        tag_name = sublist[0]
        tag_value_good= sublist[1]
        tag_value_bad=sublist[2]
        clubs[session.club_id][session.session_id].setdefault(tag_name, 0)
        if tag_value_good>0.2:
            clubs[session.club_id][session.session_id][sublist[0]]=clubs[session.club_id][session.session_id][sublist[0]]+1
        if tag_value_bad>0.2:
            clubs[session.club_id][session.session_id][sublist[0]]=clubs[session.club_id][session.session_id][sublist[0]]-1
    update(clubs[session.club_id][session.session_id],session)
    return clubs[session.club_id][session.session_id]


@router.post("/stop")
async def toggle_form_submission(session:session):
    global clubs
    stop={"state":2}
    db.collection("clubs").document(session.club_id).collection("sessions").document(session.session_id).set(stop,merge=True)
    session_dict=clubs[session.club_id][session.session_id]
    del session_dict


def update(result:dict,session:session_data):
    try:
        doc=db.collection("clubs").document(session.club_id).collection("sessions").document(session.session_id)
        # doc_ref=doc.get()
        # data=doc_ref.to_dict()
        tags={
             "management":result["Good Management"],
             "informative":result["Informative and Knowledgeable"],
             "length":result["Lengthy"],
             "beginner_friendly":result["Beginner Friendly"],
             "topic_level":result["Advanced"],
             "overall_good":result["Overall Good"],
             "count":result["counter"]
        }
        doc.update({"tags":tags})

    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,detail=f"Error:{str(e)}")