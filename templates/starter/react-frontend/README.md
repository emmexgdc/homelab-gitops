# __APP_NAME__

React frontend generated from the homelab platform template.

## Run locally

```bash

npm install

npm run dev

npm run build


docker build -t __APP_NAME__:local .
docker run --rm -p 8080:8080 __APP_NAME__:local

 GET /healthz