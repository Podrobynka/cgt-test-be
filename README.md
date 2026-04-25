# CGT Test Backend

Rails 8 application for searching prompts.

The app provides:

- A paginated prompt list view.
- Full-text search powered by Searchkick + Elasticsearch.
- Search tuning via match strategy and operator query parameters.

The app is running on https://zoommix.me/

## Tech Stack

- Ruby 4.0.2
- Rails 8.1
- Searchkick
- Pagy
- RSpec

## System dependencies

- PostgreSQL 9.5+
- Elasticsearch 9

## Running the App (Docker)

1. Start services:

```bash
docker compose up --build
```

This starts:

- `db` (PostgreSQL)
- `elasticsearch`
- `web` (Rails)

2. Open the app:

```text
http://localhost:3000
```

## Running the App (local)

### Prerequisites

- Ruby 4.0.2
- PostgreSQL running locally
- Elasticsearch running locally at `http://localhost:9200`

### Environment

Set these variables as needed:

- `DB_HOST`
- `DB_USERNAME`
- `DB_PASSWORD`
- `ELASTICSEARCH_URL`

### Setup

```bash
bundle install
bundle exec rails db:create db:migrate
```

To build Tailwind CSS:

```bash
bundle exec rails tailwindcss:build
```

### Start

```bash
bin/dev
```

## Import Dataset

Import prompts from Parquet (default file path is `lib/data/train.parquet`):

```bash
bundle exec rake import:dataset
```
or
```bash
docker compose exec web bin/rails import:dataset
```

Custom file path and batch size:

```bash
bundle exec rake "import:dataset[/relative/path.parquet,2000]"
```

The task inserts prompt bodies and reindexes Searchkick when finished.

## Test Suite

```bash
bundle exec rspec
```
