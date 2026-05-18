IMAGE := imapfilter
# override with: make BUILD_CMD=podman
BUILD_CMD ?= docker
DGOSS_CMD ?= dgoss
BUILD_EXTRA_ARGS ?=
TEST_PLATFORM ?=
DGOSS_GOSS_PATH ?=
CONFIG_DIR ?=$(shell pwd)/config
LOG_DIR ?=
_DOCKER_ENV := -e IMAPFILTER_DRY_RUN=yes  -e IMAPFILTER_VERBOSE=yes -e IMAPFILTER_CONFIG_DIR=/config $(DOCKER_ENV)
_EXTRA_DOCKER_PARAMS := $(EXTRA_DOCKER_PARAMS)
_DGOSS_ENV :=
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifneq ($(LOG_DIR),)
_EXTRA_DOCKER_PARAMS := $(_EXTRA_DOCKER_PARAMS) -v $(LOG_DIR):/logs
_DOCKER_ENV := $(_DOCKER_ENV) -e IMAPFILTER_LOG_DIR=/logs
endif

ifneq ($(TEST_PLATFORM),)
_DGOSS_ENV := DOCKER_DEFAULT_PLATFORM=$(TEST_PLATFORM)
endif

ifeq ($(DGOSS_GOSS_PATH),)
ifeq ($(UNAME_S),Darwin)
ifeq ($(UNAME_M),arm64)
DGOSS_GOSS_PATH := /Users/sandipb/bin/goss-linux-arm64
endif
endif
endif

DOCKER_RUN_PARAMS := -ti --rm --init  $(_EXTRA_DOCKER_PARAMS)

.PHONY: build
build:
	$(BUILD_CMD) build $(BUILD_EXTRA_ARGS) -t local/${IMAGE} .

.PHONY: test
test: build
	@command -v $(DGOSS_CMD) >/dev/null 2>&1 || { echo "$(DGOSS_CMD) is required"; exit 1; }
	@tmp_dir=$$(mktemp -d /tmp/imapfilter-goss.XXXXXX); \
	trap 'rm -rf "$$tmp_dir"' EXIT; \
	cp $(CURDIR)/goss.yaml "$$tmp_dir/goss.yaml"; \
	printf 'imapfilter_version: %s\n' "$$(cat IMAPFILTER_VERSION)" > "$$tmp_dir/vars.yaml"; \
	$(_DGOSS_ENV) GOSS_FILES_PATH="$$tmp_dir" GOSS_VARS="vars.yaml" \
	GOSS_PATH="$(DGOSS_GOSS_PATH)" $(DGOSS_CMD) run --rm --entrypoint sh local/${IMAGE} -c "sleep 30"

## Update the base imapfilter version file
.PHONY: update-version
update-version:
	docker run --rm --entrypoint imapfilter local/imapfilter -V 2>&1 | awk '{print $$2}' > IMAPFILTER_VERSION

# Can run like:
#  - Custom config: make run EXTRA_DOCKER_PARAMS="--user 1025:1025" CONFIG_DIR=/etc/imapfilter
#  - Custom log dir: make run EXTRA_DOCKER_PARAMS="--user 1025:1025" CONFIG_DIR=/etc/imapfilter LOG_DIR=/var/log/imapfilter
.PHONY: run
run:
	$(BUILD_CMD) run  $(DOCKER_RUN_PARAMS) \
		 $(_DOCKER_ENV) \
		--name=${IMAGE}-local -v $(CONFIG_DIR):/config \
		local/${IMAGE}
