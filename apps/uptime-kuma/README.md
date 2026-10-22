# Uptime Kuma

Status page and uptime checks for my sites and services (HTTP, TCP, ping, keyword), with notifications to Telegram.

## Run

```bash
cp .env.example .env
docker compose up -d
```

Open `https://<APP_DOMAIN>` and create the admin user on first visit.

## Notes

- Data (SQLite) lives in the `kuma-data` volume
- Update: `docker compose pull && docker compose up -d`
