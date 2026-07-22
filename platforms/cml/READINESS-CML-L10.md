# CML-L10 Readiness Report

- Data: 2026-07-10
- PRD: PRD-CML-001
- Decisao: Aprovado
- Próximos consumidores: produtos, negócios e agentes autorizados por API/SDK versionada

## Resultado

A Context Memory Platform está operacional como plataforma compartilhada e independente. RedRise e os demais consumidores autorizados usam API/SDK, sem service role ou acesso direto às tabelas. O Supabase dedicado possui migrations em paridade e aplica isolamento por organization, product, environment, visibility e capability.

O gate RedRise que bloqueava a conclusao foi resolvido pela migration `202607090017_cross_product_results.sql`. Query e pack mantem seu proprio product/environment scope, enquanto cada resultado registra separadamente o scope real do chunk compartilhado. Isso preserva FKs auditaveis sem ampliar autorizacao.

## Evidencias

- Migrations locais/remotas em paridade de `202607090001` a `202607090017`.
- Lint, typecheck e build passaram.
- 126 testes automatizados passaram em 31 arquivos.
- MCP self-test passou.
- Readiness remoto retornou HTTP 200 com `cml_database` live.
- RedRise hybrid retrieval retornou HTTP 200, `mode=hybrid`, `status=complete` e oito resultados citados.
- RedRise publicou Context Pack cross-product via API com HTTP 201 e estado `published`.
- O pack RedRise preservou scope do consumer RedRise e citou chunk `organization_shared` do produto Context Memory.
- O console administrativo da CML foi validado como operador por SDK.
- RLS, capabilities, revogacao, secret quarantine, immutable reindex e adversarial isolation possuem testes permanentes.

## Riscos residuais

- O `supabase db lint --linked` encontrou uma falha transitoria de conexao do CLI; migrations, readiness e operacoes autenticadas remotas passaram depois. Nao indica falha de schema.
- A remocao fisica da implementacao legada no worktree sujo `D:\01_studio\redrise v2` foi evitada para nao destruir alteracoes do usuario. O inventario a declara nao canonica e nenhum consumer depende dela.
- O console administrativo deve manter governança Git própria quando seu repositório oficial for definido. A integração e os gates de runtime estão validados.

## Rollback

- Revogar o consumer afetado e bloquear trafego antes de qualquer reparo de integridade.
- Manter a ultima document version validada e Context Packs publicados imutaveis.
- Reverter client/adapter, nunca criar banco CML paralelo no produto.
- Corrigir schema somente por nova migration; migrations aplicadas nao sao editadas.

## Aprovacao

As evidências satisfazem CML-L01 a CML-L09. Os riscos residuais são operacionais e não bloqueiam consumidores autorizados. CML-L10 está aprovado; todo novo consumidor deve integrar a CML por API/SDK versionada e com capability mínima.
