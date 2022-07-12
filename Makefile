IMAGE := imapfilter
# override with: make BUILD_CMD=podman
BUILD_CMD ?= docker
CONFIG_DIR ?=$(shell pwd)/config
LOG_DIR ?=
_DOCKER_ENV := -e IMAPFILTER_DRY_RUN=yes  -e IMAPFILTER_VERBOSE=yes -e IMAPFILTER_CONFIG_DIR=/config $(DOCKER_ENV)
_EXTRA_DOCKER_PARAMS := $(EXTRA_DOCKER_PARAMS)

ifneq ($(LOG_DIR),)
_EXTRA_DOCKER_PARAMS := $(_EXTRA_DOCKER_PARAMS) -v $(LOG_DIR):/logs
_DOCKER_ENV := $(_DOCKER_ENV) -e IMAPFILTER_LOG_DIR=/logs
endif

DOCKER_RUN_PARAMS := -ti --rm --init  $(_EXTRA_DOCKER_PARAMS)

.PHONY: build
build:
	$(BUILD_CMD) build -t local/${IMAGE} .

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
