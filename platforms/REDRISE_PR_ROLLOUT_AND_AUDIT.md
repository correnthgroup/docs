# Rollout e auditoria das PRs RedRise

- Status: vigente como plano de integração; execução pendente dos gates listados
- Revisão: 2026-07-26
- Autoridade: decisões em `decisions/`, código e testes versionados nos repositórios RedRise

## Fonte e escopo

O pacote `D:\02_labs\PRs\redrise-mvp` é evidência local histórica. Ele não é fonte canônica de requisitos, estado de merge ou implementação. A matriz canônica é formada pelas PRs reais, seus commits, testes, CI, deploy de staging e este plano.

Documentação e código versionados são a autoridade; Graphify é somente índice de descoberta. Antes de editar ou integrar, consultar o grafo local da raiz aplicável, navegar relações AST e ler as fontes citadas.

## Estado auditado

| Repositório | Entregas já mescladas | Estado pendente |
|---|---|---|
| `correnthgroup/docs` | PRs #2–#4 | PR corretiva #5 do Graphify transacional, ainda draft |
| `correnthgroup/redrise-operation` | PRs #1–#12 | sincronizar worktree com `main` no fechamento |
| `correnthgroup/redrise-platform` | nenhuma entrega do rollout #10–#20 | PRs #10–#20 abertas e empilhadas sobre `master` |

Em `redrise-platform`, #10 tem build, testes e e2e verdes; o check `review` continua bloqueado por uma PEM inválida em `COMMITPERCLIP_KEY`. As PRs #11–#19 não são prova de implementação completa apenas por existirem: várias possuem somente contrato ou documentação e exigem código, migrations e testes na própria branch antes de ficarem prontas.

## Gates zero

1. Renovar a chave privada PEM do GitHub App Commitperclip (App ID `3718661`) e atualizar exclusivamente o secret de Actions `COMMITPERCLIP_KEY`; reexecutar o job `review` e revogar a chave substituída após sucesso.
2. Remover a entrada obsoleta `C:\Program Files\Correnth\CML MCP` apenas do PATH de máquina em sessão Windows elevada. Não reinstalar CML, provider, launcher ou arquivo de Cofre.
3. A PR #5 deve validar a promoção transacional do Graphify. Só os artefatos canônicos `graph.json`, relatório, manifesto, proveniência, análise e labels podem ser versionados; cache, snapshots, quarentena e HTML são derivados locais.
4. Antes de qualquer push, inclusive operação GitHub MCP/CLI, executar `D:\00_docs\tools\Invoke-CorrenthSemanticPush.ps1 -ProjectRoot <raiz permitida>`. O wrapper usa `uv` e `graphifyy`; não usar nem contornar `graphify.exe` bloqueado.

## Lotes de integração

| Lote | PRs | Critério de avanço |
|---|---:|---|
| 1 | #10–#12 | #10 verde; #11 tem matriz donor→aceito/rejeitado→teste; #12 entrega readiness, pre-deploy de migration e Blueprint validado em staging. |
| 2 | #13–#15 | Signup sem sessão automática; testes de sessão/CSRF; negação cross-tenant em todos os recursos; migração de UUID/aliases repetível. |
| 3 | #16–#18 | Bridge de anexos segura e idempotente; adapters nativos/BYOK com testes Windows e Docker Linux; Stripe somente após webhook de corpo bruto e assinatura validada. |
| 4 | #19–#20 | Conteúdo legal aprovado pelo proprietário; superfícies públicas testadas; fechamento do grafo via LFS somente com quota existente e sem compra não aprovada. |

Cada PR é atualizada apenas sobre sua predecessora já mesclada, ganha implementação e evidência, passa CI e staging, é retargetada para `master` e então mesclada por merge commit. O retarget da seguinte só ocorre depois. Reescrita/`--force-with-lease` é restrita à limpeza controlada de #20, com bundle recuperável prévio.

## Staging e credenciais

Render Starter, projeto Supabase, credenciais S3 e Stripe de teste exigem HITL e valores no Cofre. Nenhum segredo vai para Git, Graphify, GitHub Secrets (exceto a PEM exclusiva do App de CI), `.env`, logs ou argumentos exibidos.

Staging é obrigatório antes de declarar os lotes funcionais: liveness/readiness, banco vazio e upgrade, autenticação, duas empresas com negação cross-tenant, anexos XLSX e restart. Stripe continua bloqueado até handler verificável e configuração runtime; produção, custo, domínio, chaves live e reconciliação aplicada requerem HITL separado.

## Fechamento

"Implementado" exige contrato, código, migration (quando aplicável), testes, CI verde, staging, rollback e evidência reproduzível. O encerramento exige `master`/`main` sincronizados, nenhuma PR draft/empilhada remanescente, scans sem CML ativa fora de `archived`/`_legacy`, e grafos locais/global com proveniência MiniMax, relações AST e semânticas, sem self-loops ou fontes excluídas.
