# RustFS

S3-compatible object storage. Here it keeps **Terraform state** with native locking (`use_lockfile`).

Why RustFS and not MinIO: MinIO Community Edition stopped publishing Docker images and binaries in October 2025 and the repository is archived.
Garage was tested too, but it ignores conditional writes (`If-None-Match: *`), so a second `terraform apply` would not be blocked.
RustFS answers `412 PreconditionFailed`, which is exactly what the S3 backend lock file relies on.

## Run

```bash
cp .env.example .env    # set domains and generate keys
docker compose up -d
```

- S3 API: `https://$APP_DOMAIN`, path-style (`/<bucket>/<key>`)
- Web console: off by default (`CONSOLE_ENABLE=true` to turn on), reachable only from `CONSOLE_ALLOWED_IPS`
- Data in the `rustfs-data` volume; one node, one disk — for redundancy back the volume up or replicate the bucket

## Bucket for Terraform state

```bash
export AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=... AWS_ENDPOINT_URL=https://s3.example.com
aws s3api create-bucket --bucket tfstate
aws s3api put-bucket-versioning --bucket tfstate --versioning-configuration Status=Enabled
```

Versioning keeps every previous state, so a broken state can be rolled back.
Use a separate access key per project with access to its bucket only.

## Terraform backend

```hcl
# backend.hcl, terraform init -backend-config=backend.hcl
bucket       = "tfstate"
key          = "project/terraform.tfstate"
region       = "us-east-1"
use_lockfile = true

endpoints                   = { s3 = "https://s3.example.com" }
use_path_style              = true
skip_credentials_validation = true
skip_requesting_account_id  = true
skip_metadata_api_check     = true
skip_region_validation      = true
```

Checked with Terraform 1.17: state migrated with `init -migrate-state`, `plan` shows no changes,
and while a `.tflock` object exists the next run fails with `Error acquiring the state lock`.
