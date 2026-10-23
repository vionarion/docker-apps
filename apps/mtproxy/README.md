# MTProto proxy

Private proxy for Telegram based on [mtg](https://github.com/9seconds/mtg). Fake TLS mode makes the traffic look like ordinary HTTPS to a popular site.

## Run

```bash
cp .env.example .env
# generate a secret for a domain the traffic should look like
docker run --rm nineseconds/mtg:2.2.8 generate-secret --hex www.google.com
# put it into MTG_SECRET in .env, then
docker compose up -d
```

Connection link for Telegram (`ee…` secret from `.env`):

```
tg://proxy?server=<server IP>&port=<MTG_PORT>&secret=<MTG_SECRET>
```

## Notes

- Replaces the old one-off `docker run` script: settings live in `.env`, the container is read-only, runs without Linux capabilities and has a memory limit
- Uses its own port instead of 443, so it doesn't fight with Traefik
- Anyone with the link can use the proxy: share it only with people you trust, and generate a new secret if it leaks
