from fastapi import FastAPI, File, UploadFile, Form
from typing import Optional
from pydantic import BaseModel
from connection.oracle_connection import *
import pandas as pd


class Table(BaseModel):
    table_source: str
    table_destination: str


app = FastAPI()

@app.post("/mc_email_activities/")
async def etl_mc_email(table: Table):
    source = table.table_source
    destination = table.table_destination
    engine = conn_engine('system', 'oracle', '0.0.0.0', 'XE')
    df_extract = get_data(engine, source)
    result = insert_data(engine,destination, df_extract)
    return result

@app.post("/uploadfile/")
async def create_upload_file(table: str = Form(...),
                             file: UploadFile = File(...)):
    df = pd.read_csv(file.file)
    print(df.head())
    return {'filename': file.filename,
            'table': table}