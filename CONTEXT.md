# Contexto de Continuidade

Este repositório é um fork de `EvolutionAPI/evo-nexus` mantido por Luiz.

Objetivo atual:

- manter o fork sincronizado com o upstream
- preparar imagens próprias para Docker Hub
- usar deploy em Docker Swarm via Portainer
- expor o serviço por Traefik atrás de Cloudflare Tunnel
- manter compatibilidade com VPS Ubuntu `aarch64` e também `amd64`

## Remotes Git

- `origin` = `https://github.com/Luizcc87/evo-nexus.git`
- `upstream` = `https://github.com/EvolutionAPI/evo-nexus.git`

## Convenção de trabalho

- `main` pode continuar sendo usada enquanto as mudanças forem pequenas e controladas
- para mudanças maiores, preferir `feature/*` ou `custom/*`
- `upstream/main` = base original
- `origin/main` = espelho do fork

## Convenção de arquivos

- `*.upstream.*` = espelho ou referência alinhada ao upstream
- `*.local.*` = customização do fork ou do ambiente local

Diretórios criados para isso:

- `deploy/local/`
- `docs/local/`

Arquivos principais já adicionados:

- `README.local-customizations.md`
- `deploy/local/evonexus.stack.upstream.yml`
- `deploy/local/evonexus.stack.local.yml`
- `docs/guides/fork-dockerhub-swarm.md`

## Deploy

Topologia alvo:

`Cloudflare Tunnel -> Traefik -> EvoNexus`

O stack de referência do projeto usa Traefik. O arquivo local preparado para o fork fica em:

- `deploy/local/evonexus.stack.local.yml`

Esse arquivo deve usar:

- imagens do Docker Hub do fork (`luizcc87/...`)
- tags explícitas de versão
- hostname real do ambiente
- a rede externa do Traefik existente

## Imagens Docker

Para Swarm, usar:

- `Dockerfile.swarm`
- `Dockerfile.swarm.dashboard`

Publicação esperada com `docker buildx` para:

- `linux/arm64`
- `linux/amd64`

## Regras práticas para próximos agentes

- responder em português do Brasil
- não sobrescrever mudanças locais já existentes sem revisar
- não assumir que arquivos modificados fora da documentação podem ser descartados
- ao alterar deploy, preservar compatibilidade com Traefik
- ao alterar imagens, considerar arquitetura `arm64`
- antes de commitar, revisar `git status` para não misturar mudanças não relacionadas
