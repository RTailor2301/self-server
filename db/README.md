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