# Variables
VERSION_FILE = version.txt      # version file
BUMPVER_FILE = .bumpversion.cfg # bump2version config file
BRANCH = main                   
BUMP_PART = patch               # default bump2version part (patch, minor, major)
TAG_PREFIX = v
DATA_DIR = data

DEV_REQUIREMENTS = ./requirements/development.txt
DEV_PORT ?= 1313

# Get the version from the version file
VERSION := $(shell cat $(VERSION_FILE))
FULL_TAG = $(TAG_PREFIX)$(VERSION)
VERSION_JSON = $(DATA_DIR)/version.json

# Default target to create a tag and a release
release: bump_version version_json commit_and_push create_tag_release

# Different release types - release-patch is the default
release-patch:
	$(MAKE) BUMP_PART=patch release

release-minor:
	$(MAKE) BUMP_PART=minor release

release-major:
	$(MAKE) BUMP_PART=major release


check:
	@echo "Root tag is $(FULL_TAG)"
	@echo "Module tag is module/$(FULL_TAG)"

init:
	pip install --upgrade pip
	pip install -r $(DEV_REQUIREMENTS)

# Run a local server for development
server: clean
	@IP=$$(ipconfig getifaddr en0 2>/dev/null || \
	      ipconfig getifaddr en1 2>/dev/null || \
	      hostname -I 2>/dev/null | awk '{print $$1}' || \
	      echo localhost); \
	echo "Using IP: $$IP"; \
	hugo server -D \
	  --disableFastRender --ignoreCache \
	  --config hugo.toml \
	  --bind 0.0.0.0 \
	  --baseURL=http://$$IP:1313/

# Target to bump version using bump2version
bump_version:
	# Ensure the branch is up-to-date and on main
	git checkout $(BRANCH)
	git pull origin $(BRANCH)
	# Bump the version (patch by default)
	bump2version $(BUMP_PART)

# Generate/refresh Hugo data file with the latest tag and date
version_json:
	VTXT=$$(cat $(VERSION_FILE)); \
	TAG="$(TAG_PREFIX)$$VTXT"; \
	DATE=$$(git log -1 --format=%cs "$$TAG" 2>/dev/null || date +%F); \
	mkdir -p $(DATA_DIR); \
	echo "{ \"tag\": \"$$TAG\", \"date\": \"$$DATE\" }" > $(VERSION_JSON); \
	echo "Wrote $(VERSION_JSON) -> $$TAG ($$DATE)"

# Target to commit and push version bump changes
commit_and_push:
	# Add the version bump changes (e.g., version.txt and .bumpversion) to git
	git add $(VERSION_FILE) $(BUMPVER_FILE) $(VERSION_JSON)
	# Commit the changes with a message including the version
	VERSION_NEW=$$(cat $(VERSION_FILE)); \
	git commit -m "Bump version to $$VERSION_NEW"
	# OLD - git commit -m "Bump version to $(VERSION)"
	# Push the commit to the main branch
	git push origin $(BRANCH)

# Optional: commit the generated data/version.json back to the repo
about_commit: version_json
	git add $(VERSION_JSON)
	git commit -m "chore: update version.json for $(FULL_TAG)" || true
	git push origin $(BRANCH) || true

# Target to create a Git tag
create_tag_release:
	# Read version fresh from file to avoid stale Make variables
	VTXT=$$(cat $(VERSION_FILE)); \
	ROOT_TAG="$(TAG_PREFIX)$$VTXT"; \
	MODULE_TAG="module/$(TAG_PREFIX)$$VTXT"; \
	\
	git tag "$$ROOT_TAG"; \
	git tag "$$MODULE_TAG"; \
	git push origin "$$ROOT_TAG"; \
	git push origin "$$MODULE_TAG"; \
	\
	$(MAKE) version_json; \
	\
	gh release create "$$ROOT_TAG" --title "Release $$ROOT_TAG" --notes "New release $$ROOT_TAG"



# Utility to specify bump type (patch, minor, major)
bump:
	# Call make with the bump part (patch, minor, major)
	make BUMP_PART=$(BUMP_PART) all

# Clean out Hugo build artifacts
clean:
	@rm -rf public resources .hugo_cache || true

# Rebuild site from scratch
rebuild: clean
	hugo --gc --cleanDestinationDir

.PHONY: all check init server bump_version commit_and_push create_tag_release bump clean rebuild version_json about_commit
