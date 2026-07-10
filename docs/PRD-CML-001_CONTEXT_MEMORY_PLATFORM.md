# PRD-CML-001 - Correnth Context Memory Platform

- Status: Planejado
- Versão: 1.0
- Owner: Correnth / RedScale
- Repositório canônico: `https://github.com/correnthgroup/CML.git`
- Supabase dedicado: `https://rampeobyjmbrgdfvyqms.supabase.co`
- Supabase project ref: `rampeobyjmbrgdfvyqms`
- Consumidores iniciais: RedScale, RedRise e agentes internos da Correnth
- Bloqueia: PRD-RS-002 - Work Order Data Model

---

## 1. Resumo executivo

A Correnth Context Memory Platform, também chamada de CML (Context Memory Layer), será a infraestrutura compartilhada de contexto e memória do ecossistema Correnth.

Sua função é transformar documentos, decisões, PRDs, arquitetura, histórico de execução e outras fontes autorizadas em contexto pesquisável, citado, compacto e auditável para produtos, agentes e Work Orders.

```text
Fontes autorizadas
→ ingestão e versionamento
→ chunks, embeddings, summaries e entidades
→ busca híbrida e reranking
→ Context Pack citado
→ RedScale, produtos e agentes
```

A CML não será implementada separadamente em cada produto. Existirá uma única implementação canônica, independente do RedRise e administrada pelo RedScale. Cada produto possuirá apenas identidade, permissões, fontes e adaptadores de consumo.

O Work Order Data Model só poderá ser iniciado depois que os gates definidos neste documento forem atendidos.

---

## 2. Contexto e problema

O conhecimento do ecossistema está distribuído entre documentos Markdown, decisões de conversa, PRDs, mapas de arquitetura, logs de implementação, código e ferramentas distintas.

As implementações atuais demonstraram a viabilidade da proposta, mas também criaram riscos:

- uma foundation incompleta dentro do RedScale;
- uma implementação mais avançada, porém acoplada ao RedRise v2;
- migrations e contratos divergentes;
- identidade de organização, workspace e produto inconsistente;
- uso de service role por ferramentas de agente;
- falta de testes reais de isolamento e recuperação;
- duplicação de ingestão, busca, MCP e UI;
- ausência de uma autoridade única para schema e operação.

Continuar essas implementações em paralelo aumentaria context drift, custo operacional e risco de vazamento entre produtos ou organizações.

---

## 3. Decisões de arquitetura

### 3.1 Decisões aprovadas

1. O repositório `CML` será a única autoridade de schema, migrations, ingestão, retrieval, Context Packs, API e MCP.
2. A CML usará o Supabase dedicado `rampeobyjmbrgdfvyqms`.
3. A CML não dependerá do banco, App Shell ou modelo de workspace do RedRise.
4. RedScale será o control plane e fornecerá a UI administrativa.
5. RedRise e futuros produtos serão consumidores por contratos versionados.
6. `product_key` hardcoded será substituído por um registry de produtos.
7. Nenhum cliente ou agente receberá service role.
8. Toda resposta de retrieval ou Context Pack deverá ser rastreável até as fontes.
9. Mudanças destrutivas, cross-tenant ou de segurança falharão de forma fechada.
10. A implementação existente no RedRise v2 será tratada como protótipo de referência, não como fonte canônica.

### 3.2 Forma inicial de implantação

```text
Supabase CML dedicado
├── Postgres
├── pgvector
├── RLS
├── storage opcional para fontes permitidas
└── Edge Functions somente quando justificadas

Serviço CML
├── Core e contratos
├── Ingestão
├── Retrieval
├── Context Pack Builder
├── API
└── MCP Gateway

RedScale
└── Console administrativo da CML
```

### 3.3 Estrutura inicial do repositório

```text
context-memory/
├── docs/
├── src/
│   ├── domain/
│   ├── authorization/
│   ├── ingestion/
│   ├── retrieval/
│   ├── context-packs/
│   ├── api/
│   └── mcp/
├── scripts/
├── supabase/
│   └── migrations/
└── tests/
```

A estrutura poderá evoluir quando houver necessidade concreta. O projeto não deve começar como um monorepo interno de múltiplos packages.

---

## 4. Objetivos

### 4.1 Objetivos funcionais

- registrar organizações, produtos, ambientes e consumidores;
- indexar fontes Markdown autorizadas;
- versionar documentos sem misturar versões obsoletas;
- realizar busca híbrida vetorial e textual;
- aplicar filtros de autorização antes de retornar conteúdo;
- gerar Context Packs compactos e citados;
- oferecer API e MCP com contratos versionados;
- registrar consultas, resultados, custos, falhas e qualidade;
- permitir operação e inspeção pelo RedScale;
- fornecer contexto confiável para futuros Work Orders.

### 4.2 Objetivos de qualidade

- instalação reproduzível em banco vazio;
- isolamento comprovado por testes de organização e produto;
- zero secrets indexados intencionalmente;
- recuperação segura de falhas parciais;
- idempotência em ingestão e reprocessamento;
- degradação explícita, nunca silenciosa;
- observabilidade suficiente para detectar context drift;
- contratos desacoplados dos produtos consumidores.

