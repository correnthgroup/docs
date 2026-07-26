# Shared Context Memory Platform

- Status: Aprovado
- Data: 2026-07-14
- Owner: Correnth
- Relacionado: `PRD-CML-001`

## Contexto

Produtos e agentes do ecossistema podem produzir ou consumir documentos, decisões, PRDs, contratos, código, resultados de execução e artefatos de Graphify. Manter schema, ingestão, retrieval e MCP dentro de cada consumidor criaria drift, duplicação, acoplamento e isolamento inadequado.

## Decisão

A Correnth terá uma única Context Memory Platform (CML) compartilhada:

- `correnthgroup/docs` governa PRDs e documentação transversal;
- `correnthgroup/studio_context-memory` governa a implementação da plataforma;
- o Supabase `rampeobyjmbrgdfvyqms` é dedicado à CML;
- a CML expõe API, SDK e MCP versionados, além de console administrativo próprio;
- RedRise, RedRose, Findfee, ADGency, Gauss e futuros consumidores usam adaptadores finos e identidades próprias;
- consumidores não acessam tabelas diretamente e não recebem service role;
- dados são isolados por organização, produto, ambiente, visibilidade e capability;
- Graphify, código, PRDs e documentação específica permanecem no repositório de cada produto e não compõem o corpus global;
- uma implementação de produto serve apenas como referência de aprendizado, nunca como autoridade da CML.

## Política do corpus global

A CML global aceita apenas conhecimento indispensável e reutilizável por qualquer agente autorizado no contexto Correnth:

- posicionamento e direção do Grupo Correnth;
- decisões transversais vigentes;
- fronteiras e contratos entre produtos;
- padrões técnicos, operacionais, jurídicos e de segurança;
- informações generalistas necessárias ao trabalho no ecossistema.

Permanecem fora da CML:

- código, documentação e PRDs específicos de produto;
- memória curta de tarefas e conversas;
- Graphify bruto ou semântico de repositórios;
- segredos, credenciais e dados pessoais;
- informações específicas de clientes.

A exceção para informação de cliente exige autorização formal que defina finalidade, campos, visibilidade, consumidores permitidos, retenção, expiração e revogação. Na ausência dessa autorização, a ingestão é negada.

Cada produto usa identidade própria, revogável e com capability mínima. Tokens ficam server-side. Uma indisponibilidade da CML é retornada explicitamente; consumidores não criam retrieval, embeddings ou banco local como fallback silencioso.

## Hierarquia de autoridade

Em caso de conflito, a ordem obrigatória é:

1. PRD vigente.
2. Direção operacional vigente.
3. Contratos públicos versionados.
4. Migrations aplicadas e reproduzíveis.
5. Código e testes.

Fontes de suporte, como runbooks, logs, roadmaps de referência, protótipos e conversas, não substituem essa hierarquia.

## Consequências

### Positivas

- uma autoridade para schema e contratos;
- segurança, observabilidade e isolamento consistentes;
- evolução independente dos consumidores;
- Context Packs reutilizáveis, auditáveis e enriquecidos por relações semânticas;
- menor duplicação operacional.

### Negativas

- serviço adicional para operar;
- necessidade de autenticação entre sistemas;
- indisponibilidade da CML pode afetar múltiplos consumidores.

Esses riscos serão mitigados com least privilege, fallback determinístico, modo degradado explícito, circuit breakers, runbooks e testes cross-tenant.

## Alternativas rejeitadas

### Uma CML por produto

Rejeitada por duplicar infraestrutura, políticas e comportamento de retrieval.

### Manter a CML dentro de um produto consumidor

Rejeitada por acoplar uma plataforma transversal ao banco, identidade e ciclo de deploy de um único produto.

## Reversibilidade

Contratos e dados serão versionados. Hosting ou storage podem mudar sem alterar a autoridade documental nem obrigar consumidores a acessar o banco diretamente.
