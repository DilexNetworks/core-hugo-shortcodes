SHELL := /usr/bin/env bash
.SHELLFLAGS := -euo pipefail -c

# Variables
VERSION_FILE = version.txt      # version file
BUMPVER_FILE = .bumpversion.cfg # bump2version config file
BRANCH = main
BUMP_PART = patch               # default bump2version part (patch, minor, major)
TAG_PREFIX = v
DATA_DIR = data
VALID_RELEASE_TYPES = patch minor major

DEV_REQUIREMENTS = ./requirements/development.txt
DEV_PORT ?= 1313

# Release safety latch (must be explicitly enabled)
RELEASE ?=

# ---- Release Guards ----

require_release:
	@if [ -z "$(RELEASE)" ]; then \
	  echo "❌ Refusing to run release without explicit confirmation."; \
	  echo "   Use: make release RELEASE=patch|minor|major"; \
	  exit 2; \
	fi
	@if ! echo "$(VALID_RELEASE_TYPES)" | grep -qw "$(RELEASE)"; then \
    	  echo "❌ Invalid RELEASE type: '$(RELEASE)'"; \
    	  echo "   Valid values: patch, minor, major"; \
    	  exit 2; \
	fi

check_version:
	@V=$$(tr -d ' \t\n\r' < $(VERSION_FILE) 2>/dev/null || true); \
	if [ -z "$$V" ]; then \
	  echo "❌ $(VERSION_FILE) is empty or missing"; \
	  exit 2; \
	fi; \
	# Strict SemVer: X.Y.Z (numbers only)
	if ! echo "$$V" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$$'; then \
	  echo "❌ $(VERSION_FILE) must contain a SemVer like 1.2.3 (got: '$$V')"; \
	  exit 2; \
	fi

check_branch:
	@b=$$(git rev-parse --abbrev-ref HEAD); \
	[ "$$b" = "$(BRANCH)" ] || { echo "❌ Must release from $(BRANCH), currently $$b"; exit 2; }

check_clean:
	@git diff --quiet && git diff --cached --quiet || { echo "❌ Working tree is not clean"; exit 2; }

check_up_to_date:
	@git fetch origin $(BRANCH) >/dev/null 2>&1; \
	l=$$(git rev-parse HEAD); r=$$(git rev-parse origin/$(BRANCH)); \
	[ "$$l" = "$$r" ] || { echo "❌ $(BRANCH) is not up to date with origin/$(BRANCH)"; exit 2; }

check_tags:
	@V=$$(cat $(VERSION_FILE)); \
	ROOT="$(TAG_PREFIX)$$V"; \
	MOD="module/$(TAG_PREFIX)$$V"; \
	git rev-parse "$$ROOT" >/dev/null 2>&1 && { echo "❌ Tag $$ROOT already exists"; exit 2; } || true; \
	git rev-parse "$$MOD"  >/dev/null 2>&1 && { echo "❌ Tag $$MOD already exists"; exit 2; } || true

check_gh:
	@gh auth status >/dev/null 2>&1 || { echo "❌ GitHub CLI not authenticated (run gh auth login)"; exit 2; }

preflight: check_version check_branch check_clean check_up_to_date check_tags check_gh

# Get the version from the version file
VERSION := $(shell cat $(VERSION_FILE))
FULL_TAG = $(TAG_PREFIX)$(VERSION)
VERSION_JSON = $(DATA_DIR)/version.json

# Default target to create a tag and a release
release: require_release preflight
	$(MAKE) BUMP_PART=$(RELEASE) bump_version version_json commit_and_push create_tag_release

# Different release types - release-patch is the default
release-patch:
	$(MAKE) RELEASE=patch release

release-minor:
	$(MAKE) RELEASE=minor release

release-major:
	$(MAKE) RELEASE=major release


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
	VTXT=$$(tr -d ' \t\n\r' < $(VERSION_FILE) 2>/dev/null || true); \
	[ -n "$$VTXT" ] || { echo "❌ $(VERSION_FILE) is empty or missing"; exit 2; }; \
	TAG="$(TAG_PREFIX)$$VTXT"; \
	DATE=$$(git log -1 --format=%cs HEAD); \
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
	VTXT=$$(tr -d ' \t\n\r' < $(VERSION_FILE) 2>/dev/null || true); \
	[ -n "$$VTXT" ] || { echo "❌ $(VERSION_FILE) is empty or missing"; exit 2; }; \
	ROOT_TAG="$(TAG_PREFIX)$$VTXT"; \
	MODULE_TAG="module/$(TAG_PREFIX)$$VTXT"; \
	\
	git tag "$$ROOT_TAG"; \
	git tag "$$MODULE_TAG"; \
	git push origin "$$ROOT_TAG"; \
	git push origin "$$MODULE_TAG"; \
	\
	gh release create "$$ROOT_TAG" \
		--title "Release $$ROOT_TAG" \
		--generate-notes



# Utility to specify bump type (patch, minor, major)
#bump:
	# Call make with the bump part (patch, minor, major)
#	make BUMP_PART=$(BUMP_PART) all

# Clean out Hugo build artifacts
clean:
	@rm -rf public resources .hugo_cache || true

# Rebuild site from scratch
rebuild: clean
	hugo --gc --cleanDestinationDir

.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "Safe targets:"
	@echo "  make server"
	@echo "  make clean"
	@echo ""
	@echo "Release (explicit opt-in required):"
	@echo "  make release RELEASE=patch"
	@echo "  make release RELEASE=minor"
	@echo "  make release RELEASE=major"
	@echo ""

.PHONY: check init server bump_version commit_and_push create_tag_release bump clean rebuild version_json about_commit help require_release preflight check_branch check_clean check_up_to_date check_tags check_gh check_version
