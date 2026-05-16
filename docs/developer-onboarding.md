# Developer Onboarding Flow

This platform provides standardized service scaffolding and GitOps deployment generation.
The goal is to reduce manual setup and ensure all services follow platform standards for:

- CI/CD
- Docker
- Kubernetes
- Monitoring
- Secrets
- Ingress
- ArgoCD deployment
---
# Available Workflows

## 1. Full New Service
Use this when starting a completely new service.
```bash
make platform-new-service \
  APP_NAME=my-service \
  TEMPLATE=typescript-node-api \
  PORT=8080 \
  REGISTRY=emmexgdc \
  INGRESS=true \
  HOST=my-service.homelab.emmexgdc.uk \
  MONITORING=true \
  SECRETS=true

This generates:

* starter application
* Dockerfile
* GitHub Actions workflow
* Kubernetes manifests
* ingress
* monitoring
* Vault secret integration
* ArgoCD registration

⸻

2. Starter App Only

Use this when only application scaffolding is needed.

make new-starter \
  APP_NAME=my-service \
  TEMPLATE=typescript-node-api

This generates:

* TypeScript Express starter
* Dockerfile
* GitHub Actions workflow
* health endpoint
* metrics endpoint

⸻

3. GitOps Deployment Only

Use this when the application repo already exists.

make new-app \
  APP_NAME=my-service \
  PORT=8080 \
  REGISTRY=emmexgdc \
  INGRESS=true \
  HOST=my-service.homelab.emmexgdc.uk \
  MONITORING=true \
  SECRETS=true

This generates only Kubernetes and GitOps deployment files.

⸻

4. Create GitHub Repository

Use this after generating a starter application locally.

make new-repo APP_NAME=my-service

This will:

* initialize git
* create GitHub repository
* push initial code

⸻

Supported Templates

Currently supported templates:

* typescript-node-api

More templates can be added later:

* react-frontend
* fastapi
* golang-api
* background-worker
* fullstack-app

⸻

Platform Design Goals

The platform standardizes:

* deployment structure
* CI/CD
* security defaults
* observability
* ingress patterns
* secrets management
* GitOps onboarding

This reduces repeated manual setup across teams.
