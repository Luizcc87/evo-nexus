# Local Deploy

This folder is for deployment files owned by your fork or your infrastructure.

Use it for:

- Portainer stack variants
- Cloudflared notes and examples
- Docker Swarm overrides
- infrastructure-specific manifests

Convention:

- keep upstream deployment files at the repository root when they belong to the project baseline
- put your operational variants here
- do not put secrets in tracked files
- use `*.upstream.*` for local mirrors copied from upstream files
- use `*.local.*` for your own customized variants

Suggested names:

- `evonexus.stack.upstream.yml`
- `evonexus.stack.local.yml`
- `evonexus.stack.cloudflared.local.yml`
- `cloudflared-notes.md`
- `README.deploy.md`

Keep sensitive values in untracked files such as:

- `deploy/local/.env`
- `deploy/local/stack.secrets.yml`
