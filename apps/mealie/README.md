# Mealie

Recipe manager and meal planner: import recipes by URL, weekly plan, shopping lists.

## Run

```bash
cp .env.example .env
docker compose up -d
```

Default login is described in the [Mealie docs](https://docs.mealie.io/); change the password right after the first login. Sign-up is disabled.

## Notes

- Data (SQLite + images) lives in the `mealie-data` volume
