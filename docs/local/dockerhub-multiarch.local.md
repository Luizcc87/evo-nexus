# Docker Hub Multi-Arch

Este guia documenta como criar, atualizar e publicar as imagens do fork no Docker Hub com suporte a:

- `linux/amd64`
- `linux/arm64`

O objetivo é manter compatibilidade com:

- VPS Ubuntu `aarch64`
- hosts `amd64`
- Docker Swarm via Portainer

## Imagens usadas

Para deploy em Swarm, usar os Dockerfiles específicos do projeto:

- `Dockerfile.swarm` -> `evo-nexus-runtime`
- `Dockerfile.swarm.dashboard` -> `evo-nexus-dashboard`

## Pré-requisitos

- Docker com `buildx`
- login no Docker Hub
- estar na raiz do repositório

## Criar e usar um builder

```bash
docker login
docker buildx create --name evo-multiarch --use --bootstrap
docker buildx inspect --bootstrap
```

Se o builder já existir:

```bash
docker buildx use evo-multiarch
docker buildx inspect --bootstrap
```

## Shell: Bash vs PowerShell

Os exemplos com `\` no fim da linha funcionam em shells estilo Bash.

No PowerShell:

- use o comando em uma única linha
- ou use crase `` ` `` para continuação de linha

Não use `\` como continuação de linha no PowerShell.

## Publicar uma nova versão

Exemplo com a tag `2026.04.18`.

### Runtime

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f Dockerfile.swarm \
  -t luizcc87/evo-nexus-runtime:2026.04.18 \
  -t luizcc87/evo-nexus-runtime:latest \
  --push \
  .
```

PowerShell em uma linha:

```powershell
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile.swarm -t luizcc87/evo-nexus-runtime:2026.04.18 -t luizcc87/evo-nexus-runtime:latest --push .
```

PowerShell com continuação de linha:

```powershell
docker buildx build `
  --platform linux/amd64,linux/arm64 `
  -f Dockerfile.swarm `
  -t luizcc87/evo-nexus-runtime:2026.04.18 `
  -t luizcc87/evo-nexus-runtime:latest `
  --push `
  .
```

### Dashboard

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f Dockerfile.swarm.dashboard \
  -t luizcc87/evo-nexus-dashboard:2026.04.18 \
  -t luizcc87/evo-nexus-dashboard:latest \
  --push \
  .
```

PowerShell em uma linha:

```powershell
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile.swarm.dashboard -t luizcc87/evo-nexus-dashboard:2026.04.18 -t luizcc87/evo-nexus-dashboard:latest --push .
```

PowerShell com continuação de linha:

```powershell
docker buildx build `
  --platform linux/amd64,linux/arm64 `
  -f Dockerfile.swarm.dashboard `
  -t luizcc87/evo-nexus-dashboard:2026.04.18 `
  -t luizcc87/evo-nexus-dashboard:latest `
  --push `
  .
```

## Atualizar uma imagem existente

Quando houver mudanças no fork ou sincronização com o upstream:

1. atualizar o código local
2. escolher uma nova tag explícita
3. rebuildar e publicar as duas imagens
4. atualizar o stack no Portainer para a nova tag

Exemplo:

```bash
git checkout main
git fetch upstream
git merge upstream/main
git push origin main
```

Depois publicar uma nova tag, por exemplo `2026.04.20`:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f Dockerfile.swarm \
  -t luizcc87/evo-nexus-runtime:2026.04.20 \
  -t luizcc87/evo-nexus-runtime:latest \
  --push \
  .

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f Dockerfile.swarm.dashboard \
  -t luizcc87/evo-nexus-dashboard:2026.04.20 \
  -t luizcc87/evo-nexus-dashboard:latest \
  --push \
  .
```

## Verificar o manifest publicado

Confirmar se as duas arquiteturas foram publicadas:

```bash
docker buildx imagetools inspect luizcc87/evo-nexus-runtime:2026.04.18
docker buildx imagetools inspect luizcc87/evo-nexus-dashboard:2026.04.18
```

Saída esperada:

- `linux/amd64`
- `linux/arm64`

## Convenção de tags

Preferir tags explícitas em produção:

- `2026.04.18`
- `2026.04.20`
- `v0.4.2-custom.1`

Evitar usar apenas `latest` no Portainer.

## Fluxo recomendado

1. sincronizar o fork com o upstream
2. revisar as mudanças
3. publicar novas imagens multi-arch
4. atualizar `deploy/local/evonexus.stack.local.yml`
5. redeployar a stack no Portainer
6. validar dashboard, terminal e serviços em background

## Checklist rápido

```bash
docker login
docker buildx use evo-multiarch
docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile.swarm -t luizcc87/evo-nexus-runtime:2026.04.18 -t luizcc87/evo-nexus-runtime:latest --push .
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile.swarm.dashboard -t luizcc87/evo-nexus-dashboard:2026.04.18 -t luizcc87/evo-nexus-dashboard:latest --push .
docker buildx imagetools inspect luizcc87/evo-nexus-runtime:2026.04.18
docker buildx imagetools inspect luizcc87/evo-nexus-dashboard:2026.04.18
```