### 4.3 Fora de escopo da v1

- edição autônoma de repositórios;
- execução completa de Work Orders;
- memória de usuário final como feature comercial;
- ingestão indiscriminada de binários;
- migração para Qdrant ou Weaviate sem evidência de necessidade;
- grafo de conhecimento sofisticado como requisito de lançamento;
- múltiplos provedores ativos simultaneamente sem necessidade operacional;
- replicação da CML dentro de produtos consumidores.

---

## 5. Conceitos e modelo de acesso

### 5.1 Entidades de identidade

```text
Organization
└── Product
    └── Environment
        └── Consumer
```

- `organization`: limite principal de isolamento de dados;
- `product`: unidade do ecossistema, como RedScale ou RedRise;
- `environment`: development, preview, staging ou production;
- `consumer`: aplicação, agente, operador ou integração que consulta a CML.

### 5.2 Classificação de visibilidade

```text
ecosystem_shared
organization_shared
product_private
work_order_private
agent_private
```

O acesso efetivo será a interseção entre organização, produto, ambiente, visibilidade, classificação do documento e capabilities do consumidor.

### 5.3 Regra de negação

Na ausência de uma autorização explícita, o acesso será negado. Erros de resolução de tenant, produto ou identidade nunca deverão resultar em busca global.

---

## 6. Modelo de dados mínimo

O modelo definitivo será validado em ADR e migrations, mas deve contemplar:

```text
organizations
products
environments
context_consumers
consumer_permissions

sources
documents
document_versions
document_chunks
document_summaries

entities
relations
decisions

ingestion_jobs
context_queries
context_query_results
context_packs
retrieval_logs
```

Regras mínimas:

- toda entidade de conteúdo possui `organization_id`;
- conteúdo privado possui `product_id` e `environment_id` quando aplicável;
- FKs ou validações equivalentes impedem relações cross-tenant acidentais;
- documento e versão são entidades diferentes;
- apenas uma versão pode ser corrente por fonte e escopo;
- chunks nunca existem sem versão válida;
- conteúdo arquivado ou obsoleto não participa do retrieval padrão;
- queries e packs registram o consumidor e a política aplicada;
- Context Packs são snapshots imutáveis.

---

## 7. Estratégia de resiliência

Neste PRD, fallback ofensivo não significa ação de segurança ofensiva. Significa recuperação proativa: detectar cedo, isolar, reparar, reconciliar e testar novamente. Fallback defensivo significa preservar confidencialidade, integridade e disponibilidade mínima, preferindo falhar fechado quando houver risco.

### 7.1 Princípios defensivos

- fail closed para identidade, autorização e classificação incertas;
- escrita transacional ou compensável;
- dados anteriores preservados até a nova versão ser validada;
- retries limitados, com backoff e jitter;
- circuit breaker para provedores externos;
- nenhuma exceção convertida silenciosamente em resultado vazio;
- modo degradado sempre identificado na resposta e nos logs;
- secrets nunca registrados em logs;
- mudanças de schema com backup, verificação e rollback;
- operações destrutivas exigem confirmação e trilha de auditoria.

### 7.2 Princípios ofensivos

- health checks e synthetic queries contínuas;
- detecção automática de documentos presos em processamento;
- fila de reprocessamento e dead-letter queue;
- reconciliação periódica entre fontes, versões, chunks e embeddings;
- validação automática de dimensão e quantidade de embeddings;
- rebuild controlado de índices quando houver corrupção ou regressão;
- comparação entre retrieval esperado e observado;
- rotação e revogação rápida de credenciais de consumidores;
- rollback automático de release quando smoke tests críticos falharem;
- post-mortem e teste de regressão para toda falha de severidade alta.

### 7.3 Matriz global de fallback

| Falha | Fallback defensivo | Fallback ofensivo |
|---|---|---|
| Identidade não resolvida | Negar acesso e registrar evento sanitizado | Invalidar sessão/token e executar diagnóstico de configuração |
| RLS ou policy inconsistente | Bloquear release e manter versão anterior | Rodar suíte cross-tenant e restaurar policy conhecida |
| Embedding indisponível | Manter versão anterior; nova versão fica pendente | Retry limitado, circuit breaker e reprocessamento posterior |
| Busca vetorial indisponível | Usar full-text autorizado e sinalizar modo degradado | Validar extensão/índice e reconstruir índice de forma controlada |
| Full-text indisponível | Usar vetor autorizado e sinalizar modo degradado | Recriar search vectors/índices e executar synthetic queries |
| Reranker indisponível | Aplicar score determinístico versionado | Isolar provider e recalibrar com conjunto de avaliação |
| Compressão por LLM indisponível | Gerar Context Pack extrativo, citado e limitado | Reprocessar packs não críticos quando o provider recuperar |
| Ingestão parcial | Não promover nova versão | Compensar writes, reabrir job e reconciliar artefatos |
| API indisponível | Leitura de packs imutáveis previamente autorizados, se aplicável | Health check, restart controlado e rollback de release |
| MCP indisponível | Consumidor usa API autenticada ou export manual auditado | Reiniciar gateway e testar tools antes de reabrir tráfego |
| Banco indisponível | Interromper writes e não servir dados sem autorização comprovável | Acionar recuperação Supabase e validar integridade antes de liberar |
| Vazamento suspeito | Revogar consumidor e bloquear escopo afetado | Investigar logs, rotacionar credenciais e executar varredura de impacto |

