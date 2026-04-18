# AGENTS.md

## Objetivo deste arquivo

Este arquivo orienta agentes de IA que continuarem o trabalho neste fork.

## Contexto do projeto

- Repositório forkado de `EvolutionAPI/evo-nexus`
- Fork atual: `Luizcc87/evo-nexus`
- Deploy alvo: Docker Swarm via Portainer
- Entrada externa: Cloudflare Tunnel
- Roteamento interno: Traefik
- Infra principal: VPS Ubuntu ARM64 (`aarch64`)

## Prioridades atuais

1. Manter o fork sincronizado com `upstream`
2. Isolar customizações do fork de forma organizada
3. Publicar imagens próprias no Docker Hub
4. Preparar stack de produção compatível com Traefik + Cloudflare Tunnel

## Git e branches

- `origin` aponta para o fork do Luiz
- `upstream` aponta para o repositório original
- `main` representa a linha ativa do fork
- Para mudanças maiores, preferir `feature/*` ou `custom/*`

Fluxo de sincronização esperado:

```bash
git checkout main
git fetch upstream
git merge upstream/main
git push origin main
```

## Convenção de organização local

Usar esta separação:

- `deploy/local/` para stacks, overrides e arquivos de infraestrutura do fork
- `docs/local/` para documentação operacional e notas do fork

Convenção de nomes:

- `*.upstream.*` para espelhos, referências ou cópias alinhadas ao upstream
- `*.local.*` para variantes do fork, do ambiente ou da operação local

Exemplos:

- `deploy/local/evonexus.stack.upstream.yml`
- `deploy/local/evonexus.stack.local.yml`
- `docs/local/portainer-rollout-checklist.local.md`

## Deploy e imagens

Usar os Dockerfiles de Swarm:

- `Dockerfile.swarm`
- `Dockerfile.swarm.dashboard`

As imagens devem ser publicadas com suporte a:

- `linux/arm64`
- `linux/amd64`

Evitar usar apenas `latest` em produção. Preferir tags explícitas.

## Cuidados importantes

- Sempre revisar `git status` antes de editar ou commitar
- Não incluir por engano mudanças locais não relacionadas
- Não remover alterações do usuário sem instrução explícita
- Preservar a topologia `Cloudflare Tunnel -> Traefik -> EvoNexus`
- Ao editar stacks, manter as rotas do terminal (`/terminal`) funcionando

## Arquivos de contexto úteis

- `CONTEXT.md`
- `README.local-customizations.md`
- `docs/guides/fork-dockerhub-swarm.md`
- `deploy/local/README.md`
- `docs/local/README.md`
