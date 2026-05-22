# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [v2.8.2-2] - 2026-05-22

### Changed

- Added a Renovate configuration for grouped GitHub Actions updates with a 30-day minimum release age.
- Pinned the Dockerfile base image to Alpine `3.23` so future releases can deliberately adopt new Alpine `3.x` minor versions.
- Documented the Renovate maintenance workflow and its scope for developers.

## [v2.8.2-1] - 2026-05-18

### Changed

- Updated the packaged `imapfilter` version to `2.8.2`, pinned the Docker base image to Alpine `3`, removed stale explicit OpenSSL and unused network-tool package installs, and relied on the `imapfilter` package to pull its runtime dependencies from Alpine `edge/testing`.
- Added a `dgoss`-based container validation suite and CI job so pull requests can require a stable image test status check before merge.
- Extended CI container validation to run against both `amd64` and `arm64`, while keeping local `make test` behavior aligned with the host architecture by default.
- Fixed local `dgoss` execution on Apple Silicon by using a Linux `arm64` `goss` binary for container-side validation instead of the macOS host binary.

## [2026-05-18]

### Added

- Added local development command documentation to `README.md`.
- Added repository agent guidance covering documentation ownership, validation, changelog expectations, signed-commit and PR rules, and security handling.
