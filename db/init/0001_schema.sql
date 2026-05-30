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

-- Genres - many-to-many for mutli-genre

CREATE TABLE genres (
    id SMALLSERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    CONSTRAINT uq_genres_name UNIQUE (name),
);


CREATE TABLE song_genres (
    song_id UUID NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    genre_id SMAULL REFERENCES genres(id) ON DELETE CASCADE,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (song_id, genre_id),
);

-- create primary genre index

CREATE UNIQUE INDEX idx_song_genres_primary ON song_genres (song_id) WHERE is_primary;

CREATE TABLE albums (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(512) NOT NULL,
    artist VARCHAR(256) NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_albums_title_artist UNIQUE (title, artist)
);

CREATE TABLE album_genres (
    album_id UUID NOT NULL REFERENCES albums(id) ON DELETE CASCADE,
    genre_id SMALLINT NOT NULL REFERENCES albums(id) ON DELETE CASCADE,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (album_id, genre_id),
);

CREATE UNIQUE INDEX idx_album_genres_primary ON album_genres (album_id) WHERE is_primary;

-- Content embeddings (pgvector)

CREATE TABLE song_embeddings (
    song_id UUID NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    model VARCHAR(64) NOT NULL,
    dimensions SMALLINT NOT NULL,
    embedding vector(512) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (song_id, model),
    CONSTRAINT check_song_embeddings_dimensions CHECK (dimensions=512)
);

-- listening events

CREATE TYPE event_type as ENUM ('play_start', 'play_end', 'skip');

CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    song_id UUID NOT NULL REFERENCES songs(id) NOT DELETE CASCADE,
    event_type event_type NOT NULL,
    ts TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index

CREATE INDEX idx_events_user_ts ON events (user_id, ts);
CREATE INDEX idx_events_song on evnets (song_id);
CREATE INDEX idx_songs_artist on songs (artist);
CREATE INDEX idx_songs_album_id songs (album_id);
CREATE INDEX idx_song_genres_genre_id ON song_genres (genre_id);
CREATE INDEX idx_album_genres_genre_id ON album_genres (genre_id);