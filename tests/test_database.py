from sqlalchemy import inspect, text
from app.database import engine

EXPECTED_TABLES = {
    "users",
    "albums",
    "songs",
    "genres",
    "song_genres",
    "album_genres",
    "song_embeddings",
    "events",
}

def test_connection() -> None:
    with engine.connect() as conn:
        assert conn.execute(text("SELECT 1")).scalar() == 1

def test_extension() -> None:
    with engine.connect() as conn:
        rows = conn.execute(
            text(
                "SELECT extname FROM pg_extension "
                "WHERE extname IN ('vector', 'pgcrypto') "
                "ORDER BY extname"
            )
        ).fetchall()
    assert [row[0] for row in rows] == ["pgcrypto", "vector"]

def test_schema_tables() -> None:
    tables = set(inspect(engine).get_table_names())
    missing = EXPECTED_TABLES - tables
    assert not missing, f"missing tables: {missing}"