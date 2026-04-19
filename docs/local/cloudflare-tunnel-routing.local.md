# Cloudflare Tunnel Routing

Este deploy do EvoNexus foi preparado para a topologia:

`Cloudflare Tunnel -> Traefik -> EvoNexus`

## Hostname público recomendado

Use um único hostname público para o EvoNexus:

- `nexus.seudominio.com`

Esse mesmo hostname atende:

- `/` -> dashboard
- `/terminal` -> terminal embutido

## Rotas esperadas

No Traefik, o stack já foi preparado para:

- `Host(\`nexus.seudominio.com\`)` -> serviço web na porta `8080`
- `Host(\`nexus.seudominio.com\`) && PathPrefix(\`/terminal\`)` -> terminal server na porta `32352`

No Cloudflare Tunnel, portanto, não é necessário criar um hostname separado para `/terminal`.

## O que cadastrar no painel da Cloudflare

Crie um public hostname:

- Hostname: `nexus.seudominio.com`
- Service type: `HTTP`
- URL de destino: o endpoint do Traefik na VPS

## Destinos mais comuns

Se `cloudflared` roda na mesma VPS e o Traefik publica a porta 80 no host:

- `http://localhost:80`

Se quiser passar por HTTPS interno e o Traefik publica 443:

- `https://localhost:443`

Se `cloudflared` roda como container e alcança o serviço Traefik pela rede Docker:

- `http://traefik:80`

## Paths

Você não precisa configurar paths separados no painel da Cloudflare.

O roteamento por path já é feito pelo Traefik:

- `/` -> dashboard
- `/terminal` -> terminal server

## Portas internas do EvoNexus

- `8080` -> dashboard Flask/SPA
- `32352` -> terminal server

Essas portas não precisam ser expostas diretamente na Cloudflare.
O Cloudflare Tunnel deve apontar para o Traefik, e o Traefik encaminha para os serviços corretos.

## O que ajustar no stack

No arquivo:

- `deploy/local/evonexus.portainer.stack.2026.04.18.local.yml`

substitua:

- `nexus.example.com`

pelo seu hostname real, por exemplo:

- `nexus.seudominio.com`

Confirme também:

- `network_swarm_public` = nome real da rede externa do Traefik
- `letsencryptresolver` = nome real do certresolver no seu Traefik

## Resumo

Cadastre no Cloudflare apenas:

- `nexus.seudominio.com` -> Traefik

E deixe o Traefik resolver internamente:

- `https://nexus.seudominio.com` -> `:8080`
- `https://nexus.seudominio.com/terminal` -> `:32352`
