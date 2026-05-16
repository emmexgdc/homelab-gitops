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
		find apps/$(APP_NAME)/overlays -name kustomization.yaml -exec sh -c \
			'echo "- ingress.yaml" >> $$1' _ {} \;; \
	fi

	yq -i '.spec.generators[0].matrix.generators[0].list.elements += [{"app": "$(APP_NAME)"}] | .spec.generators[0].matrix.generators[0].list.elements |= unique_by(.app)' $(APPSET_FILE)

	@echo "App created at apps/$(APP_NAME)"
	@echo "Image set to $(REGISTRY)/$(APP_NAME):latest"
	@echo "ApplicationSet updated with $(APP_NAME)"