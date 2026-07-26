# Rollout e auditoria das PRs RedRise

- Status: execução em andamento; integração da plataforma e staging pendentes
- Revisão: 2026-07-26
- Autoridade: decisões em `decisions/`, código, migrations, testes, CI e evidências versionadas

## Fonte e escopo

O pacote `D:\02_labs\PRs\redrise-mvp` é evidência local histórica. Ele não é fonte
canônica de requisitos, estado de merge ou implementação. A matriz canônica é
formada pelas PRs reais, commits, testes, CI, deploy de staging e este documento.

Documentação e código versionados são a autoridade; Graphify é somente índice de
descoberta. Antes de editar ou integrar, consultar o grafo local da raiz
aplicável, navegar as relações semânticas e AST e ler as fontes citadas.

## Estado remoto confirmado

| Repositório | Estado em 2026-07-26 |
|---|---|
| `correnthgroup/docs` | PRs #2–#5 mescladas em `main` |
| `correnthgroup/redrise-operation` | PRs #1–#12 mescladas em `main` |
| `correnthgroup/redrise-platform` | PRs #10–#20 abertas; #10 pronta, #11–#20 drafts; nenhuma mesclada em `master` |

As PRs da plataforma continuam empilhadas. A existência da branch ou de uma PR
não prova que a entrega está funcional. O status **concluído** só pode ser usado
depois de código, migrations aplicáveis, testes, CI, staging, rollback e
evidência passarem.

## Decisão sobre Commitperclip

O GitHub App Commitperclip, App ID `3718661`, pertence ao upstream
`paperclipai`. Uma conta administradora da Correnth pode instalar o App, mas não
pode gerar ou revogar suas chaves privadas. A documentação de JWT do GitHub
pressupõe uma chave PEM já emitida pelo proprietário do App; ela não oferece um
meio de criar a chave de um App de terceiros.

O fork não dependerá de uma credencial privada do upstream. A branch da PR #10
contém uma correção para usar o `github.token` efêmero do próprio workflow e
criar o check de segurança com permissões mínimas. Depois que essa correção
estiver em `master`, remover o secret inválido `COMMITPERCLIP_KEY` em:

1. GitHub → `correnthgroup/redrise-platform`.
2. **Settings** → **Secrets and variables** → **Actions**.
3. **Repository secrets** → `COMMITPERCLIP_KEY`.
4. **Remove secret** e confirmar.

Nenhuma PEM, JWT ou segredo novo é necessário para esse workflow. Caso a
Correnth crie futuramente um App próprio, a chave privada será gerada apenas na
página desse App, guardada no Cofre e nunca copiada para Git, logs ou Graphify.

## Matriz das 16 entregas lógicas

Legenda: **OK** = evidência obrigatória concluída; **local** = implementação
commitada somente na branch local, ainda sem CI remoto/staging; **N/A** = não se
aplica; **pendente** = gate obrigatório ainda não executado; **bloqueado** =
depende de configuração, conteúdo ou aprovação externa.

| Lógica | PR real | Contrato | Código | Migration | Testes locais | CI | Staging | Rollback/evidência | Status |
|---:|---|---|---|---|---|---|---|---|---|
| 01 | docs #3 | OK | N/A | N/A | N/A | OK | N/A | PR/merge | concluído |
| 02 | operation #11 | OK | OK | N/A | OK | OK | N/A | PR/merge | concluído |
| 03 | docs #4–#5 | OK | OK | N/A | Graphify validado | OK | N/A | PR/merge | concluído |
| 04 | platform #10 | OK | local `022cab8c2` | N/A | focalizados | pendente | pendente | PR + plano | parcial |
| 05 | platform #11 | OK | local `9a799168b` | N/A | matriz donor | pendente | depende de #12 | PR + matriz | parcial |
| 06 | platform #12 | OK | local `439890041` | local | focalizados | pendente | bloqueado por infraestrutura | plano de pre-deploy | parcial |
| 07 | platform #13 | OK | local `e7453c422` | N/A | focalizados | pendente | pendente | testes de ciclo | parcial |
| 08 | platform #14 | OK | local `c12ae7b37` | quando aplicável | 82/82 focalizados | pendente | duas empresas pendente | matriz de autorização | parcial |
| 09 | platform #15 | OK | local `ef3d6cfcd` | local | vazio/upgrade/repetição | pendente | backup/HITL pendente | plano de reversão | parcial |
| 10 | platform #16 | OK | local `3d78b00f9` | quando aplicável | 10 focalizados | pendente | S3/restart pendente | cleanup/idempotência | parcial |
| 11 | platform #17 | OK | local `d125d3736` | N/A | 22 focalizados | pendente | Docker/Render pendente | pins/readiness | parcial |
| 12 | platform #18 | OK | local `7657a6262` | local `0195` | billing focalizados | pendente | Stripe test pendente | idempotência/ordenação | parcial |
| 13 | platform #19 | OK | local `c6a55cffb` | N/A | 4 focalizados | pendente | bloqueado por conteúdo legal | documento de handoff | bloqueado |
| 14 | operation #12 | OK | OK | N/A | OK | OK | reconciliação aplicada requer HITL | PR/merge + backup exigido | parcial operacional |
| 15 | docs #4–#5 | OK | retirada ativa OK | N/A | scans locais | OK | N/A | histórico preservado | concluído |
| 16 | platform #20 + docs #4–#5 | OK | branch remota inconsistente | N/A | integridade local falha | pendente | pendente | bundle antes da reescrita | bloqueado |

