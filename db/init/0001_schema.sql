-- initial schema
-- Postgres w/ pgcrypto + pgvector (in docker/docker-compose.yml)

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

-- Users

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(128) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Songs - metadata from local files / Navidrome

CREATE TABLE songs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(512) NOT NULL,
    artist VARCHAR(256),
    album VARCHAR(256),
    year SMALLINT,
    duration_seconds INT,
    file_path VARCHAR(1024) NOT NULL,
    navidrome_id VARCHAR(64) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_songs_file_path UNIQUE(file_path)
);
