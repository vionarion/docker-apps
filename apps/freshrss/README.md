# FreshRSS + RSS-Bridge

Own RSS reader (works with mobile apps via the Fever / Google Reader API) and RSS-Bridge, which builds feeds for sites without RSS.

## Run

```bash
cp .env.example .env
docker compose up -d
```

Open `https://<APP_DOMAIN>` and finish the installer: database type PostgreSQL, host `db`, user and database `freshrss`, password from `.env`.

## Notes

- Feeds are refreshed by cron inside the container every 15 minutes
- PostgreSQL is only in the `internal` network
