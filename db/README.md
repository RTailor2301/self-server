## Extensions

### 1 `pgcrypto`
UUID generation

### 2 `vector`
Create vector embeddings

## Table Definitions

### 1 `users`

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | `PRIMARY KEY`, `DEFAULT gen_random_uuid()` | unique identifier for each account |
| `name` | `VARCHAR(128)` | `NOT NULL` | user's display name |
| `created_at` | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT NOW()` | date and time of registration |

### 2 `albums`

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | `PRIMARY KEY`, `DEFAULT gen_random_uuid()` | unique identifier for each album |
| `title` | `VARCHAR(512)` | `NOT NULL`, `UNIQUE (title, artist)` | album title from local files or Navidrome metadata |
| `artist` | `VARCHAR(256)` | `NOT NULL`, `DEFAULT ''`, `UNIQUE (title, artist)` | artist name |
| `created_at` | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT NOW()` | date and time when the album record was created |

### 3`songs`

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | `PRIMARY KEY`, `DEFAULT gen_random_uuid()` | unique identifier for each song |
| `title` | `VARCHAR(512)` | `NOT NULL` | song title from local files or Navidrome metadata |
| `artist` | `VARCHAR(256)` | | performing artist name |
| `album_id` | `UUID` | `REFERENCES albums(id)` | foreign key to the album this song belongs to |
| `year` | `SMALLINT` | | release year |
| `duration_seconds` | `INT` | | track length (seconds) |
| `file_path` | `VARCHAR(1024)` | `NOT NULL`, `UNIQUE` | local filesystem path to the audio file |
| `navidrome_id` | `VARCHAR(64)` | `UNIQUE` | Navidrome identifier for sync with the media server |
| `created_at` | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT NOW()` | date and time when the song record was created |
| `updated_at` | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT NOW()` | date and time when the song record was last updated |

### 4`genres`

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `SMALLSERIAL` | `PRIMARY KEY` | unique identifier for each genre |
| `name` | `VARCHAR(64)` | `NOT NULL`, `UNIQUE` | genre label for many-to-many song and album tagging |

### 5`song_genres`

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `song_id` | `UUID` | `NOT NULL`, `REFERENCES songs(id) ON DELETE CASCADE`, `PRIMARY KEY (song_id, genre_id)` | foreign key to song in many-to-many association |
| `genre_id` | `SMALLINT` | `NOT NULL`, `REFERENCES genres(id) ON DELETE CASCADE`, `PRIMARY KEY (song_id, genre_id)` | foreign key to the genre assigned to song |
| `is_primary` | `BOOLEAN` | `NOT NULL`, `DEFAULT FALSE` | if primary genre for the song |

### 6`album_genres`

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `album_id` | `UUID` | `NOT NULL`, `REFERENCES albums(id) ON DELETE CASCADE`, `PRIMARY KEY (album_id, genre_id)` | foreign key to album in many-to-many association |
| `genre_id` | `SMALLINT` | `NOT NULL`, `REFERENCES genres(id) ON DELETE CASCADE`, `PRIMARY KEY (album_id, genre_id)` | foreign key to genre assigned to album |
| `is_primary` | `BOOLEAN` | `NOT NULL`, `DEFAULT FALSE` | if primary genre for the album |

### 7`song_embeddings`

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `song_id` | `UUID` | `NOT NULL`, `REFERENCES songs(id) ON DELETE CASCADE`, `PRIMARY KEY (song_id, model)` | foreign key to song the embedding belongs to |
| `model` | `VARCHAR(64)` | `NOT NULL`, `PRIMARY KEY (song_id, model)` | name of embedding model used to generate the vector |
| `dimensions` | `SMALLINT` | `NOT NULL`, `CHECK (dimensions = 512)` | number of dimensions in the embedding vector |
| `embedding` | `vector(512)` | `NOT NULL` | pgvector embedding for similarity search and recommendations |
| `created_at` | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT NOW()` | date and time when embedding was generated |

### 8`events`

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `UUID` | `PRIMARY KEY`, `DEFAULT gen_random_uuid()` | unique identifier for each listening event |
| `user_id` | `UUID` | `NOT NULL`, `REFERENCES users(id) ON DELETE CASCADE` | foreign key to the user who triggered the event |
| `song_id` | `UUID` | `NOT NULL`, `REFERENCES songs(id) ON DELETE CASCADE` | foreign key to the song associated with the event |
| `event_type` | `event_type` | `NOT NULL` | Listening event type: `play_start`, `play_end`, or `skip`|
| `ts` | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT NOW()` | timestamp when the event occurred|