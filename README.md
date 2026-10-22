# docker-apps

Self-hosted services I run on my VPS: each app is a small Docker Compose project behind a single **Traefik** reverse proxy with automatic HTTPS.

![check](https://github.com/vionarion/docker-apps/actions/workflows/check.yml/badge.svg)

## Architecture

```mermaid
flowchart LR
    U[Internet] -->|80 / 443| T[Traefik<br/>HTTPS, Let's Encrypt]
    T -->|Host rule| A[app 1]
    T -->|Host rule| B[app 2]
    T -->|Host rule| C[app N]
    subgraph VPS [VPS · Docker]
        T
        A
        B
        C
    end
```

- One shared external network `proxy`: Traefik finds apps by Docker labels, no ports are published except 80/443
- Every app lives in its own folder with `docker-compose.yml`, `.env.example` and a README
- Secrets stay in `.env` on the server, never in git
- `restart: unless-stopped`, healthchecks and memory limits for every service

## Apps

| App | What it does | Folder |
|---|---|---|
| *coming soon* | | |

## Add a new app

```bash
cp -r _template apps/<name>
cd apps/<name>
# rename "myapp" in docker-compose.yml, describe the app in README.md
cp .env.example .env   # fill in real values on the server
docker compose up -d
```

## Checks

Every push runs GitHub Actions:

- `docker compose config` for every compose file
- [gitleaks](https://github.com/gitleaks/gitleaks) scan, so a password or token never lands in the repository