---

## 8. Micro-tasks por fase

Cada micro-task deve resultar em um commit pequeno e revisável sempre que possível. Uma task só pode ser marcada como concluída após seus critérios de aceite e testes aplicáveis passarem.

### Fase A - Governança e bootstrap

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-A01 | Registrar ADR da arquitetura compartilhada | Nenhuma | ADR declara CML canônica, ownership e consumidores | Não iniciar código sem decisão aprovada | Comparar ADR com implementações existentes e listar divergências |
| CML-A02 | Definir terminologia de identidade | A01 | Glossário elimina ambiguidade entre organization, workspace, product e environment | Rejeitar campos ou APIs ambíguas | Criar lint/checklist arquitetural para termos proibidos |
| CML-A03 | Definir política de fontes de verdade | A01 | Hierarquia de PRDs, ADRs, decisions e código documentada | Conflito permanece aberto e não é indexado como decisão vigente | Detectar documentos contraditórios durante ingestão |
| CML-A04 | Inicializar projeto TypeScript e scripts mínimos | A01 | install, lint, typecheck e test executam localmente | Pin de versões e lockfile obrigatório | CI detecta drift de lockfile e runtime |
| CML-A05 | Criar CI inicial | A04 | PR executa lint, typecheck, unit e secret scan | Merge bloqueado quando job crítico falhar | Reexecutar flakiness uma vez e abrir diagnóstico automático |
| CML-A06 | Criar templates de issue, PR e ADR | A01 | Novas mudanças registram risco, migração, testes e rollback | PR incompleto não pode ser aprovado | Bot/check valida campos obrigatórios |
| CML-A07 | Documentar configuração sem secrets | A04 | `.env.example` contém somente nomes e valores seguros | Startup falha com mensagem clara para variável ausente | Script de doctor identifica inconsistências sem imprimir valores |

### Fase B - Contratos de domínio

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-B01 | Modelar IDs e tipos de escopo | A02 | Tipos distinguem organization, product, environment e consumer | Não aceitar string genérica em fronteiras externas | Testes de contrato tentam cruzar IDs incompatíveis |
| CML-B02 | Modelar visibilidade e classificação | B01 | Enum/policy cobre escopos aprovados e default é privado | Valor desconhecido é negado | Auditor identifica registros sem classificação válida |
| CML-B03 | Definir contrato de documento e versão | B01 | Fonte, documento e versão possuem ciclos separados | Nova versão não substitui a atual antes de validação | Reconciliador detecta múltiplas versões correntes |
| CML-B04 | Definir contrato de chunk e citação | B03 | Chunk preserva source URI, heading e linhas quando disponíveis | Chunk sem referência não pode ser promovido | Job reextrai referências ausentes |
| CML-B05 | Definir contrato de query e resultado | B01-B02 | Query carrega identidade, filtros, budget e versão de estratégia | Filtro inválido não amplia escopo | Contract tests geram combinações de filtros |
| CML-B06 | Definir contrato imutável de Context Pack | B05 | Pack registra query, chunks, strategy, modelo, budget e citações | Pack publicado não é alterado | Regeração cria nova revisão comparável |
| CML-B07 | Versionar contratos públicos | B01-B06 | API e MCP expõem versão explícita | Versão desconhecida retorna erro compatível | Teste de compatibilidade roda contra fixtures anteriores |

### Fase C - Banco e migrations

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-C01 | Vincular projeto ao Supabase dedicado | A07 | CLI reconhece somente project ref aprovado | Script exige confirmação do project ref antes de operação remota | Doctor compara URL/ref esperados com ambiente |
| CML-C02 | Criar migration de schemas e extensões | C01 | pgvector e extensões instalam em banco vazio com schema consistente | Migration aborta antes de criar objetos dependentes | Smoke verifica tipo vector e operadores após apply |
| CML-C03 | Criar registries de identidade | C02, B01 | Organizations, products, environments e consumers possuem constraints | Não permitir órfãos ou duplicatas canônicas | Seed idempotente reconcilia registros conhecidos |
| CML-C04 | Criar tabelas de fontes e documentos | C03, B03 | Source, document e versionamento atendem invariantes | Versão inválida não se torna corrente | Constraint tests tentam estados impossíveis |
| CML-C05 | Criar chunks, summaries, entities e relations | C04 | Todas as relações preservam tenant e evidência | Relation cross-tenant é bloqueada | Auditor procura inconsistências históricas |
| CML-C06 | Criar jobs, queries, resultados, packs e logs | C03-C05 | Auditoria referencia consumidor e escopo | Evento sem identidade não é persistido como válido | Reconciliador detecta queries/packs incompletos |
| CML-C07 | Criar índices vetoriais, textuais e de filtros | C05 | Explain e smoke confirmam uso adequado em fixtures | Release mantém índices anteriores até validação | Benchmark detecta regressão e sugere rebuild |
| CML-C08 | Criar funções de consistência de escopo | C03-C06 | Escritas cross-tenant falham no banco | Banco é última barreira mesmo com bug de aplicação | Property tests exploram combinações de escopo |
| CML-C09 | Criar seed mínimo da Correnth e produtos | C03 | Seed é idempotente e não contém credenciais | Seed não concede acesso amplo automaticamente | Diff de seed detecta alteração inesperada |
| CML-C10 | Testar instalação limpa | C02-C09 | Reset local aplica todas as migrations sem intervenção | Falha bloqueia merge e deploy | Pipeline captura migration exata e artefato de diagnóstico |
| CML-C11 | Documentar backup e rollback | C02-C10 | Runbook cobre backup, restore e migrations irreversíveis | Migration destrutiva exige backup confirmado | Ensaio restaura fixture e compara checksums |

