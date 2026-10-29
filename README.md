![docker-apps](assets/banner.svg)

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
- Databases and caches live in a per-app `internal` network and are never published
- Stateful apps have a backup sidecar ([docker-volume-backup](https://github.com/offen/docker-volume-backup)): nightly archive of the volumes to WebDAV storage with 7-day retention; it stops only the containers of its own app (per-app label value)

## Apps

| App | What it does | Folder |
|---|---|---|
| Traefik | Reverse proxy, Let's Encrypt certificates, HTTP → HTTPS | [apps/traefik](apps/traefik) |
| Monitoring | Prometheus, Alertmanager → Telegram, Grafana, Loki + Promtail, node-exporter, cAdvisor | [apps/monitoring](apps/monitoring) |
| Uptime Kuma | Status page and uptime checks | [apps/uptime-kuma](apps/uptime-kuma) |
| Vaultwarden | Password manager (Bitwarden-compatible) with nightly backups | [apps/vaultwarden](apps/vaultwarden) |
| n8n | Workflow automation | [apps/n8n](apps/n8n) |
| Paperless-ngx | Document archive with OCR | [apps/paperless](apps/paperless) |
| WordPress | WordPress + MySQL, tuned PHP, nightly backups | [apps/wordpress](apps/wordpress) |
| Planka | Kanban board with nightly backups | [apps/planka](apps/planka) |
| Vikunja | Task manager | [apps/vikunja](apps/vikunja) |
| FreshRSS | RSS reader + RSS-Bridge | [apps/freshrss](apps/freshrss) |
| Mealie | Recipes and meal planning | [apps/mealie](apps/mealie) |
| Memos | Lightweight notes | [apps/memos](apps/memos) |
| RustFS | S3-compatible storage for Terraform state (native lock file) | [apps/rustfs](apps/rustfs) |
| PostgreSQL | Shared database for apps that need real SQL instead of SQLite (e.g. a leads bot), nightly backups | [apps/postgresql](apps/postgresql) |
| Actual Budget | Personal finance and budgeting, nightly backups | [apps/actual-budget](apps/actual-budget) |
| Wekan | Kanban board on MongoDB, nightly backups | [apps/wekan](apps/wekan) |
| Matrix | Synapse homeserver + PostgreSQL + Element web client, nightly backups | [apps/matrix](apps/matrix) |
| MTProto proxy | Private Telegram proxy with Fake TLS (mtg) | [apps/mtproxy](apps/mtproxy) |
| GitLab Runner | CI runner with the Docker executor, plus Helm values for Kubernetes | [apps/gitlab-runner](apps/gitlab-runner) |
| Stirling-PDF | PDF toolbox in the browser: crop, merge, OCR, convert, real redaction | [apps/stirling-pdf](apps/stirling-pdf) |
| MobSF | Security scan of Android/iOS apps (APK, IPA), plus a script to scan every app on a phone over adb; for a laptop | [apps/mobsf](apps/mobsf) |

## Add a new app

```bash
cp -r _template apps/<name>
cd apps/<name>
# rename "myapp" in docker-compose.yml, describe the app in README.md
cp .env.example .env   # fill in real values on the server
docker compose up -d
```

## Upgrading databases

The images are pinned, so an upgrade is a deliberate change of the tag. For a new major version of a
database, changing the tag on a running install is not enough:

- **PostgreSQL 16 → 18**: the data format changed and the image now keeps data under
  `/var/lib/postgresql/18/docker` (the volume is mounted at `/var/lib/postgresql`). Dump with
  `pg_dumpall` on the old version, start 18 on an empty volume, restore the dump.
- **MongoDB 8 → 9**: back up with `mongodump`, then restore the dump into a fresh 9.0 volume.
- **Redis 7 → 8**: reads the existing data files, a backup before the switch is enough.
- **MySQL**: pinned to the LTS line (9.7). Moving between lines goes through `mysqldump` and a
  restore into a fresh volume.

Always take a backup first; there is no way back to the old version without one.

## Checks

Every push runs GitHub Actions:

- `docker compose config` for every compose file
- `promtool`, `amtool` and `loki -verify-config` for the monitoring stack
- [gitleaks](https://github.com/gitleaks/gitleaks) scan, so a password or token never lands in the repository
