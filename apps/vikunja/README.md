# Vikunja

Task manager: projects, lists, kanban, Gantt, reminders by email.

## Run

```bash
cp .env.example .env
docker compose up -d
```

Registration is disabled. Create the first user from the CLI:

```bash
docker compose exec vikunja /app/vikunja/vikunja user create -u admin -e admin@example.com
```

## Notes

- PostgreSQL is only in the `internal` network; attachments are in the `files` volume (max 10 MB each)
