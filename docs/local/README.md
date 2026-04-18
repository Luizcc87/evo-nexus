# Local Customization Notes

This folder is for documentation owned by your fork and your operation.

Use it for:

- deployment decisions
- branch and release notes
- integration notes for your environment
- rollback and operational checklists

Convention:

- upstream product documentation stays in `docs/`
- your operational or fork-specific notes go in `docs/local/`
- private notes that must not be committed can live under `docs/local/private/`
- use `*.upstream.*` when you want to keep a reference copy of an upstream document
- use `*.local.*` for your own documentation derived from or extending upstream guidance

Suggested files:

- `fork-strategy.local.md`
- `dockerhub-tags.local.md`
- `portainer-rollout-checklist.local.md`
- `cloudflare-tunnel-routing.local.md`
- `updating.upstream.md`
