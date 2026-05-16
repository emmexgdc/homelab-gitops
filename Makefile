APPSET_FILE := applicationsets/all-apps.yaml
REGISTRY := ghcr.io/emmexgdc

new-app:
	@test -n "$(APP_NAME)" || (echo "APP_NAME is required"; exit 1)
	@test -n "$(PORT)" || (echo "PORT is required"; exit 1)
	@test ! -d "apps/$(APP_NAME)" || (echo "apps/$(APP_NAME) already exists"; exit 1)

	cp -R templates/app apps/$(APP_NAME)

	find apps/$(APP_NAME) -type f -exec sed -i '' \
		-e 's|__APP_NAME__|$(APP_NAME)|g' \
		-e 's|__IMAGE__|$(REGISTRY)/$(APP_NAME)|g' \
		-e 's|__PORT__|$(PORT)|g' {} \;

	yq -i '.spec.generators[0].matrix.generators[0].list.elements += [{"app": "$(APP_NAME)"}]' $(APPSET_FILE)

	@echo "App created at apps/$(APP_NAME)"
	@echo "Image set to $(REGISTRY)/$(APP_NAME):latest"
	@echo "ApplicationSet updated with $(APP_NAME)"
