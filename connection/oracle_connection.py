import cx_Oracle
import sqlalchemy
import pandas as pd


def conn_engine(user, passwd, host, sid):
    engine = sqlalchemy.create_engine(f"oracle+cx_oracle://{user}:{passwd}@{host}:1521/{sid}")
    return engine


def get_data(engine, table):
    sql_query = 'SELECT * FROM ' + str(table)
    df = pd.read_sql(sql_query, engine)
    return df


def insert_data(engine, table, df):
    try:
        df.to_sql(table, engine, if_exists='replace')
        return True
    except Exception as e:
        return e