Os hashes acima registram o estado local auditado. Eles ainda não são evidência
remota enquanto não forem publicados pelo wrapper Graphify e aprovados no CI.

## Gate zero restante

1. Publicar a CI nativa do fork na PR #10 e verificar que `review`, quality,
   security, build e testes executam sem Commitperclip.
2. Remover do PATH de máquina o resíduo do provider legado de memória em
   sessão Windows elevada, reiniciar Codex e terminais e executar as três
   validações do runbook histórico
   [`archived/MEMORY_PROVIDER_REMOVAL.md`](../archived/MEMORY_PROVIDER_REMOVAL.md).
   Os três resultados esperados são `True`.
3. Antes de qualquer push, inclusive GitHub MCP/CLI, executar:

   ```powershell
   D:\00_docs\tools\Invoke-CorrenthSemanticPush.ps1 -ProjectRoot <raiz permitida>
   ```

4. Confirmar quota Git LFS sem compra em GitHub → avatar → **Settings** →
   **Billing and licensing** → **Metered usage** → filtro **Git LFS**. Se o
   primeiro push exigir compra ou ampliar custo, interromper e obter HITL.

## Integração por lotes

| Lote | PRs | Critério de avanço |
|---|---:|---|
| 1 | #10–#12 | CI nativa verde; matriz donor completa; readiness, pre-deploy e Blueprint validados em staging. |
| 2 | #13–#15 | Signup sem sessão automática; sessão/CSRF; negação cross-tenant; UUID/aliases repetíveis. |
| 3 | #16–#18 | Bridge segura; adapters nativos/BYOK em Linux; Stripe com corpo bruto, assinatura e eventos completos. |
| 4 | #19–#20 | Conteúdo legal aprovado; superfícies públicas testadas; grafo reconstruído e coerente via LFS. |

Para cada PR:

1. Sincronizar a branch com a predecessora já mesclada.
2. Implementar e testar na branch existente.
3. Executar o wrapper Graphify com worktree limpo.
4. Publicar pela via protegida.
5. Retargetar para `master`, marcar como pronta e executar todo o CI.
6. Anexar comandos, resultados, staging, rollback e limitações.
7. Mesclar por merge commit.
8. Retargetar a seguinte e só então excluir a branch predecessora.

Rebase e `--force-with-lease` ficam restritos à reconstrução controlada da PR
#20. Imediatamente antes dela, criar um bundle recuperável da branch original.

## Configuração obrigatória de staging

Staging exige aprovação de custo antes da criação. Render, Supabase, S3 e Stripe
ficam no Cofre; nenhum valor é copiado para Git, Graphify ou documentação.

### Supabase e Render

1. Criar um projeto Supabase dedicado de staging na região mais próxima do
   Render aprovado.
2. Em **Connect**, guardar no Cofre a URL do **Session pooler**, porta `5432`,
   como `DATABASE_URL`.
3. Guardar como `DATABASE_MIGRATION_URL` a conexão direta quando compatível ou
   o Session pooler; não usar o Transaction pooler `6543` para migrations.
4. Em **Storage**, criar somente o bucket privado `redrise-staging`.
5. Em **Storage** → **S3**, gerar endpoint, região, access ID e secret e guardar
   todos no Cofre.
6. No Render, criar Blueprint da branch da PR #12 com serviço
   `redrise-platform-staging`, plano Starter e auto-deploy desligado.
