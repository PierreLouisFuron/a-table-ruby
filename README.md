# A-Table

A recipe and menu planning app. Users create recipes (with ingredients, tags,
sources, and images), organize them into meals, and plan weekly menus by date
range.

Original project: [A Table from Julien Varlet](https://github.com/juvarlet/a_table)

## Tech Stack

- **Backend:** Rails 7.0, Ruby 3.2.2, PostgreSQL, Puma
- **Frontend:** ImportMap (no Node.js), Hotwire (Turbo + Stimulus), Bootstrap 5, jQuery
- **Images:** Active Storage with image_processing (libvips)
- **Testing:** RSpec + Shoulda Matchers + Capybara

## Local Development

```bash
# Install dependencies
bundle install

# Database (credentials read from .env — see .env.example)
bundle exec rails db:create
bundle exec rails db:migrate

# Start the dev server
bundle exec rails s

# Run the test suite
bundle exec rspec
```

Copy `.env.example` to `.env` and fill in the values for local Postgres
credentials.

---

# Deployment

A-Table can be deployed with Docker Compose. The image is
built automatically (see below), so deploying is just pulling and running.

## 1. `.env` file

Create a `.env` file next to `docker-compose.yml` on the server (see
`.env.example`):

```.env
# Rails — required in production (signs/encrypts sessions, cookies, CSRF)
SECRET_KEY_BASE=<openssl rand -hex 64>

# Database
POSTGRES_USER=a_table
POSTGRES_PASSWORD=<your-own-strong-password>
```

Then lock it down:

```bash
chmod 600 .env
```

## 2. Deploy

From the directory containing `docker-compose.yml` and `.env`:

```bash
docker compose pull   # grab the latest image from Docker Hub
docker compose up -d
```

That's it. Compose handles everything that used to be manual:

- creates the `postgres` and `rails` containers and the network between them
- creates and mounts the named volumes (`a_table_pgdata`, `a_table_images`)
- waits for Postgres to be healthy before starting Rails
- runs `rails db:prepare` on startup, so **no manual `db:create`/`db:migrate`
  is needed** — not even on the very first deploy

The app is served on port **3000**.

## Updating

To deploy a new version:

```bash
docker compose pull
docker compose up -d
```

Compose recreates only the containers whose image changed; the database and
uploaded images persist in their volumes.

## Building the image

The Docker image is built and pushed to Docker Hub automatically by GitHub
Actions ([.github/workflows/docker-publish.yml](.github/workflows/docker-publish.yml))
on every push to `main`. It builds for `linux/arm64` and publishes to `cybberbobby/a-table:latest`.

To build locally instead of pulling — e.g. to test an un-pushed change —
comment out the `image:` line in `docker-compose.yml` and uncomment `build: .`,
then run `docker compose up -d --build`.

## Useful commands

- `docker compose ps` — see the app's containers
- `docker compose logs -f rails` — follow the Rails logs
- `docker compose down` — stop and remove the containers (volumes are kept)
- `docker compose exec rails bash` — shell into the running app container
- `docker image prune` — delete dangling images

## What is `SECRET_KEY_BASE`?

A-Table is a Rails app, so it needs a `SECRET_KEY_BASE` to run in production. It
signs/encrypts sessions, cookies, CSRF tokens, etc. It should be supplied to the app
via the `.env` file. Without it the container will fail to start.

Generate one **once** with `openssl rand -hex 64` and store it in the server's
`.env` file. This keeps it stable across restarts and out of your shell history.

> ⚠️ Keep this value stable. Generating a new one later invalidates all existing
> sessions and makes any previously encrypted data undecryptable. Back it up.
