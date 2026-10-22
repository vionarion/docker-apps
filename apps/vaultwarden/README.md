# Vaultwarden

Self-hosted password manager compatible with all Bitwarden apps and browser extensions.

## Run

```bash
cp .env.example .env
cp backup.env.example backup.env
# admin token: hash a strong password with Argon2
echo -n 'your-admin-password' | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4
docker compose up -d
```

## Notes

- Sign-ups are disabled: users are invited from the admin panel (`/admin`)
- Mail (invites, 2FA codes) goes through SMTP; mobile push via the Bitwarden relay
- The `backup` sidecar archives the `vaultwarden-data` volume every night and uploads it over WebDAV, keeping 7 days
- Restore: stop the stack, unpack the archive into the volume, start again
