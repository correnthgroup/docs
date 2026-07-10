# ADR-0001 - Shared Context Memory Platform

- Status: Aprovado
- Data: 2026-07-09
- Owner: Correnth / RedScale
- Relacionado: `PRD-CML-001`

## Contexto

RedScale e RedRise v2 possuem implementações parciais e divergentes da Context Memory Layer. Manter schema, ingestão, retrieval e MCP dentro de cada produto criaria drift, duplicação, acoplamento e risco de isolamento inadequado.

## Decisão

A Correnth terá uma única Context Memory Platform compartilhada:

- `correnthgroup/docs` governa PRDs e decisões transversais;
- `correnthgroup/CML` governa a implementação da plataforma;
- o Supabase `rampeobyjmbrgdfvyqms` é dedicado à CML;
- RedScale opera a plataforma por API/SDK e fornece o console administrativo;
- RedRise e futuros produtos usam adapters finos e identidades próprias;
- consumidores não acessam tabelas diretamente e não recebem service role;
- dados são isolados por organização, produto, ambiente, visibilidade e capability;
- a implementação do RedRise v2 é referência de aprendizado, não fonte canônica.

## Consequências positivas

- uma autoridade para schema e contratos;
- segurança e observabilidade consistentes;
- evolução independente dos produtos;
- menor duplicação operacional;
- Context Packs reutilizáveis e auditáveis.

## Consequências negativas

- serviço adicional para operar;
- necessidade de autenticação entre sistemas;
- migração e desativação das implementações existentes;
- indisponibilidade da CML pode afetar múltiplos consumidores.

Esses riscos serão mitigados com least privilege, fallback determinístico, modo degradado explícito, circuit breakers, runbooks e testes cross-tenant.

## Alternativas rejeitadas

### Uma CML por produto

Rejeitada por duplicar infraestrutura, políticas e comportamento de retrieval.

### Manter a CML dentro do RedRise v2

Rejeitada por acoplar uma plataforma transversal ao banco, identidade e ciclo de deploy de um consumidor.

### Manter toda a implementação dentro do RedScale

Rejeitada porque RedScale deve operar e consumir a CML, não ser sua única superfície de execução ou persistência.

## Reversibilidade

Os contratos e dados serão versionados. A implementação poderá mudar de hosting ou storage sem mudar a autoridade documental nem obrigar consumidores a acessar o banco diretamente.
