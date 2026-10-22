# WordPress

WordPress + MySQL behind Traefik, with tuned PHP settings and nightly backups.

## Run

```bash
cp .env.example .env              # strong passwords: openssl rand -base64 24
cp backup.env.example backup.env
docker compose up -d
```

## Notes

- MySQL is only in the `internal` network, never reachable from outside
- `php.ini`: 64 MB uploads, OPcache on, errors logged but not shown
- The theme/plugin file editor in the admin panel is disabled (`DISALLOW_FILE_EDIT`)
- The `backup` sidecar stops the database for a consistent copy, archives both volumes and uploads them over WebDAV
