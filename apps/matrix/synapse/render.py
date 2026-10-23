"""Render homeserver.yaml from the template and create the signing key once."""
import os
import subprocess
import sys

for name in ("MATRIX_DOMAIN", "DB_PASSWORD", "REGISTRATION_SECRET", "MACAROON_SECRET", "FORM_SECRET"):
    if not os.environ.get(name):
        sys.exit(f"{name} is empty, fill it in .env")

with open("/config/homeserver.yaml.template") as f:
    rendered = os.path.expandvars(f.read())
fd = os.open("/data/homeserver.yaml", os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
with os.fdopen(fd, "w") as f:
    f.write(rendered)

subprocess.run([sys.executable, "-m", "synapse.app.homeserver", "--config-path", "/data/homeserver.yaml",
                "--generate-keys"], check=True)
os.makedirs("/data/media_store", exist_ok=True)
subprocess.run(["chown", "-R", "991:991", "/data"], check=True)
