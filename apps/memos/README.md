# Memos

Lightweight self-hosted notes (Markdown, tags, search). The first registered user becomes the admin.

## Run

```bash
cp .env.example .env
docker compose up -d
```

## Notes

- Data (SQLite + attachments) lives in the `memos-data` volume
- After creating the admin, disable public sign-up in the settings
