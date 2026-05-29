import os
from pathlib import Path
from dotenv import load_dotenv

_REPO_ROOT = Path(__file__).resolve().parents[2]
load_dotenv(_REPO_ROOT/".env")

DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "postgresql://music:music@localhost:5432/music", # fallback
)