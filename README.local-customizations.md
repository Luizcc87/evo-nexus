# Upstream vs Local Customizations

This repository follows a simple separation model:

- `upstream/main`: original EvoNexus project baseline
- `origin/main`: your fork's mirror of upstream
- `feature/*` or `custom/*`: your changes

## Directory convention

Use the repository like this:

- `docs/` for project documentation that belongs to the forked codebase
- `docs/local/` for your fork-specific or operational documentation
- `deploy/local/` for your Swarm, Portainer, Cloudflared, and infrastructure-specific files

## Naming convention

Use file names to show ownership clearly:

- `*.upstream.*`: local mirror or reference copy of something that comes from upstream
- `*.local.*`: your customized or operational version

Examples:

- `evonexus.stack.upstream.yml`
- `evonexus.stack.local.yml`
- `updating.upstream.md`
- `portainer-rollout-checklist.local.md`

Recommended interpretation:

- `upstream` means "copied from or kept aligned with the original project"
- `local` means "owned by my fork, my environment, or my operational process"

## What belongs to upstream

Treat these as baseline project files unless you intentionally need to change them:

- application code
- root Dockerfiles
- root stack files
- project docs shared by all environments

Keep changes to these files focused and easy to review.

## What belongs to your customization layer

Prefer placing your own material in:

- `docs/local/`
- `deploy/local/`
- feature branches such as `feature/swarm-cloudflare`

This makes it easier to:

- compare against `upstream/main`
- review your own operational changes
- update the fork when upstream changes land

## What should stay untracked

Do not commit:

- secrets
- environment-specific credentials
- private operational notes

Use ignored files such as:

- `deploy/local/.env`
- `deploy/local/*.secrets.yml`
- `docs/local/private/`

## Quick Git checks

See what changed compared with upstream:

```bash
git diff --name-status upstream/main...HEAD
```

See commits that only exist in your branch:

```bash
git log --oneline upstream/main..HEAD
```
