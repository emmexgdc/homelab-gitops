.PHONY: new-app new-starter new-repo platform-new-service list-templates gitops-pr

APPSET_FILE := applicationsets/all-apps.yaml
REGISTRY ?= ghcr.io/emmexgdc

new-app:
	@test -n "$(APP_NAME)" || (echo "APP_NAME is required"; exit 1)
	@test -n "$(PORT)" || (echo "PORT is required"; exit 1)
	@test ! -d "apps/$(APP_NAME)" || (echo "apps/$(APP_NAME) already exists"; exit 1)

	cp -R templates/app apps/$(APP_NAME)

	find apps/$(APP_NAME) -type f -exec sed -i '' \
		-e 's|__APP_NAME__|$(APP_NAME)|g' \
		-e 's|__IMAGE__|$(REGISTRY)/$(APP_NAME)|g' \
		-e 's|__PORT__|$(PORT)|g' {} \;

	@if [ "$(INGRESS)" != "true" ]; then \
		rm -f apps/$(APP_NAME)/overlays/dev/ingress.yaml; \
		rm -f apps/$(APP_NAME)/overlays/staging/ingress.yaml; \
		rm -f apps/$(APP_NAME)/overlays/prod/ingress.yaml; \
	else \
		test -n "$(HOST)" || (echo "HOST is required when INGRESS=true"; exit 1); \
		find apps/$(APP_NAME) -name ingress.yaml -exec sed -i '' \
			-e 's|__HOST__|$(HOST)|g' {} \;; \
		find apps/$(APP_NAME)/overlays -name kustomization.yaml -exec yq -i '.resources += ["ingress.yaml"]' {} \;; \
	fi

	@if [ "$(MONITORING)" != "true" ]; then \
		rm -f apps/$(APP_NAME)/base/servicemonitor.yaml; \
	else \
		echo "- servicemonitor.yaml" >> apps/$(APP_NAME)/base/kustomization.yaml; \
	fi

	@if [ "$(SECRETS)" != "true" ]; then \
		rm -f apps/$(APP_NAME)/base/externalsecret.yaml; \
	else \
		echo "- externalsecret.yaml" >> apps/$(APP_NAME)/base/kustomization.yaml; \
	fi

	yq -i '.spec.generators[0].matrix.generators[0].list.elements += [{"app": "$(APP_NAME)"}] | .spec.generators[0].matrix.generators[0].list.elements |= unique_by(.app)' $(APPSET_FILE)

	@echo "App created at apps/$(APP_NAME)"
	@echo "Image set to $(REGISTRY)/$(APP_NAME):latest"
	@echo "ApplicationSet updated with $(APP_NAME)"

new-starter:
	@test -n "$(APP_NAME)" || (echo "APP_NAME is required"; exit 1)
	@test -n "$(TEMPLATE)" || (echo "TEMPLATE is required"; exit 1)
	@test -d "templates/starter/$(TEMPLATE)" || (echo "templates/starter/$(TEMPLATE) does not exist"; exit 1)
	@test ! -d "../$(APP_NAME)" || (echo "../$(APP_NAME) already exists"; exit 1)

	cp -R templates/starter/$(TEMPLATE) ../$(APP_NAME)

	find ../$(APP_NAME) -type f -exec sed -i '' \
		-e 's|__APP_NAME__|$(APP_NAME)|g' {} \;

	@echo "Starter app created at ../$(APP_NAME)"

platform-new-service: new-starter new-app
	@echo "Platform service created"
	@echo "Starter app: ../$(APP_NAME)"
	@echo "GitOps app: apps/$(APP_NAME)"

new-repo:
	@test -n "$(APP_NAME)" || (echo "APP_NAME is required"; exit 1)
	@test -d "../$(APP_NAME)" || (echo "../$(APP_NAME) does not exist"; exit 1)

	cd ../$(APP_NAME) && \
	git init && \
	git add . && \
	git commit -m "initial commit" && \
	gh repo create emmexgdc/$(APP_NAME) --private --source=. --remote=origin --push

	@echo "GitHub repo created and pushed: emmexgdc/$(APP_NAME)"

list-templates:
	@echo "Available starter templates:"
	@find templates/starter -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort

gitops-pr:
	@test -n "$(APP_NAME)" || (echo "APP_NAME is required"; exit 1)
	@test -d "apps/$(APP_NAME)" || (echo "apps/$(APP_NAME) does not exist"; exit 1)

	git checkout -b add-$(APP_NAME)
	git add apps/$(APP_NAME) applicationsets/all-apps.yaml
	git commit -m "add $(APP_NAME) gitops manifests"
	git push -u origin add-$(APP_NAME)
	gh pr create \
		--title "Add $(APP_NAME) GitOps manifests" \
		--body "Adds GitOps deployment manifests for $(APP_NAME)."