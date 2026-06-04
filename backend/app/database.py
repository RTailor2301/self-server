from collections.abc import Generator
from contextlib import contextmanager

from sqlalchemy import create_engine, text, inspect
from sqlalchemy import Connection, Engine

from app.config import DATABASE_URL

engine: Engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True
)

'''
Use with engine.connect() as conn for automatic closure
'''

@contextmanager
def get_connection() -> Generator[Connection, None, None]: # [Yield Type, Send Type, Return Type]
    '''
    Open connection and yield for duration of operation
    '''
    with engine.connect() as conn:
        with conn.begin():
            yield conn

def check_connection() -> None:
    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))

if __name__ == "__main__":
    check_connection()
    inspector = inspect(engine)
    tables: list[str] = inspector.get_table_names()
    print("connected:",DATABASE_URL.split("@")[-1])
    print("tables:",tables)