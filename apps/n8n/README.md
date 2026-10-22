# n8n

Workflow automation (webhooks, schedules, Telegram, HTTP APIs) without writing a separate service for every small integration.

## Run

```bash
cp .env.example .env   # set the domain and N8N_ENCRYPTION_KEY
docker compose up -d
```

## Notes

- Workflows and credentials are in the `n8n-data` volume (SQLite); `./local-files` is shared with workflows as `/files`
- Back up `N8N_ENCRYPTION_KEY` together with the data: without it saved credentials can't be decrypted
- Pin a version tag instead of `latest` before upgrading in production
