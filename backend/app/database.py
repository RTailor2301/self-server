from collections.abc import Generator
from contextlib import contextmanager

from sqlalchemy import create_engine, text
from sqlalchemy import Connection, Engine

from app.config import DATABASE_URL

engine: Engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True
)