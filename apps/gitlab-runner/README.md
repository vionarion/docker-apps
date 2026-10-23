# GitLab Runner

Self-hosted runner for GitLab CI/CD with the Docker executor: every job runs in its own container on this host.

## Run

1. In GitLab create a runner (Project or Group → Settings → CI/CD → Runners → New runner) and copy the `glrt-…` token.
2. Register and start:

```bash
cp .env.example .env            # put the token into RUNNER_TOKEN
docker compose --profile register run --rm register
docker compose up -d
```

Registration writes `config/config.toml` (git-ignored: it contains the token). After that the token can be removed from `.env`.

## Kubernetes

[k8s/values.yaml](k8s/values.yaml) runs the same runner on Kubernetes with the official Helm chart, the token kept in a Secret.

## Notes

- Jobs are not privileged; for Docker image builds prefer kaniko/buildah or a separate runner with `--docker-privileged`
- The runner gets the Docker socket, so it effectively has root on the host: use a dedicated VM and only your own projects
- `concurrent` in `config/config.toml` limits parallel jobs (default 1)
