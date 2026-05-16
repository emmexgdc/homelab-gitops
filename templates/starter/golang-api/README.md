# __APP_NAME__

Go API service generated from the homelab platform template.

## Run locally

```bash

go run ./cmd/api

GET /
GET /healthz
GET /metrics

docker build -t __APP_NAME__:local .
docker run --rm -p 8080:8080 __APP_NAME__:local

