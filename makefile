# Read extension names and versions from the config file
EXTENSIONS_CONFIG := extensions.config
EXTENSION_NAMES := $(shell awk '{print $$1}' $(EXTENSIONS_CONFIG))
EXTENSION_VERSIONS := $(shell awk '{print $$2}' $(EXTENSIONS_CONFIG))

# Define the target to fetch extensions
.PHONY: fetch-extensions
fetch-extensions: create-extensions-folder
	@$(foreach name,$(EXTENSION_NAMES), \
		$(eval version := $(word 1, $(EXTENSION_VERSIONS))) \
		$(eval EXTENSION_VERSIONS := $(wordlist 2,$(words $(EXTENSION_VERSIONS)),$(EXTENSION_VERSIONS))) \
		echo "Fetching $(name) (version: $(version))"; \
		git clone --branch $(version) https://gerrit.wikimedia.org/r/mediawiki/extensions/$(name) extensions/$(name); \
	)

# Define the target to create the extensions folder
.PHONY: create-extensions-folder
create-extensions-folder:
	@mkdir -p extensions

# Define the target to update LocalSettings.php
.PHONY: update-local-settings
update-local-settings:
	@echo "Updating LocalSettings.php"
	@echo "" >> LocalSettings.php
	@echo "// Automatically added extensions" >> LocalSettings.php
	@$(foreach name,$(EXTENSION_NAMES), \
		echo "wfLoadExtension('$(name)');" >> LocalSettings.php; \
	)
