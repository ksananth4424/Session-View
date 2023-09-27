import uvicorn
from fastapi import FastAPI
from typing import List
import numpy as np
import pandas as pd
from tqdm.auto import tqdm
import tensorflow as tf
from transformers import BertTokenizer
from transformers import TFBertModel
model = TFBertModel.from_pretrained('bert-base-cased')
sentiment_model = tf.keras.models.load_model('my_model.h5')

tokenizer = BertTokenizer.from_pretrained('bert-base-cased')

def prepare_data(input_text, tokenizer):
    token = tokenizer.encode_plus(
        input_text,
        max_length=256, 
        truncation=True, 
        padding='max_length', 
        add_special_tokens=True,
        return_tensors='tf'
    )
    return {
        'input_ids': tf.cast(token.input_ids, tf.float64),
        'attention_mask': tf.cast(token.attention_mask, tf.float64)
    }

def make_prediction(model, processed_data, classes=['Advanced','Bad','Bad Management','Beginner Friendly','Overall Good','Good Management',
                                                    'Good Resources','Informative and Knowledgeable','Lengthy','Short']):
    tags=[]
    probs = model.predict(processed_data)[0]
    for i in range(10):
        # if(probs[i]>0.01):
        tags.append([classes[i],probs[i]])
    return tags
        # print(classes[i],probs[i])

app = FastAPI()

def predict(data:str):
    print(data)
    processed_data = prepare_data(data, tokenizer)
    tags=make_prediction(sentiment_model, processed_data=processed_data)
    return tags