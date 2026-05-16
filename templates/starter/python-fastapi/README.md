# __APP_NAME__

Python FastAPI service generated from the homelab platform template.

## Run locally

```bash

pip install -r requirements.txt

uvicorn app.main:app --host 0.0.0.0 --port 8080

GET /

GET /healthz

GET /metrics

docker build -t __APP_NAME__:local .
docker run --rm -p 8080:8080 __APP_NAME__:local