7. Preencher os campos `sync:false`: `DATABASE_URL`,
   `DATABASE_MIGRATION_URL`, `BETTER_AUTH_URL`,
   `BETTER_AUTH_TRUSTED_ORIGINS`, `PAPERCLIP_PUBLIC_URL`,
   `PAPERCLIP_STORAGE_S3_BUCKET`, `PAPERCLIP_STORAGE_S3_REGION`,
   `PAPERCLIP_STORAGE_S3_ENDPOINT`, `AWS_ACCESS_KEY_ID` e
   `AWS_SECRET_ACCESS_KEY`.
8. Usar exatamente a URL HTTPS do serviço nas três URLs públicas/de auth.
9. Validar pre-deploy, liveness, readiness, banco vazio, upgrade, restart e
   persistência antes do merge da PR #12.

### Stripe de staging

1. Ativar **Test mode**.
2. Criar o produto Pro e um preço recorrente aprovado pelo responsável
   comercial; guardar `price_...` no Cofre.
3. Criar restricted key somente com customers, checkout, subscriptions e
   billing portal necessários ao runtime.
4. Criar endpoint
   `https://<staging>/api/billing/stripe/webhook` somente com os eventos
   implementados e guardar o signing secret no Cofre.
5. Configurar no Render `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` e
   `STRIPE_PRO_PRICE_ID`.
6. Redeployar e validar duplicidade, atraso, expiração, upgrade, suspensão,
   cancelamento e reativação. Nenhuma chave live será usada.

### Conteúdo legal

A PR #19 não será mesclada com placeholders. O proprietário deve aprovar Privacy
Policy, Terms, AUP, Subprocessors, Security/Support e Data Deletion. Cada arquivo
precisa de título, versão, data efetiva, contato e aprovador. O handoff detalhado
está em `redrise-platform/doc/product/PUBLIC_LEGAL_PILOT.md`. Os documentos
aprovados devem ser colocados no Cofre em `RedRise\Legal Approved` e o agente
deve ser avisado apenas de que estão prontos, sem colar seu conteúdo sensível no
chat.

## Conferência integral

### Código e CI

Executar com a versão fixada pelo Corepack:

```powershell
corepack pnpm -r typecheck
corepack pnpm test:run
corepack pnpm build
```

Também executar suites focalizadas, migrations, Docker build/smoke e e2e
autenticado. Após cada retarget, dependency review, quality, security, build e
testes precisam passar novamente. Os cinco casos Windows inicialmente
identificados nos adapters foram corrigidos, mas a suite integral do pacote
ainda expõe casos POSIX incompatíveis no host Windows; a decisão final depende
do CI/container Linux, não de esconder essas falhas.

### Staging funcional

Registrar evidência reproduzível de liveness/readiness, banco vazio/upgrade,
signup sem login automático, sessão, duas empresas, XLSX de ponta a ponta,
Codex/Claude/Gemini no container, Stripe test mode, restart e backup/restore.

### Segurança, Cofre e retirada do provider legado

- Escanear arquivos rastreados e histórico Git por segredos.
- Confirmar que conteúdo do Cofre não aparece em Git, Graphify, logs ou Actions.
- Permitir somente referências documentais ao caminho do Cofre.
- Exigir zero referências ativas ao provider legado fora de `archived` e
  `_legacy`.
- Confirmar ausência de provider, comando, diretório, arquivo no Cofre e PATH.
- Validar Stripe sobre corpo bruto e autorização por empresa.

### Graphify e fechamento Git

Em cada raiz, `graph.json`, manifesto, relatório, labels, análise e proveniência
devem corresponder ao mesmo HEAD, revisão e contagens. Exigir relações AST e
semânticas, zero links órfãos/self-loops e zero fontes em `graphify-out`, caches,
dependências, `archived` ou `_legacy`. O grafo global agrega apenas grafos locais
aprovados e consultas precisam retornar fontes versionadas verificáveis.

A PR #20 atual não passa: ela contém commits e blobs duplicados de Graphify, e
relatório/proveniência divergem do grafo. Depois da PR #19, reconstruir #20 sobre
`master`, preservar a branch antiga em bundle local, versionar somente o
conjunto canônico via LFS e publicar com `--force-with-lease`.

## Critério de encerramento

- `master` da plataforma e `main` dos outros repositórios contêm os commits
  aprovados.
- Worktrees estão limpos e sincronizados com os branches padrão.
- Não restam PRs draft/abertas do rollout nem branches empilhadas obsoletas.
- O status canônico registra limitações e evidências reais.
- Staging passa; produção não é declarada concluída nem alterada sem HITL.
