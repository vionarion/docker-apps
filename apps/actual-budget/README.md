# Actual Budget

Local-first personal finance app: envelope budgeting, accounts, reports. The server keeps the budget files and syncs them between devices.

## Run

```bash
cp .env.example .env
cp backup.env.example backup.env
docker compose up -d
```

Open `https://<APP_DOMAIN>` and set the server password on the first visit.

## Notes

- Login with a server password (`ACTUAL_LOGIN_METHOD=password`); budgets can additionally be end-to-end encrypted in the app
- `ACTUAL_TRUSTED_PROXIES` covers the Docker networks, so the server sees real client IPs from Traefik
- The `backup` sidecar briefly stops the server and uploads the `/data` volume over WebDAV every night
