# Repository Guidelines

## Agent Scope

This file is for agent-facing instructions only. Keep user-facing usage, setup, command examples, configuration details, and troubleshooting in `README.md`. When changing runtime behavior, update `README.md` instead of duplicating those details here.

## Repository Orientation

This repository builds a Docker image for `imapfilter`. The main files are `Dockerfile`, `entrypoint.sh`, `Makefile`, `IMAPFILTER_VERSION`, `README.md`, and `.github/workflows/main.yml`. There is no separate source or test tree.

Before editing, read the file you are changing and check `README.md` for any human-facing documentation that must stay aligned. Prefer small, focused changes.

## Validation

Use the commands documented in `README.md` for local validation. At minimum, run a local image build after Dockerfile or entrypoint changes when Docker is available. For entrypoint behavior, validate with a non-production config and dry-run mode.

If you cannot run Docker or another documented command, state that clearly in your final response along with the reason.

## Documentation Check

After every code, workflow, or behavior change, check whether `README.md`, `CHANGELOG.md`, or `AGENTS.md` need updates. Update `README.md` for human-facing usage, setup, commands, configuration, or troubleshooting. Update `CHANGELOG.md` with dated entries that describe the final user-visible change set intended for the next commit or PR. Changelog bullets may cover multiple distinct outcomes, but must not describe iterative edits made while reaching the final state. Update `AGENTS.md` only for agent-facing workflow or repository instruction changes.

If no documentation update is needed, state that in the final response.

## Style

Shell code uses Bash with `#!/bin/bash`, `set -o errexit`, uppercase environment variable names, and `[[ ... ]]` conditionals. Use tabs for Makefile recipes. Keep Dockerfile changes grouped by purpose and avoid unrelated refactors.

New user-controlled environment variables should follow the `IMAPFILTER_*` pattern and be documented in `README.md`.

## Commit, PR, and Changelog Rules

Do not push directly to `main`; all changes must go through pull requests. The repository enforces signed commits and linear history.

Use conventional commit subjects, for example `docs: clarify tmpfs logging advice` or `fix: preserve extra imapfilter args`. Every commit should include a body explaining why the change is needed, what changed, and validation performed.

Every change set requires dated changelog entries in `CHANGELOG.md` using the existing standard changelog format. Write entries from the perspective of the final commit or PR, not the sequence of edits in the working session.

PRs should include a summary, validation commands, documentation updates, linked issues when available, and release-impact notes for environment variables, image tags, or GitHub Actions publishing.

## Security

Do not commit real `imapfilter` configs, credentials, logs, mailbox data, or local test artifacts. Treat mounted config directories as sensitive because they may contain passwords.
