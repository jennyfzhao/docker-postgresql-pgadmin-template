#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"
ENV_FILE="$SCRIPT_DIR/.env"

usage() {
  cat <<'USAGE'
Usage: ./dbstudy.sh <command>

Commands:
  start     Start PostgreSQL and pgAdmin
  stop      Stop PostgreSQL and pgAdmin
  restart   Restart PostgreSQL and pgAdmin
  status    Show container status
  logs      Follow container logs
  open      Open pgAdmin in your browser
  help      Show this help message

First-time setup:
  cp .env.example .env
  ./dbstudy.sh start
USAGE
}

compose() {
  if [[ -f "$ENV_FILE" ]]; then
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" "$@"
  else
    docker compose -f "$COMPOSE_FILE" "$@"
  fi
}

open_url() {
  local url="${1:?URL is required}"

  if command -v open >/dev/null 2>&1; then
    open "$url"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url"
  elif command -v start >/dev/null 2>&1; then
    start "$url"
  else
    echo "Open this URL in your browser: $url"
  fi
}

case "${1:-}" in
  start)
    compose up -d
    compose ps
    ;;
  stop)
    compose stop
    ;;
  restart)
    compose restart
    compose ps
    ;;
  status)
    compose ps
    ;;
  logs)
    compose logs -f
    ;;
  open)
    if [[ -f "$ENV_FILE" ]]; then
      # shellcheck disable=SC1090
      source "$ENV_FILE"
    fi
    open_url "http://localhost:${PGADMIN_PORT:-5050}"
    ;;
  ""|-h|--help|help)
    usage
    ;;
  *)
    echo "Unknown command: $1" >&2
    echo >&2
    usage >&2
    exit 1
    ;;
esac