### Fase D - Autorização e segurança

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-D01 | Definir matriz de capabilities | B02, C03 | Read, ingest, decide e administer são separadas | Default sem capability | Auditor lista grants excessivos |
| CML-D02 | Implementar RLS de registries | C03, D01 | Organização não acessa registry privado de outra | Negar em identidade incompleta | Testes automatizados com múltiplas organizações |
| CML-D03 | Implementar RLS de conteúdo | C04-C06, D01 | Visibilidade e produto são aplicados em select e write | Qualquer policy incerta bloqueia operação | Suíte cross-tenant tenta leitura e mutação adversarial |
| CML-D04 | Implementar credenciais de consumers | D01-D03 | Cada app/agente possui identidade revogável e escopo mínimo | Token inválido ou expirado é negado | Rotação/revogação testada sem reiniciar toda plataforma |
| CML-D05 | Proibir service role em consumidores | D04 | Secret scan e arquitetura impedem exposição | Startup de consumer rejeita service role | CI busca padrões e nomes de variáveis proibidos |
| CML-D06 | Implementar sanitização de logs | D01 | Logs não contêm token, secret ou conteúdo classificado indevido | Payload sensível é redigido | Testes injetam canários e verificam ausência |
| CML-D07 | Criar threat model | D01-D06 | Ameaças de tenant escape, prompt injection e exfiltração têm controles | Feature de risco alto permanece desabilitada | Exercícios adversariais viram testes de regressão |
| CML-D08 | Configurar rate limits e budgets | D04 | Consumer possui limites por ação e custo | Excesso é bloqueado sem degradar outros tenants | Alertas identificam abuso e permitem revogação automática controlada |

### Fase E - Ingestão e versionamento

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-E01 | Criar source registry e allowlist | C04, D03 | Somente roots e conectores autorizados são lidos | Caminho fora da allowlist é rejeitado | Scanner informa fontes ignoradas e motivo |
| CML-E02 | Criar walker com exclusões seguras | E01 | Ignora node_modules, builds, caches, Graphify e pastas ocultas configuradas | Symlinks/path traversal não escapam da raiz | Testes geram árvore hostil e confirmam isolamento |
| CML-E03 | Implementar secret scanning pré-ingestão | E02 | Canários e padrões conhecidos são bloqueados/redigidos conforme policy | Documento suspeito vai para quarantine | Revarredura automática após atualização de regras |
| CML-E04 | Implementar normalização Markdown | E02 | Headings, line endings e metadata ficam determinísticos | Original permanece intacto e rastreável | Golden tests detectam mudança de normalização |
| CML-E05 | Implementar hashing e idempotência | E04 | Conteúdo igual não gera versão/chunks duplicados | Conflito de hash não promove versão | Reconciliador detecta duplicatas e propõe reparo |
| CML-E06 | Implementar chunking por heading e budget | E04 | Chunks respeitam limites e preservam contexto/citações | Chunk oversized é dividido, nunca truncado silenciosamente | Benchmark compara estratégias em corpus conhecido |
| CML-E07 | Implementar provider de embeddings | E06 | Provider é substituível e valida dimensão/ordem/count | Falha mantém versão pendente | Retry limitado, circuit breaker e fila de reprocessamento |
| CML-E08 | Implementar persistência segura de versão | E05-E07 | Nova versão só vira corrente após todos os artefatos obrigatórios | Versão anterior continua servindo | Compensação remove artefatos incompletos e reabre job |
| CML-E09 | Implementar summaries | E08 | Summary registra modelo, versão e fontes | Ausência não impede busca base; status fica parcial | Job posterior completa summaries e mede cobertura |
| CML-E10 | Implementar extração de entities/relations | E08 | Relações possuem evidência e confidence | Relação sem evidência não é publicada | Revisão/reextração prioriza baixa confiança |
| CML-E11 | Implementar ingestion jobs e dead-letter | E01-E10 | Status, tentativas, erro sanitizado e recovery são observáveis | Retry infinito é proibido | Jobs presos são detectados e reabertos ou isolados |
| CML-E12 | Criar CLI de ingestão | E11, D04 | Dry-run, ingest, reindex e status funcionam sem expor secrets | Operação remota exige project ref e escopo explícitos | `doctor` executa checks e sugere correções seguras |
| CML-E13 | Criar reconciliador de corpus | E08-E12 | Fontes, versões, chunks e embeddings podem ser comparados | Reparo destrutivo exige aprovação | Reparo seguro reprocessa somente itens divergentes |

