# PRD-CML-001 Execution Tracker

- Ultima atualizacao: 2026-07-10
- Estado global: Concluido
- Gate atual: CML-L10 aprovado
- PRD-RS-002: Liberado para execucao

## Progresso

| Fase | Estado | Evidencia principal |
|---|---|---|
| A - Governanca e bootstrap | Concluida | ADR, glossario, source-of-truth, CI, templates, configuracao fail-fast e `doctor` |
| B - Contratos | Concluida | Contratos TypeScript v1, IDs nominais, visibilidade, retrieval e Context Packs |
| C - Banco | Concluida | Migrations `202607090001` a `202607090017` em paridade no Supabase dedicado |
| D - Seguranca | Concluida | RLS fail-closed, capabilities, JWT por consumer, threat model, secret scan e testes adversariais |
| E - Ingestao | Concluida | Pipeline Markdown, quarantine, embeddings, summaries, entities, jobs, CLI e reconciliacao |
| F - Retrieval | Concluida | Full-text e vector search, hybrid merge, reranking, filtros, degradacao explicita e benchmark |
| G - Context Packs | Concluida | Selecao deterministica, budget, citacoes e snapshots imutaveis publicados |
| H - API, MCP e SDK | Concluida | OpenAPI v1, runtime autenticado, SDK TypeScript e MCP com capabilities |
| I - Operacao | Concluida | Metricas, readiness, correlation IDs, budgets, alertas e runbooks |
| J - Operacao pelo RedScale | Concluida | Console RS-CONTEXT via SDK com overview, documentos, search, packs, decisions, graph, jobs, logs e consumers |
| K - Consumers e migracao | Concluida | Consumers RedScale/RedRise, fontes canonicas, reindexacao e inventario do legado RedRise v2 |
| L - Readiness | Concluida | `platforms/cml/READINESS-CML-L10.md` |

## Gates L01-L10

| ID | Estado | Evidencia |
|---|---|---|
| CML-L01 | Concluida | Migrations reproduziveis, parity remoto e schema smoke |
| CML-L02 | Concluida | Constraint invariants, authorization e suites cross-tenant/cross-product |
| CML-L03 | Concluida | Testes de pipeline, retry, dead-letter, immutable reindex e reconciliacao |
| CML-L04 | Concluida | Benchmark hibrido e queries remotas citadas |
| CML-L05 | Concluida | Context Packs deterministas, budgetados e publicados |
| CML-L06 | Concluida | 126 testes, build, OpenAPI e MCP self-test verdes |
| CML-L07 | Concluida | Readiness remoto, observabilidade e runbooks validados |
| CML-L08 | Concluida | Console RedScale e consumer administrativo validados |
| CML-L09 | Concluida | RedRise hybrid retrieval e Context Pack cross-product publicados via API |
| CML-L10 | Concluida | Readiness tecnica aprovada; riscos residuais nao bloqueantes documentados |

## Regra de atualizacao

Uma micro-task somente e considerada concluida quando seus criterios de aceite e testes aplicaveis passam e a evidencia esta versionada. O estado por fase acima declara concluidas todas as micro-tasks da respectiva fase na PRD-CML-001.
