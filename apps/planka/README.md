# Planka

Trello-like kanban board for personal and team projects.

## Run

```bash
cp .env.example .env
cp backup.env.example backup.env
docker compose up -d
```

## Notes

- The admin account is created from `ADMIN_EMAIL` / `ADMIN_PASSWORD` on first start
- PostgreSQL uses a password and lives only in the `internal` network
- The `backup` sidecar briefly stops Planka and the database for a consistent copy, then archives all volumes and uploads them over WebDAV
- PLANKA 2 keeps all uploads in one `data` volume (`/app/data`). Upgrading an existing 1.x install
  is a one-way migration of the database and files: take a backup first and follow the
  [official upgrade guide](https://docs.planka.cloud/docs/upgrade-to-v2/docker)
