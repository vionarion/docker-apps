# Stirling-PDF

All-in-one PDF toolbox in the browser: crop, merge, split, rotate, compress, OCR, convert to/from images and Office, sign, and **real redaction** (the hidden text is removed from the file, not just covered with a box). Files are processed on your own server and are not stored after the job.

## Run

```bash
cp .env.example .env   # set the domain and the admin password
docker compose up -d
```

Open `https://<APP_DOMAIN>` and log in with `ADMIN_USER` / `ADMIN_PASSWORD`.

## Notes

- Login is on (`SECURITY_ENABLELOGIN`): documents are often personal, so the instance is not public
- Java + LibreOffice + Tesseract: the first start takes about a minute, memory limit 1.5 GB (`MEMORY_LIMIT`)
- Settings and users live in the `stirling-config` volume, OCR language data in `stirling-tessdata`
- Uploads up to 100 MB (`SYSTEM_MAXFILESIZE` plus the Traefik buffering middleware)
- Edition is chosen in `.env` (`EDITION`): full (default), `-ultra-lite` (no LibreOffice/OCR, ~300 MB RAM, set `MEMORY_LIMIT=512m`) or `-fat` (extra fonts, offline)
