# Wekan

Open-source kanban board (Trello alternative) with swimlanes, checklists, due dates and a REST API.

## Run

```bash
cp .env.example .env
cp backup.env.example backup.env
docker compose up -d
```

The first account registered at `https://<APP_DOMAIN>` becomes the admin. After that, turn off open registration in Admin Panel → Settings.

## Notes

- MongoDB runs with authentication and lives only in the `internal` network; its cache is capped at 256 MB so it fits a small VPS
- `DB_PASSWORD` goes into the MongoDB URL, so use only letters and digits
- The `backup` sidecar briefly stops Wekan and MongoDB for a consistent copy of the files and the database, then uploads it over WebDAV
