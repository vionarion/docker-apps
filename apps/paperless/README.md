# Paperless-ngx

Document archive with OCR (Russian + English): scans and PDFs become searchable, get tags and correspondents automatically.

## Run

```bash
cp .env.example .env
docker compose up -d
docker compose exec paperless createsuperuser
```

## Notes

- Drop files into `./consume` and they are imported automatically
- PostgreSQL and Redis are only in the `internal` network
- Documents live in the `media` volume, the index and settings in `data` and `pgdata`