### Fase F - Retrieval e qualidade

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-F01 | Criar corpus de avaliação | E08 | Perguntas, respostas esperadas e fontes cobrem Correnth e RedRise | Fixture sensível usa conteúdo sintético | Falhas reais adicionam casos de regressão |
| CML-F02 | Implementar full-text multilíngue | C07, E08 | Português, inglês e identificadores exatos são recuperáveis | Fallback `simple` não amplia autorização | Synthetic queries verificam idiomas e screen IDs |
| CML-F03 | Implementar vector search | C07, E07-E08 | Similaridade retorna somente escopo autorizado | Vetor inválido é rejeitado | Health check valida extensão, dimensão e índice |
| CML-F04 | Implementar merge e normalização de scores | F02-F03 | Estratégia é determinística e versionada | Fonte ausente recebe peso zero explícito | Benchmark recalibra pesos sem alterar versão anterior |
| CML-F05 | Implementar metadata e entity filters | F04, E10 | Filtros são aplicados no banco e não apenas após retrieval | Filtro inválido retorna erro, não busca ampla | Property tests combinam filtros e escopos |
| CML-F06 | Implementar reranking v1 | F04-F05 | Reranker preserva autorização e registra versão | Score determinístico serve como fallback | Circuit breaker isola reranker com regressão |
| CML-F07 | Implementar query logging | C06, F04 | Query, strategy, resultados e latência são auditáveis | Conteúdo classificado é redigido conforme policy | Análise detecta zero-results e regressões recorrentes |
| CML-F08 | Implementar modo degradado explícito | F02-F06 | Resposta informa componentes indisponíveis | Nunca retornar empty silencioso por erro técnico | Health monitor tenta recuperação e valida antes de sair do modo degradado |
| CML-F09 | Criar benchmark de relevância e latência | F01-F08 | Baseline versionado mede recall, precision proxy, zero-results e p95 | Regressão bloqueia release crítico | Bisect de estratégia identifica alteração causadora |

### Fase G - Context Pack Builder

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-G01 | Definir seções e schema do pack | B06, F01 | Hard constraints, decisões, conflitos e fontes são distintos | Campo desconhecido não é descartado silenciosamente | Contract test compara schema com consumidores |
| CML-G02 | Implementar seleção e deduplicação | F04-F06 | Chunks repetidos ou versões antigas não duplicam contexto | Manter citações mesmo ao deduplicar | Métrica identifica redundância e ajusta seleção |
| CML-G03 | Implementar budget real de tokens | G02 | Input e output respeitam budget configurado | Priorizar hard constraints e fontes ao reduzir | Testes de fronteira exploram conteúdos extremos |
| CML-G04 | Implementar pack extrativo determinístico | G01-G03 | Pack útil pode ser produzido sem LLM de compressão | É o fallback padrão confiável | Avaliação compara pack extrativo com resposta esperada |
| CML-G05 | Implementar compressão semântica opcional | G04 | Síntese não remove requisitos e mantém citações | Falha retorna pack extrativo sinalizado | Reprocessar packs não críticos quando provider recuperar |
| CML-G06 | Detectar conflitos e perguntas abertas | G02-G05 | Decisões divergentes são expostas, não resolvidas por alucinação | Conflito bloqueia afirmação como verdade vigente | Criar item de revisão humana/decision registry |
| CML-G07 | Persistir snapshot imutável | C06, G01-G06 | Pack publicado preserva fontes, estratégia e modelo | Regeneração cria nova revisão | Diff entre revisões detecta context drift |
| CML-G08 | Testar packs contra corpus de avaliação | F01, G07 | Casos críticos contêm decisões e constraints esperadas | Falha bloqueia integração com Work Orders | Resultado ruim alimenta ajuste de retrieval e regressão |

### Fase H - API e MCP

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-H01 | Definir OpenAPI versionada | B07, D01, F08, G07 | Contratos de search, packs, documents e decisions estão publicados | Campo inválido gera erro estruturado | Contract tests executam exemplos da spec |
| CML-H02 | Implementar autenticação da API | D04 | Consumer resolvido antes de custo ou consulta | Não gerar embedding para request não autenticado | Monitor detecta tentativas e revoga tokens comprometidos |
| CML-H03 | Implementar endpoints de search e packs | H01-H02 | Escopo vem da identidade, não do payload isolado | Erros técnicos não viram lista vazia | Synthetic requests validam respostas e modo degradado |
| CML-H04 | Implementar endpoints de documents e decisions | H01-H02 | Read/write respeitam capabilities separadas | Write negado por default | Auditoria e alertas para decisão registrada/alterada |
| CML-H05 | Implementar endpoints de ingestion jobs | H01-H02, E11 | Somente consumidores autorizados iniciam/reabrem jobs | Reindex não é apenas mudança de status | Monitor acompanha job até estado terminal |
| CML-H06 | Implementar idempotency keys | H03-H05 | Retry do cliente não duplica pack, decisão ou job | Request conflitante é rejeitado | Reconciliador identifica duplicações legadas |
| CML-H07 | Criar MCP Gateway sobre core/API | H03-H05 | Tools oficiais reutilizam contratos, sem lógica duplicada | MCP indisponível não afeta API | Self-test executa protocolo e uma consulta sintética autorizada |
| CML-H08 | Implementar tool capabilities | H07, D01 | Cada tool exige capability específica | Tool desconhecida ou não permitida é negada | Auditor lista chamadas negadas e grants excessivos |
| CML-H09 | Publicar SDK/adapter TypeScript mínimo | H01-H05 | RedScale consome contratos sem acessar tabelas diretamente | Mudança incompatível exige nova versão | Compatibility suite roda contra SDK anterior |

