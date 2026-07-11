# Paperclip Benchmark for RedScale

- Status: Approved reference
- Data da consulta: 2026-07-10
- Owner: RedScale
- Relacionados: `ADR-0002`, `PRD-RS-002`

## Proposito e disclaimer

Este documento registra somente benchmark funcional para orientar RedScale. RedScale e um produto open-source/self-hosted independente, nao e fork, copia, distribuicao ou dependencia de Paperclip. Nao existe alegacao de afiliacao, endosso ou compatibilidade.

O benchmark descreve conceitos publicamente documentados. Nao autoriza copiar codigo, identidade visual, marcas, textos ou contratos internos. Qualquer eventual reutilizacao futura de codigo exige analise separada de licenca, proveniencia e necessidade.

## Fontes oficiais consultadas

Consultadas em 2026-07-10:

- Documentacao oficial: https://docs.paperclip.ing/
- Conceitos: https://docs.paperclip.ing/guides/welcome/key-concepts/
- Issues: https://docs.paperclip.ing/guides/day-to-day/issues/
- Projects: https://docs.paperclip.ing/guides/projects-workflow/projects/
- Goals: https://docs.paperclip.ing/guides/projects-workflow/goals/
- Instalacao: https://docs.paperclip.ing/guides/getting-started/installation/
- Database: https://docs.paperclip.ing/reference/deploy/database/
- Company administration: https://docs.paperclip.ing/administration/company/

As fontes sao mutaveis. Este benchmark e um retrato da data acima e nao uma especificacao de Paperclip.

## Observacoes verificadas

As fontes oficiais apresentam Paperclip como control plane para equipes de agentes, com instalacao self-hosted, multiplas companies, projetos/issues, atribuicao de agentes, governanca, eventos/auditoria, heartbeats, budgets, plugins e integracoes de runtime. A documentacao de issues destaca checkout atomico e isolamento por company.

A documentacao consultada nao apresenta a CML como componente de Paperclip. Nao se deve inferir equivalencia entre a CML da Correnth e qualquer implementacao ou roadmap de Paperclip.

## Convergencias funcionais adotadas

| Tema | Benchmark observado | Escolha RedScale v1 |
| --- | --- | --- |
| Control plane | Estado operacional central para trabalho e agentes | Work Orders como unidade operacional canonica |
| Isolamento | Entidades scoped por company | `organization_id` em todas as entidades tenant-owned e RLS deny-by-default |
| Hierarquia de trabalho | Company, project e task/issue | Organization, Product/Project e Work Order |
| Atribuicao | Trabalho atribuido a agentes | `assigned_agent_id` nullable e opaco ate existir agent registry |
| Concorrencia | Checkout atomico evita trabalho duplicado | optimistic locking e transicao transacional `assigned -> running` |
| Governanca | Review/approval e audit trail | estados `review`, `accepted`, `rejected` e eventos append-only |
| Contexto | Contexto relacionado ao trabalho e objetivos | context refs versionadas, resolvidas exclusivamente pela CML |
| Entregas | Work products/artifacts associados ao trabalho | deliverables com URI, checksum, media type e status de verificacao |
| Self-hosting | Runtime instalavel pelo operador | Supabase RedScale dedicado, configuracao externa e seed Correnth opcional |

Convergencia funcional nao significa convergencia de schema, API, codigo, UX ou marca.

## Diferencas deliberadas

- RedScale v1 nao modela uma empresa autonoma completa; modela work orders verificaveis.
- Product e Project sao entidades operacionais simples, nao goals ou org chart.
- CML e um servico independente e a unica memoria; RedScale nao implementa knowledge base interna.
- Correnth e configuracao inicial, nao comportamento compilado no produto.
- O banco operacional e Supabase dedicado e nao compartilha persistencia com CML ou RedRise.
- IDs CML sao referencias externas sem FK cross-database.
- O modelo de principal usa `principal_type` e `principal_id` opacos; agent registry fica para uma PRD futura.

## Escopo adiado

Os seguintes temas observados nas fontes nao pertencem a `PRD-RS-002`:

- heartbeats, watchdogs, wakeup queues e recuperacao de runs orfaos;
- plugins, skill injection e extensoes de UI;
- budgets avancados, custos por token, quotas e hard stops financeiros;
- org chart, reporting lines, hiring e lifecycle completo de agentes;
- schedules, routines, recurring jobs e work queues;
- secrets injection, sandboxes, worktrees e runtime hosting;
- portability/import-export de companies;
- comentarios, mentions, inbox, chat e colaboracao rica;
- memoria interna ou alternativa a CML;
- automacao autonoma de planejamento, delegacao ou auto-organizacao.

Adiar nao implica compromisso de implementacao. Cada item exige problema comprovado, contrato e PRD/ADR proprios.

## Criterio de uso futuro

Uma capacidade Paperclip-type so entra no RedScale quando:

1. resolver necessidade de mais de uma configuracao ou uma necessidade estrutural do produto generico;
2. preservar independencia de codigo, marca, banco e contratos;
3. respeitar os boundaries de `ADR-0002`;
4. possuir criterios de aceite, threat model proporcional e testes;
5. nao criar uma segunda camada de memoria.
