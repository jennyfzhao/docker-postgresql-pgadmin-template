# Docker PostgreSQL + pgAdmin Starter

This project is a beginner-friendly Docker setup for running PostgreSQL with pgAdmin.

It is useful if you want a local database for learning SQL, testing projects, or practicing PostgreSQL without installing PostgreSQL directly onto your computer.

## What This Project Runs

This setup starts two Docker containers:

- PostgreSQL: the database server
- pgAdmin: a web app for viewing and managing PostgreSQL

After starting the project, you can open pgAdmin in your browser, connect it to PostgreSQL, and begin creating databases, tables, and queries.

## Requirements

Install these first:

- Docker Desktop: https://www.docker.com/products/docker-desktop/
- Git: https://git-scm.com/

You do not need to install PostgreSQL or pgAdmin directly on your computer. Docker will download and run them for you.

## Files

```text
docker-compose.yml
dbstudy.sh
.gitignore
README.md
```

### `docker-compose.yml`

This file describes the Docker setup.

It defines:

- the PostgreSQL container
- the pgAdmin container
- the ports exposed to your computer
- the Docker volumes that save data
- the relationship between pgAdmin and PostgreSQL

### `dbstudy.sh`

This is a helper script for common commands.

Instead of typing long Docker commands, you can run:

```sh
./dbstudy.sh start
./dbstudy.sh stop
./dbstudy.sh status
./dbstudy.sh logs
```

### `.gitignore`

This prevents private local files like `.env` from being committed to GitHub.

## Quick Start

1. Clone or download this repository.

2. Open a terminal in the project folder.

3. Create your local `.env` file:

```sh
touch .env
```

4. Add your local settings to `.env`.

You can start with this template:

```env
COMPOSE_PROJECT_NAME=docker-postgres-pgadmin

POSTGRES_USER=learner
POSTGRES_PASSWORD=sqlpass
POSTGRES_DB=sql_learning
POSTGRES_PORT=5432

PGADMIN_DEFAULT_EMAIL=admin@example.com
PGADMIN_DEFAULT_PASSWORD=admin
PGADMIN_PORT=5050
```

5. Start Docker Desktop.

6. Start the containers:

```sh
./dbstudy.sh start
```

Or run Docker Compose directly:

```sh
docker compose up -d
```

7. Open pgAdmin:

```text
http://localhost:5050
```

If you used the template values above, log in with:

```text
Email: admin@example.com
Password: admin
```

## Connect pgAdmin To PostgreSQL

After logging into pgAdmin:

1. Right-click `Servers`.
2. Choose `Register` > `Server`.
3. In the `General` tab, enter a name such as:

```text
Local Docker PostgreSQL
```

4. In the `Connection` tab, use:

```text
Host name/address: postgres
Port: 5432
Maintenance database: sql_learning
Username: learner
Password: sqlpass
```

If you changed your `.env` file, use your custom database name, username, and password instead.

Important: pgAdmin uses `postgres` as the host because it is connecting from one Docker container to another Docker container. Docker Compose lets containers find each other by service name.

## Connect From Your Computer

If you connect from an app on your computer, use:

```text
Host: localhost
Port: 5432
Database: sql_learning
Username: learner
Password: sqlpass
```

If you changed `POSTGRES_PORT` in `.env`, use that port instead of `5432`.

## What Docker Is

Docker is a tool for running software in containers.

A container is an isolated environment that runs an application with its dependencies. Instead of installing PostgreSQL directly onto your computer, Docker runs PostgreSQL inside a container.

This keeps your computer cleaner and makes the setup easier to share.

The main ideas are:

```text
Image: a recipe or template for software
Container: a running copy of an image
Volume: saved data used by containers
Port: a doorway from your computer to a container
Network: a private connection between containers
```

## How This Example Works

The PostgreSQL service uses this image:

```yaml
image: postgres:18
```

That means Docker downloads the official PostgreSQL 18 image and runs it as a container.

The pgAdmin service uses this image:

```yaml
image: dpage/pgadmin4:latest
```

That means Docker downloads pgAdmin and runs it as a web app.

These services are defined in `docker-compose.yml`:

```yaml
services:
  postgres:
  pgadmin:
```