### Fase I - Observabilidade e operação

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-I01 | Definir métricas e SLOs iniciais | E11, F07, H03 | Métricas cobrem ingestão, retrieval, pack, erros, custo e autorização | Ausência de métrica crítica bloqueia produção | Alertas são exercitados com falhas sintéticas |
| CML-I02 | Implementar health e readiness | H03-H07 | Readiness verifica DB, extensões e dependências essenciais | Instância não recebe tráfego se não estiver pronta | Recovery testa dependências antes de reabrir tráfego |
| CML-I03 | Implementar correlation IDs | H03-H07 | Request, query, pack e provider call são correlacionáveis | IDs não carregam dados sensíveis | Ferramenta de diagnóstico monta timeline de falha |
| CML-I04 | Criar alertas de segurança e operação | D06-D08, I01 | Tenant denial anômalo, jobs presos e provider failure geram alerta | Alertas não incluem secrets/conteúdo privado | Runbook liga alerta a contenção e recuperação |
| CML-I05 | Criar runbooks | I01-I04 | Há procedimentos para DB, provider, RLS, vazamento e rollback | Operador interrompe writes quando integridade for incerta | Game day valida e melhora runbooks |
| CML-I06 | Configurar dependabot/updates controlados | A05 | Atualizações passam testes e são agrupadas por risco | Major update não é automático | CVE crítico abre fluxo acelerado com regressão completa |

### Fase J - Console no RedScale

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-J01 | Definir contrato de integração RedScale | H09 | RedScale usa SDK/API, nunca tabelas CML diretamente | Sem credenciais válidas, tela fica indisponível e explícita | Health panel aponta configuração incorreta |
| CML-J02 | Implementar Health Overview | J01, I01-I02 | Status real de serviços, jobs e retrieval é exibido | Dados stale recebem timestamp/aviso | Ações de diagnóstico executam checks seguros |
| CML-J03 | Implementar Documents e Versions | J01, H04 | Lista todas as versões autorizadas e estado correto | Ação destrutiva exige confirmação | Reconcile/reindex disponível conforme capability |
| CML-J04 | Implementar Ingestion Jobs | J01, H05 | Job, tentativas, erro e recovery são visíveis | Erro sanitizado e conteúdo preservado | Reabrir ou quarentenar job com auditoria |
| CML-J05 | Implementar Search Console | J01, H03 | Mostra scores, estratégia, modo e citações | Falha não aparece como zero-results | Comparação de queries ajuda diagnóstico |
| CML-J06 | Implementar Context Pack Builder | J01, H03 | Pack, budget, fontes e revisão são visíveis | Pack degradado é identificado | Regenerar nova revisão e comparar diff |
| CML-J07 | Implementar Decisions e conflitos | J01, H04, G06 | Decisão vigente e conflitos possuem trilha | Conflito não é resolvido automaticamente | Abrir fluxo humano de revisão |
| CML-J08 | Implementar Consumers e permissions | J01, D04 | Grants, rotação e revogação são operáveis | Revogação é fail closed | Auditor sugere remoção de grants não usados |
| CML-J09 | Implementar Retrieval Logs | J01, F07 | Operador rastreia query até fontes e pack | Conteúdo sensível permanece redigido | Detectar regressões por produto/consumer |

