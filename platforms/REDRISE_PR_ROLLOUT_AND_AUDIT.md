# Conclusão das PRs RedRise e reconstrução limpa do staging

- Status: execução em andamento
- Revisão: 2026-07-26
- Autoridade: decisões, código, migrations, testes, CI e evidências versionadas
- Registro operacional local: `D:\02_labs\PRs\redrise-mvp`

## Autoridade e registro

Documentação e código versionados permanecem autoridade. Graphify é o índice
semântico + AST de descoberta e deve levar à fonte versionada citada.

`D:\02_labs\PRs\redrise-mvp` é a fonte canônica local para operar e auditar as
16 entregas lógicas. O diretório não possui Git, não entra no Graphify e é
protegido por `MANIFEST.sha256` e snapshots datados. Seu `PR_REGISTRY.md`
registra todas as PRs reais dos três repositórios, inclusive corretivas e
manutenção fora do rollout. A numeração nativa do GitHub não cria entregas
lógicas 17–20.

## Estado confirmado

| Repositório | Estado |
|---|---|
| `correnthgroup/docs` | PRs #2–#6 mescladas; #1 fechada |
| `correnthgroup/redrise-operation` | PRs #1–#13 mescladas |
| `correnthgroup/redrise-platform` | #10–#11 mescladas; #12–#20 abertas/empilhadas; #1–#9 manutenção Dependabot |

O Render atual é um Static Site legado e continua servindo os domínios
`redrise.app` e `www.redrise.app`. O Supabase atual contém o backend legado e
não pode ser limpo enquanto esse site estiver ativo. Staging será reconstruído
em recursos novos e dedicados.

## Gate zero

1. Remover a entrada `C:\Program Files\Correnth\CML MCP` do PATH de máquina.
2. Confirmar comando, diretório, Cofre e Paths CML ausentes.
3. Corrigir instruções ativas para Graphify semântico → AST → fonte.
4. Não criar PEM, JWT ou `COMMITPERCLIP_KEY`: o workflow usa `github.token`.
5. Na PR #12, substituir mutação direta de `process.env` no teste de migration
   URL por `vi.stubEnv`/`vi.unstubAllEnvs`.
6. Exigir `review` e `security-review` em `success`, além de dependency review,
   quality, build, testes e e2e verdes.

## Contenção do legado

### Render

- Desligar Auto-Deploy do Static Site.
- Regenerar o deploy hook potencialmente exposto durante a auditoria.
- Renomear o serviço para `redrise-legacy-static`.
- Manter os domínios até cutover de produção separado.

### Supabase

- Renomear o projeto atual para `redrise-legacy`.
- Desconectar a integração GitHub incorreta.
- Preservar tabelas, usuários, chaves e dados até o cutover.
- Registrar os 55 objetos públicos, três usuários Auth e o alerta da view
  `v_documents_pending`.
- Criar backup lógico verificado antes de alterações futuras.

## Staging limpo

Criar `redrise-platform-staging` na organização Correnth, região Ohio, sem
restore, importação ou integração GitHub.

- Desabilitar Data API.
- Revogar privilégios padrão de `anon` e `authenticated` em novos objetos de
  `public`.
- Criar somente o bucket privado `redrise-staging`.
- Usar credenciais S3 server-side e endpoint direto do projeto.
- Usar Session pooler IPv4, porta 5432, para `DATABASE_URL` e
  `DATABASE_MIGRATION_URL`.
- Não usar conexão direta IPv6 nem transaction pooler 6543.
- Aplicar as 190 migrations do zero e confirmar 158 tabelas públicas atuais,
  sem objetos RedRise legados.
- Manter schemas gerenciados Supabase; instalar somente `pg_trgm` e
  `fuzzystrmatch` se exigidos pelas migrations.

O Cofre guarda URLs, senhas, S3 e IDs de serviço. Nenhum valor entra em Git,
Graphify, Actions ou logs.

Criar pelo Blueprint da PR #12 um Render Web Service Docker Starter
`redrise-platform-staging`, região Ohio, Auto Sync/Auto Deploy desligado,
pre-deploy de migrations e health check em `/api/readiness`. As URLs de Better
Auth e pública devem usar exatamente a URL HTTPS `onrender.com` do serviço.

## Integração por lotes

Para cada PR: sincronizar com a predecessora mesclada, implementar/testar,
executar o wrapper Graphify com worktree limpo, publicar pelo guard, retargetar
para `master`, executar CI completo, anexar evidência/rollback e mesclar com
merge commit.

| Lote | PRs | Gate |
|---|---:|---|
| 1 | #12 | Supabase/Render novos; migrations, readiness, S3, restart e persistência; CI integral verde |
| 2 | #13–#15 | Better Auth sem login automático; duas empresas; negação cross-tenant; UUIDs/aliases repetíveis |
| 3 | #16–#18 | bridge segura; adapters/BYOK Linux; Stripe Test mode, assinatura raw e eventos completos |
| 4 | #19–#20 | conteúdo legal aprovado; superfícies públicas; reconstrução Graphify/LFS e auditoria final |

Interfaces obrigatórias do lote 3:

- `prepareIssueWorkspaceInputs(...)`
- `publishWorkspaceOutputs(...)`
- `POST /api/billing/stripe/webhook`
- `GET /api/companies/:companyId/billing`
- `POST /api/companies/:companyId/billing/checkout`
- `POST /api/companies/:companyId/billing/portal`

PR #19 permanece bloqueada até Privacy Policy, Terms, AUP, Subprocessors,
Security/Support e Data Deletion aprovados, versionados e datados. PR #20 será
reconstruída sobre `master` após #19, com bundle recuperável e
`--force-with-lease`; apenas o grafo canônico via Git LFS e relatórios coerentes
serão preservados.

## Auditoria

Executar:

```powershell
corepack pnpm -r typecheck
corepack pnpm test:run
corepack pnpm build
```

Também exigir Docker build/smoke, e2e autenticado, banco vazio e restart, Better
Auth, duas empresas, fluxo XLSX, adapters no container, Stripe Test mode,
backup/restore, scan de segredos e integridade Graphify nas três raízes.

## Arquivos antigos

Depois do aceite de staging:

1. criar bundles finais de `archived\redrise` e `archived\redrise v2`;
2. capturar patches e arquivos não rastreados, excluindo `.env.local`;
3. mover credenciais necessárias ao Cofre e registrar somente hashes;
4. clonar cada bundle em diretório temporário e verificar o HEAD;
5. confirmar zero referência runtime aos diretórios;
6. mover os diretórios para a Lixeira do Windows.

O Supabase e Render legados não serão resetados/excluídos nessa etapa. Domínios,
chaves legadas e desligamento definitivo pertencem a um cutover de produção com
HITL separado.

## Critério de encerramento

- PRs #12–#20 mescladas em ordem e nenhum draft do rollout restante.
- Registro local completo e manifesto/snapshots atualizados.
- Web Service e Supabase novos funcionais e sem dados/tabelas legados.
- Cofre ausente de Git, Graphify, Actions e logs.
- CML ausente de configuração, comando, diretório e Paths.
- Arquivos antigos removidos somente após restauração verificada dos bundles.
- Produção não declarada concluída antes do cutover autorizado.
