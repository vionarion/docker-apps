# mobsf

[MobSF](https://github.com/MobSF/Mobile-Security-Framework-MobSF) (Mobile Security Framework) — static
security analysis of Android and iOS apps: dangerous permissions, hardcoded keys, cleartext HTTP,
weak crypto, exported components, trackers and known-vulnerable libraries, with a 0–100 security score
and a PDF report per app.

Unlike the other apps here it is meant for a **laptop**, not the VPS: it listens on `127.0.0.1` only,
has no Traefik labels and keeps everything (SQLite, uploads, reports) in one volume.

## Run

```bash
cp .env.example .env   # set MOBSF_PASSWORD and MOBSF_API_KEY (openssl rand -hex 32)
docker compose up -d
```

Open `http://127.0.0.1:8000`, log in as `mobsf` with `MOBSF_PASSWORD`, drop an APK on the page.
The first start takes a minute or two (database migrations); the image is ~1.8 GB.

## Scan the apps on your phone

1. On the phone: Settings → About → tap «Build number» 7 times, then Developer options → USB debugging.
2. Connect it over USB and confirm the prompt; `adb devices` must show `device`.
3. Run:

```bash
./scan-phone.sh          # every app you installed (system apps are skipped)
./scan-phone.sh bank     # only packages whose name contains "bank"
```

The script pulls each app's `base.apk` into `apks/`, uploads it through the REST API, waits for the
scan and writes `results-<date>.tsv` sorted by score, lowest (most worrying) first. Open the full
report for any app at `http://127.0.0.1:8000/recent_scans/`. Needs `adb`, `curl` and `jq`
(`sudo apt install adb jq`). One scan takes from ~30 s to a few minutes for big apps.

## Reading the results

- **Score** below ~40 and several **high** findings is worth a look, but it is not a verdict:
  many big apps score low because of legitimate things (WebView, broad permissions).
- Look first at: hardcoded secrets, `android:usesCleartextTraffic`, `debuggable=true`,
  exported activities/providers without permissions, Accessibility and device-admin permissions.
- MobSF finds weak spots in code, not malware. For malware, check the APK on VirusTotal.

## Notes

- Data: `mobsf-data` volume (SQLite, uploads, reports). Remove everything: `docker compose down -v`.
- Updates: bump the image tag in `docker-compose.yml`, then `docker compose pull && docker compose up -d`.
- `MOBSF_PASSWORD` is applied on the first start only; to change it later, use the web UI.
- Dynamic analysis (running the app in an emulator) is not set up here; static analysis covers most needs.
