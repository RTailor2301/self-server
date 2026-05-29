-- initial schema
-- Postgres w/ pgcrypto + pgvector (in docker/docker-compose.yml)

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;