Docker Compose automatically puts both services on the same private network. Because of that, pgAdmin can connect to PostgreSQL using the service name:

```text
postgres
```

## How Data Is Saved

Database data is saved in a Docker volume:

```yaml
volumes:
  - postgres_data:/var/lib/postgresql
```

The volume keeps your PostgreSQL data even if you stop the container.

This command stops containers but keeps your data:

```sh
./dbstudy.sh stop
```

This command removes containers and volumes:

```sh
docker compose down -v
```

Be careful with `-v`. It deletes the saved database data.

## How To Customize The Setup

### Change the database name

Edit `.env`:

```env
POSTGRES_DB=my_database
```

### Change the database username

Edit `.env`:

```env
POSTGRES_USER=my_user
```

### Change the database password

Edit `.env`:

```env
POSTGRES_PASSWORD=my_password
```

For a public GitHub repo, do not commit real passwords. Keep private values in `.env`, which is ignored by Git.

### Change the PostgreSQL port

If port `5432` is already being used on your computer, change:

```env
POSTGRES_PORT=5433
```

Then connect from your computer using:

```text
localhost:5433
```

Inside Docker, pgAdmin should still use:

```text
postgres:5432
```

### Change the pgAdmin port

If port `5050` is already being used, change:

```env
PGADMIN_PORT=5051
```

Then open:

```text
http://localhost:5051
```

### Change the pgAdmin login

Edit `.env`:

```env
PGADMIN_DEFAULT_EMAIL=you@example.com
PGADMIN_DEFAULT_PASSWORD=my_admin_password
```

### Change the PostgreSQL version

Edit `docker-compose.yml`:

```yaml
image: postgres:18
```

For example:

```yaml
image: postgres:17
```

If you already have data, be careful when changing major PostgreSQL versions. A real database upgrade may be required.

## Useful Commands

Start containers:

```sh
./dbstudy.sh start
```

Stop containers:

```sh
./dbstudy.sh stop
```

Restart containers:

```sh
./dbstudy.sh restart
```

Show container status:

```sh
./dbstudy.sh status
```

Watch logs:

```sh
./dbstudy.sh logs
```

Open pgAdmin:

```sh
./dbstudy.sh open
```

Run Docker Compose directly:

```sh
docker compose up -d
docker compose ps
docker compose stop
docker compose down
```

## Back Up Your Database

Create a backup:

```sh
docker compose exec postgres pg_dump -U learner sql_learning > sql_learning_backup.sql
```

If you changed the username or database name, replace `learner` and `sql_learning`.

Restore a backup:

```sh
docker compose exec -T postgres psql -U learner sql_learning < sql_learning_backup.sql
```

## Troubleshooting

### Docker is not running

Start Docker Desktop, then try:

```sh
docker compose ps
```

### Port already in use

Change `POSTGRES_PORT` or `PGADMIN_PORT` in `.env`.

### pgAdmin cannot connect to PostgreSQL

If connecting from pgAdmin, use:

```text
Host: postgres
Port: 5432
```

Do not use `localhost` inside pgAdmin when pgAdmin is also running in Docker. Inside the pgAdmin container, `localhost` means the pgAdmin container itself, not the PostgreSQL container.

### Changed `.env`, but values did not update

PostgreSQL and pgAdmin initialize some settings only when their volumes are first created.

For a completely fresh setup:

```sh
docker compose down -v
docker compose up -d
```

Warning: this deletes saved database data.

## Publishing This To GitHub

Recommended public files:

```text
docker-compose.yml
dbstudy.sh
.gitignore
README.md
```

Do not commit:

```text
.env
.env.example
*.sql backup files with private data
```

Basic Git commands:

```sh
git init
git add .
git commit -m "Add Docker PostgreSQL pgAdmin starter"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO.git
git push -u origin main
```

Replace `YOUR-USERNAME` and `YOUR-REPO` with your actual GitHub username and repository name.

## Big Picture

```text
Your computer
  runs Docker Desktop
    runs PostgreSQL container
    runs pgAdmin container

PostgreSQL stores data in a Docker volume.
pgAdmin opens in your browser.
pgAdmin connects to PostgreSQL through Docker's private network.
```

This gives you a reusable local database setup that is easy to start, stop, customize, and share.
