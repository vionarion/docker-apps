# postgresql

Shared PostgreSQL instance for apps that need a real database (e.g. a leads/CRM bot) instead of their
own SQLite file. No web UI, not exposed through Traefik — only reachable from other containers on the
same host over the `pg-internal` Docker network.

## Run

```bash
cp .env.example .env   # set POSTGRES_USER/PASSWORD/DB for the first database
docker compose up -d
```

## Connect another app to it

In the other app's `docker-compose.yml`, add the network as external and point its DB connection string
at host `postgres`, port `5432`:

```yaml
services:
  myapp:
    networks: [proxy, pg-internal]
    # DATABASE_URL=postgresql://user:password@postgres:5432/dbname

networks:
  pg-internal:
    external: true
```

## Add another database

One instance can hold several apps' databases. Create a new one without restarting:

```bash
docker exec -it postgres psql -U "$POSTGRES_USER" -c "CREATE DATABASE dbname;"
```

## Notes

- Data: `pgdata` volume; nightly backup via `offen/docker-volume-backup` stops the container for a
  consistent snapshot, then uploads to WebDAV (same pattern as the other apps in this repo)
- Back up `.env` together with the data: without `POSTGRES_PASSWORD` you can still reset it, but
  connected apps will need the new value too