### Fase K - Adapters, migração e desativação de duplicatas

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-K01 | Criar consumer RedScale | H09, J01 | RedScale autentica e consulta com escopo mínimo | Credencial separada e revogável | Smoke contínuo valida acesso autorizado |
| CML-K02 | Criar consumer RedRise | H09 | RedRise consulta sem dependência de schema | Sem fallback para banco local duplicado | Comparar respostas do adapter com API canônica |
| CML-K03 | Registrar fontes Correnth | E01, K01 | Docs transversais usam visibilidade aprovada | Documento sem classificação vai para quarantine | Revisão identifica fontes não cobertas |
| CML-K04 | Registrar fontes RedScale | E01, K01 | Docs RedScale são isolados e compartilhados explicitamente | Default `product_private` | Testes confirmam negação ao RedRise onde aplicável |
| CML-K05 | Registrar fontes RedRise | E01, K02 | Docs RedRise são isolados e citáveis | Default `product_private` | Corpus de avaliação valida cobertura |
| CML-K06 | Inventariar CML do RedRise v2 | A01, H09 | Código, dados e contratos são classificados como reutilizar, migrar ou descartar | Nenhum dado é importado cegamente | Ferramenta compara schema e conteúdo com canônico |
| CML-K07 | Exportar dados válidos do protótipo | K06, C11 | Export sanitizado contém fontes e metadados necessários | Export não inclui credenciais nem relações inconsistentes | Validador gera relatório de rejeições |
| CML-K08 | Reindexar no schema canônico | K03-K07 | Dados são recriados pelas fontes e pipeline oficial | Versões antigas permanecem fora do retrieval | Reconciliação compara documentos, chunks e queries amostrais |
| CML-K09 | Executar shadow comparison | K08, F09 | Queries críticas comparam protótipo e CML canônica | Divergência crítica impede cutover | Ajustar retrieval e adicionar regressões |
| CML-K10 | Cortar RedScale para CML canônica | K01, J02-J09 | Console opera apenas pela CML oficial | Feature flag permite retorno temporário somente à UI anterior, sem writes duplos | Rollback automático se smoke crítico falhar |
| CML-K11 | Cortar RedRise para adapter oficial | K02, K09 | RedRise não executa migrations, MCP ou ingestão próprios | Falha mantém feature indisponível, não duplica dados | Rollback de client version, preservando CML oficial |
| CML-K12 | Desativar CML duplicada do RedRise v2 | K11 | Rotas, scripts e UI duplicados são removidos ou claramente arquivados | Backup/export aprovado antes da remoção | Scanner de repo impede reintrodução de imports/rotas antigas |
| CML-K13 | Desativar foundation duplicada do RedScale | K10 | Migrations e serviços locais deixam de ser autoridade | Manter histórico documental, não runtime concorrente | CI impede acesso direto a tabelas CML |

### Fase L - Gate para Work Orders

| ID | Micro-task | Dependência | Critério de aceite | Fallback defensivo | Fallback ofensivo |
|---|---|---|---|---|---|
| CML-L01 | Executar suíte de migrations limpas | C10-C11 | Apply, teste e restore passam em ambiente descartável | Não promover schema falho | Capturar diagnóstico e testar migration corrigida do zero |
| CML-L02 | Executar suíte cross-tenant/product | D02-D08 | Nenhuma leitura ou escrita indevida é possível | Gate bloqueia release | Cada finding vira teste permanente |
| CML-L03 | Executar suíte de ingestão e recovery | E01-E13 | Happy path e falhas parciais preservam versão válida | Gate bloqueia cutover | Chaos cases alimentam reconciliador |
| CML-L04 | Executar benchmark de retrieval | F01-F09 | Baseline aprovado para perguntas críticas | Estratégia anterior permanece ativa | Recalibrar em nova versão e comparar |
| CML-L05 | Executar suíte de Context Packs | G01-G08 | Packs respeitam budget, constraints e citações | Pack extrativo permanece disponível | Casos ruins retornam a retrieval/compressão |
| CML-L06 | Executar testes API/MCP | H01-H09 | Auth, capabilities, idempotência e tools passam | Consumidor não recebe acesso parcial inseguro | Contract suite identifica componente divergente |
| CML-L07 | Validar observabilidade e runbooks | I01-I06 | Alertas e recovery são demonstrados | Produção não abre sem readiness | Game day corrige runbooks e automações |
| CML-L08 | Validar RedScale como operador | J01-J09, K10 | Operador pesquisa, gera pack, audita e recupera job | Console não executa writes sem capability | Fluxo E2E aponta quebra até serviço de origem |
| CML-L09 | Validar RedRise como consumidor | K11 | RedRise consulta somente seu escopo e conteúdo compartilhado | Integração falha fechada | Synthetic query contínua detecta regressão |
| CML-L10 | Aprovar relatório de readiness | L01-L09 | Owner aprova evidências, riscos residuais e rollback | PRD-RS-002 permanece bloqueado | Findings abrem micro-tasks adicionais antes da aprovação |

---

## 9. Ordem de execução recomendada

```text
A Governança
→ B Contratos
→ C Banco
→ D Segurança
→ E Ingestão
→ F Retrieval
→ G Context Packs
→ H API/MCP
→ I Operação
→ J RedScale
→ K Adapters e migração
→ L Readiness gate
→ PRD-RS-002 Work Order Data Model
```

Segurança, testes e documentação são atividades contínuas. A ordem acima representa dependência funcional, não permissão para adiar controles críticos até o final.

---

## 10. Estratégia de testes

### 10.1 Unitários

- normalização e chunking;
- hashing e idempotência;
- classificação e autorização;
- merge e normalização de scores;
- seleção, deduplicação e token budget;
- sanitização de logs;
- schemas e contratos públicos.

### 10.2 Integração

- migrations em banco vazio;
- constraints e triggers;
- RLS com múltiplas organizações/produtos;
- ingestão real com provider mockado;
- vector, full-text, hybrid e reranking;
- jobs, retries e compensação;
- Context Pack persistido;
- API autenticada e MCP Gateway.

### 10.3 E2E

- registrar fonte autorizada;
- indexar documento;
- consultar contexto;
- gerar Context Pack;
- inspecionar fontes e auditoria no RedScale;
- negar consulta cross-tenant;
- revogar consumer;
- recuperar job com falha;
- operar em modo degradado explícito.

