# Fork, Docker Hub and Portainer/Swarm

This guide is for the case where you:

- keep a personal fork of `evo-nexus`
- add your own fixes or customizations
- publish your own Docker images
- deploy with Docker Swarm through Portainer

It complements [Updating EvoNexus](updating.md) and [README.swarm.md](../../README.swarm.md).

## Recommended branch strategy

Use two remotes:

- `origin` -> your fork
- `upstream` -> the original `evo-nexus` repository

Keep `main` as close as possible to upstream and do your custom work in feature branches.

Example:

```bash
git clone https://github.com/YOUR_USER/evo-nexus.git
cd evo-nexus
git remote add upstream https://github.com/ORIGINAL_OWNER/evo-nexus.git
git remote -v
```

## Merge vs rebase

For this workflow:

- use `merge` to sync your fork's `main` with `upstream/main`
- use `rebase` only on your local work branches when you want a cleaner history

Why:

- `merge` does not rewrite history and is safer for a branch you may push and reuse often
- `rebase` rewrites commit SHAs and is better kept to local or controlled branches

## Update your fork from upstream

Sync your `main`:

```bash
git checkout main
git fetch upstream
git merge upstream/main
git push origin main
```

If you keep your custom changes in a separate branch:

```bash
git checkout feature/my-customizations
git merge main
```

If you prefer a linear history on the feature branch:

```bash
git checkout feature/my-customizations
git rebase main
git push --force-with-lease origin feature/my-customizations
```

## Build and publish your own images

After syncing and validating your changes, build your images and push them to Docker Hub.

Example:

```bash
docker build -f Dockerfile -t YOUR_DOCKERHUB_USER/evo-nexus-runtime:2026.04.17 .
docker build -f Dockerfile.dashboard -t YOUR_DOCKERHUB_USER/evo-nexus-dashboard:2026.04.17 .

docker push YOUR_DOCKERHUB_USER/evo-nexus-runtime:2026.04.17
docker push YOUR_DOCKERHUB_USER/evo-nexus-dashboard:2026.04.17
```

Avoid relying only on `latest`. Prefer versioned tags such as:

- `2026.04.17`
- `0.4.2-custom.1`
- `v0.4.2-uazapi.3`

Versioned tags make rollback much simpler in Swarm.

## Update the stack in Portainer / Swarm

If your stack file points to your own images, update the tags and redeploy the stack.

Example:

```yaml
services:
  evonexus_dashboard:
    image: YOUR_DOCKERHUB_USER/evo-nexus-dashboard:2026.04.17

  evonexus_telegram:
    image: YOUR_DOCKERHUB_USER/evo-nexus-runtime:2026.04.17

  evonexus_scheduler:
    image: YOUR_DOCKERHUB_USER/evo-nexus-runtime:2026.04.17
```

In Portainer:

1. Open the stack.
2. Change the image tags.
3. Redeploy.

If you deploy with CLI instead of Portainer:

```bash
docker stack deploy -c evonexus.stack.yml evonexus
```

## Recommended production flow

Use this order whenever upstream releases changes:

1. Fetch and merge `upstream/main` into your fork's `main`.
2. Update your customization branch from `main`.
3. Resolve conflicts and test locally.
4. Build new runtime and dashboard images.
5. Push both images to Docker Hub with a new versioned tag.
6. Update the stack in Portainer and redeploy.
7. If needed, roll back by restoring the previous image tag.

## Conflict handling

If upstream changes the same files you customized, Git may report conflicts during `merge` or `rebase`.

In that case:

1. Resolve the conflicting files manually.
2. Run `git add <file>` for each resolved file.
3. Finish the operation:

For merge:

```bash
git commit
```

For rebase:

```bash
git rebase --continue
```

If the rebase becomes messy, abort it:

```bash
git rebase --abort
```

## Practical recommendation

For a maintained fork in production:

- `main`: mirror of upstream, updated with `merge`
- `feature/*` or `custom/*`: your own changes
- Docker Hub: publish your own versioned images
- Portainer/Swarm: always redeploy with explicit tags, not only `latest`

This gives you a safer update path, clearer rollback, and less risk when upstream changes land.
