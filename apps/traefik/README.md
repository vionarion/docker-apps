# Traefik

Single entry point of the server: listens on 80/443, gets certificates from Let's Encrypt and routes requests to containers by their Docker labels.

## Run

```bash
docker network create proxy        # once per server
cp .env.example .env               # set ACME_EMAIL
docker compose up -d
docker compose --profile test up -d whoami   # optional: check routing and HTTPS
```

## Notes

- HTTP is redirected to HTTPS on the entrypoint level, so apps only declare the `websecure` router
- `exposedbydefault=false`: a container is published only with `traefik.enable=true`
- Certificates are stored in `./letsencrypt/acme.json` (ignored by git); keep it with mode 600
- The Docker socket is mounted read-only; the dashboard is disabled