### 10.4 Resiliência e segurança

- provider timeout;
- embedding com dimensão inválida;
- banco temporariamente indisponível;
- índice vetorial ausente;
- job interrompido entre writes;
- token expirado ou revogado;
- tentativa de path traversal;
- documento contendo secret canário;
- prompt injection em documento;
- tentativa de relação cross-tenant;
- rollback de migration e release.

---

## 11. Definition of Ready de uma micro-task

Uma micro-task está pronta para execução quando:

- objetivo e limite estão claros;
- dependências foram concluídas;
- risco de dados e segurança foi avaliado;
- acceptance criteria são verificáveis;
- fallback defensivo foi definido;
- fallback ofensivo foi definido;
- testes esperados estão listados;
- impacto de migration ou contrato está identificado.

---

## 12. Definition of Done de uma micro-task

Uma micro-task está concluída quando:

- implementação ou documentação foi revisada;
- lint e typecheck passam quando aplicáveis;
- testes aplicáveis passam;
- falhas não são ocultadas silenciosamente;
- observabilidade foi adicionada quando necessária;
- fallback foi testado ou demonstrado;
- documentação e ADRs foram atualizados;
- nenhum secret foi adicionado;
- commit é pequeno, identificável e reversível;
- evidência foi anexada ao task log ou PR.

---

## 13. Gate obrigatório antes do PRD-RS-002

O Work Order Data Model não pode começar até que:

- a CML seja instalável do zero pelas migrations versionadas;
- nenhuma parte canônica dependa do RedRise;
- organizations, products, environments e consumers sejam entidades reais;
- RLS e constraints cross-tenant estejam testadas;
- consumidores não usem service role;
- ingestão, versionamento, quarantine e reindexação funcionem;
- busca híbrida e modo degradado sejam explícitos;
- Context Packs sejam compactos, imutáveis e citados;
- API e MCP compartilhem os mesmos contratos e autorização;
- RedScale opere a CML pela API/SDK;
- RedRise consuma a CML por adapter fino;
- implementações duplicadas estejam desativadas;
- observabilidade, alertas, backup e rollback tenham sido exercitados;
- o relatório CML-L10 esteja aprovado.

Após o gate, o PRD-RS-002 poderá referenciar entidades estáveis:

```text
work_order
├── organization_id
├── product_id
├── environment_id
├── context_query_id
├── context_pack_id
├── context_snapshot
├── retrieval_status
└── requested_by_consumer_id
```

---

## 14. Riscos principais

| Risco | Impacto | Mitigação |
|---|---|---|
| Copiar o protótipo sem auditoria | Reintroduzir bugs e acoplamentos | Inventário K06 e reindexação por fontes oficiais |
| Tenant escape | Vazamento crítico | RLS, constraints, capabilities e suíte adversarial |
| Context drift | Agentes usam decisões obsoletas | Versionamento, status vigente, conflitos e avaliações |
| Dependência de provider | Indisponibilidade/custo | Abstração, circuit breaker e fallback determinístico |
| Migrations não reproduzíveis | Ambientes divergentes | Reset contínuo, smoke e runbook de restore |
| Context Pack alucinado | Implementação incorreta | Citações, pack extrativo e testes contra corpus |
| Duplicação por produto | Divergência operacional | SDK/adapters finos e desativação K12-K13 |
| Excesso de arquitetura inicial | Atraso do RedScale | Estrutura simples, escopo v1 e gates mensuráveis |

---

## 15. Métricas iniciais

- percentual de documentos indexados com sucesso;
- tempo de ingestão por documento e chunk;
- jobs em retry, failed e dead-letter;
- zero-result rate por produto;
- taxa de queries em modo degradado;
- cobertura de citações em Context Packs;
- aderência ao token budget;
- latência p50/p95 de search e pack;
- custo por ingestão, query e pack;
- tentativas de autorização negadas;
- divergências encontradas pelo reconciliador;
- casos do corpus de avaliação aprovados.

Os thresholds de release devem ser definidos após o primeiro baseline real, evitando metas arbitrárias sem medição.

---

## 16. Política de commits e releases

- uma micro-task por commit sempre que possível;
- mensagem de commit referencia o ID da micro-task;
- migrations e código dependente entram juntos quando atomicidade for necessária;
- nenhuma migration aplicada remotamente antes de passar em banco descartável;
- nenhuma mudança de contrato sem versão e compatibility test;
- nenhuma release sem smoke de autorização, retrieval e Context Pack;
- rollback deve ser conhecido antes do deploy;
- commits não contêm `.env`, tokens, service role ou dumps sensíveis.

---

## 17. Resultado esperado

Ao concluir este PRD, a Correnth terá uma única plataforma de contexto e memória capaz de servir RedScale, RedRise e futuros produtos sem replicação de infraestrutura.

```text
Uma CML
→ múltiplas organizações
→ múltiplos produtos
→ consumidores com menor privilégio
→ contexto citado e auditável
→ recuperação segura de falhas
→ fundação estável para Work Orders
```

Somente então o RedScale deverá iniciar o Work Order Data Model.
