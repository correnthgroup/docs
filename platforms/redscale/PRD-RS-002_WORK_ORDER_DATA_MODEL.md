# PRD-RS-002 - Work Order Data Model

- Status: Approved
- Versao: 1.0
- Data: 2026-07-10
- Owner: RedScale
- Primeiro customer/configuracao: Correnth
- Relacionados: `ADR-0002`, `ADR-0001`, `PRD-CML-001`, `CML-L10`
- Pre-condicao: CML-L10 aprovado em `platforms/cml/READINESS-CML-L10.md`

---

## 1. Resumo executivo

RedScale implementara um control plane open-source/self-hosted generico para registrar, atribuir, executar, revisar e auditar Work Orders. Correnth sera a primeira configuracao real, sem regras hardcoded que impecam outras organizacoes.

A v1 cobre Organization, Product, Project, Work Order, referencias de contexto, criterios de aceite, testes, deliverables e eventos append-only. O runtime usa um Supabase operacional dedicado ao RedScale, independente dos bancos RedRise e CML.

CML e a unica camada de memoria. RedScale consome CML exclusivamente por API/SDK e persiste apenas IDs externos e proveniencia sem FK cross-database. Indisponibilidade da CML degrada contexto de forma explicita, mas nao corrompe nem apaga o estado operacional do Work Order.

---

## 2. Resultado esperado

Ao concluir esta PRD, um operador ou integracao autorizada consegue:

1. criar uma organization e seus products/projects;
2. criar um Work Order em `draft` com escopo, descricao e prioridade;
3. anexar referencias CML, criterios, testes e entregaveis esperados;
4. promover o Work Order por uma state machine validada;
5. atribuir e iniciar trabalho sem corrida ou double execution;
6. registrar evidencias e deliverables;
7. revisar, aceitar, rejeitar e arquivar;
8. reconstruir quem fez o que e quando por eventos imutaveis;
9. impedir acesso cross-organization no banco mesmo com erro da aplicacao.

## 3. Principios obrigatorios

- RedScale e produto generico; Correnth entra por seed/configuracao idempotente.
- `organization_id` e o boundary primario de isolamento.
- Dados operacionais vivem somente no Supabase RedScale dedicado.
- Nenhuma migration ou query RedScale referencia schema, URL interna ou tabela RedRise/CML.
- CML e acessada somente por API/SDK com consumer revogavel e least privilege.
- IDs externos nao recebem FKs, joins remotos ou validacao permissiva no banco.
- Escritas de dominio passam por comandos transacionais; tabelas nao sao uma API publica.
- Autorizacao e deny-by-default e aplicada por capability e RLS.
- Toda mutacao relevante gera evento append-only na mesma transacao.
- Updates concorrentes usam optimistic locking; last-write-wins e proibido.
- Falhas e degradacao sao explicitas, observaveis e nao criam memoria alternativa.

---

## 4. Escopo

### 4.1 Incluido

- organization boundary;
- products e projects;
- Work Orders e state machine;
- assignee externo nullable;
- referencias CML e referencias externas nao sensiveis;
- criterios de aceite ordenados;
- definicoes e resultados de testes;
- deliverables e evidencias;
- eventos append-only;
- principals, memberships e capabilities minimos;
- RLS, optimistic locking, idempotencia de comando e auditoria;
- adapter CML, circuit breaker, retry limitado e fallback explicito;
- migrations, seed Correnth, API/SDK de dominio e suites de teste.

### 4.2 Fora de escopo

- heartbeats, watchdogs, leases periodicos e wakeup queues;
- plugins, marketplace e runtime skill injection;
- budgets avancados, token accounting e enforcement financeiro;
- agent registry, org chart, hiring, reporting lines e lifecycle de agentes;
- schedules, routines e recurring jobs;
- chat, comments, mentions e inbox;
- armazenamento binario proprio; deliverables usam URIs externas;
- workflow builder generico ou estados customizados;
- sub-workflows, dependencias em grafo e auto-delegacao;
- Obsidian, GBrain ou qualquer memoria alem da CML;
- copia, fork, compatibilidade de API ou dependencia de Paperclip.

---

## 5. Modelo conceitual

```text
Organization
|-- Product
|   `-- Project
|       `-- Work Order
|           |-- Context Ref -> CML API/SDK (external ID only)
|           |-- Acceptance Criterion
|           |-- Test Case / Test Result
|           |-- Deliverable
|           `-- Event (append-only)
`-- Principal Membership / Capabilities
```

### 5.1 Organization, Product e Project

- `organization` representa o customer/tenant e o limite de RLS.
- `product` representa uma linha de produto dentro da organization.
- `project` agrupa Work Orders e pertence a exatamente um product.
- slugs sao unicos dentro do parent, case-insensitive, e nao sao usados como chave externa.
- registros podem ser desativados, mas nao hard-deleted enquanto possuirem filhos.

### 5.2 Work Order

Work Order e o agregado de consistencia. Seu row atual otimiza leitura operacional; `work_order_events` preserva o audit trail. Eventos nao substituem backups nem exigem event sourcing para reconstruir todas as projections na v1.

Campos obrigatorios para sair de `draft`: titulo, descricao, project ativo, ao menos um criterio de aceite e ao menos um teste definido. Contexto CML e opcional no schema e pode ser exigido por configuracao da organization no futuro, fora desta PRD.

### 5.3 Principal e assignee

A v1 evita um agent registry prematuro:

- `principal_type`: `user`, `service`, `agent` ou `system`;
- `principal_id`: ID opaco e estavel emitido pelo identity provider/integracao;
- `assigned_agent_id`: `text nullable`, sem FK, contendo o ID opaco do agente;
- quando `assigned_agent_id` nao for nulo, `assigned_principal_type` deve ser `agent` e `assigned_principal_id` deve ter o mesmo valor.

Memberships e grants autorizam principals, mas nao descrevem configuracao, provider ou runtime de agentes. Um registry futuro pode adicionar FK depois de migracao e reconciliacao explicitas.

---

## 6. Schema PostgreSQL detalhado

### 6.1 Tipos

```sql
create type work_order_state as enum (
  'draft', 'ready', 'assigned', 'running', 'blocked',
  'review', 'accepted', 'rejected', 'archived'
);
create type principal_type as enum ('user', 'service', 'agent', 'system');
create type criterion_status as enum ('pending', 'passed', 'failed', 'waived');
create type test_kind as enum ('automated', 'manual', 'inspection');
create type test_status as enum ('not_run', 'passed', 'failed', 'skipped');
create type deliverable_status as enum ('expected', 'submitted', 'verified', 'rejected');
create type context_ref_type as enum ('document', 'document_version', 'chunk', 'context_pack', 'decision');
```

Enums sao alterados somente por migration forward. Estados nao sao removidos ou renomeados in-place.

### 6.2 Colunas comuns

Todas as tabelas tenant-owned usam `id uuid primary key default gen_random_uuid()`, `organization_id uuid not null`, `created_at timestamptz not null default now()` e, quando mutaveis, `updated_at timestamptz not null default now()`. Timestamps vem do banco. IDs sao imutaveis.

Para garantir que uma FK local nao atravesse tenant, cada parent tenant-owned possui `unique (organization_id, id)` e filhos usam FK composta `(organization_id, parent_id)`.

### 6.3 Tabelas de boundary e acesso

```text
organizations
  id uuid PK
  slug citext UNIQUE NOT NULL
  name text NOT NULL CHECK length 1..160
  settings jsonb NOT NULL DEFAULT '{}'
  is_active boolean NOT NULL DEFAULT true
  created_at, updated_at

products
  id uuid PK
  organization_id uuid NOT NULL FK organizations
  slug citext NOT NULL
  name text NOT NULL CHECK length 1..160
  description text NULL
  is_active boolean NOT NULL DEFAULT true
  created_at, updated_at
  UNIQUE (organization_id, id)
  UNIQUE (organization_id, slug)

projects
  id uuid PK
  organization_id uuid NOT NULL
  product_id uuid NOT NULL
  slug citext NOT NULL
  name text NOT NULL CHECK length 1..160
  description text NULL
  is_active boolean NOT NULL DEFAULT true
  created_at, updated_at
  FK (organization_id, product_id) -> products
  UNIQUE (organization_id, id)
  UNIQUE (organization_id, product_id, slug)

principal_memberships
  id uuid PK
  organization_id uuid NOT NULL FK organizations
  principal_type principal_type NOT NULL
  principal_id text NOT NULL CHECK length 1..255
  display_name text NULL
  is_active boolean NOT NULL DEFAULT true
  created_at, updated_at
  UNIQUE (organization_id, id)
  UNIQUE (organization_id, principal_type, principal_id)

principal_capabilities
  membership_id uuid NOT NULL FK principal_memberships ON DELETE CASCADE
  organization_id uuid NOT NULL
  capability text NOT NULL CHECK capability IN (approved list)
  created_at timestamptz NOT NULL DEFAULT now()
  created_by_type principal_type NOT NULL
  created_by_id text NOT NULL
  PK (membership_id, capability)
  FK (organization_id, membership_id) -> principal_memberships
```

`organizations.settings` aceita somente chaves versionadas em contrato. Na v1, fica reservado para configuracao nao secreta e nao deve controlar bypass de RLS.

### 6.4 Work Orders

```text
work_orders
  id uuid PK
  organization_id uuid NOT NULL
  product_id uuid NOT NULL
  project_id uuid NOT NULL
  key text NOT NULL                         -- exemplo RS-42
  title text NOT NULL CHECK length 1..240
  description text NOT NULL DEFAULT ''
  state work_order_state NOT NULL DEFAULT 'draft'
  priority smallint NOT NULL DEFAULT 3 CHECK priority BETWEEN 1 AND 5
  assigned_agent_id text NULL CHECK length <= 255
  assigned_principal_type principal_type NULL
  assigned_principal_id text NULL CHECK length <= 255
  blocked_reason text NULL
  rejection_reason text NULL
  due_at timestamptz NULL
  ready_at, assigned_at, started_at, submitted_at timestamptz NULL
  accepted_at, rejected_at, archived_at timestamptz NULL
  version bigint NOT NULL DEFAULT 1 CHECK version > 0
  created_by_type principal_type NOT NULL
  created_by_id text NOT NULL CHECK length 1..255
  created_at, updated_at
  FK (organization_id, product_id) -> products
  FK (organization_id, project_id) -> projects
  UNIQUE (organization_id, id)
  UNIQUE (organization_id, key)
  CHECK assignee fields are all null or
        (assigned_agent_id is not null and assigned_principal_type = 'agent'
         and assigned_principal_id = assigned_agent_id)
```

Uma constraint trigger deferred valida que `project.product_id = work_order.product_id`. `key` e alocado por funcao transacional com sequence/counter por organization; o cliente nunca escolhe o proximo numero.

Indices minimos:

```sql
create index work_orders_board_idx
  on work_orders (organization_id, project_id, state, priority, updated_at desc);
create index work_orders_assignee_idx
  on work_orders (organization_id, assigned_agent_id, state)
  where assigned_agent_id is not null and state not in ('accepted', 'archived');
create index work_orders_active_idx
  on work_orders (organization_id, updated_at desc)
  where state <> 'archived';
```

### 6.5 Context refs

```text
work_order_context_refs
  id uuid PK
  organization_id uuid NOT NULL
  work_order_id uuid NOT NULL
  provider text NOT NULL DEFAULT 'cml' CHECK provider = 'cml'
  ref_type context_ref_type NOT NULL
  external_id text NOT NULL CHECK length 1..512
  external_version text NULL CHECK length <= 255
  source_uri text NULL CHECK length <= 2048
  label text NULL CHECK length <= 240
  content_hash text NULL CHECK content_hash ~ '^[a-f0-9]{64}$'
  resolution_status text NOT NULL DEFAULT 'unverified'
    CHECK IN ('unverified', 'resolved', 'unavailable', 'forbidden', 'stale')
  last_resolved_at timestamptz NULL
  metadata jsonb NOT NULL DEFAULT '{}'
  created_by_type, created_by_id, created_at
  FK (organization_id, work_order_id) -> work_orders ON DELETE CASCADE
  UNIQUE NULLS NOT DISTINCT
    (organization_id, work_order_id, provider, ref_type, external_id, external_version)
```

Nao existe FK para CML. `metadata` tem limite de 16 KiB, schema JSON versionado e nao armazena conteudo, embeddings, prompts, secrets ou resposta integral da CML. `source_uri` e informativa; retrieval usa `external_id` e `external_version`.

### 6.6 Criterios, testes e resultados

```text
work_order_criteria
  id uuid PK
  organization_id, work_order_id
  position integer NOT NULL CHECK position >= 0
  description text NOT NULL CHECK length 1..2000
  status criterion_status NOT NULL DEFAULT 'pending'
  evidence_uri text NULL
  waived_reason text NULL
  version bigint NOT NULL DEFAULT 1
  created_at, updated_at
  FK tenant-scoped -> work_orders ON DELETE CASCADE
  UNIQUE (organization_id, work_order_id, position)
  CHECK status <> 'waived' OR waived_reason IS NOT NULL

work_order_tests
  id uuid PK
  organization_id, work_order_id
  position integer NOT NULL CHECK position >= 0
  name text NOT NULL CHECK length 1..240
  kind test_kind NOT NULL
  command text NULL
  expected_result text NOT NULL CHECK length 1..4000
  is_required boolean NOT NULL DEFAULT true
  version bigint NOT NULL DEFAULT 1
  created_at, updated_at
  FK tenant-scoped -> work_orders ON DELETE CASCADE
  UNIQUE (organization_id, work_order_id, id)
  UNIQUE (organization_id, work_order_id, position)

work_order_test_results
  id uuid PK
  organization_id, work_order_id, test_id
  attempt integer NOT NULL CHECK attempt > 0
  status test_status NOT NULL
  summary text NOT NULL CHECK length 1..4000
  evidence_uri text NULL
  output_hash text NULL
  executed_by_type principal_type NOT NULL
  executed_by_id text NOT NULL
  executed_at timestamptz NOT NULL DEFAULT now()
  created_at timestamptz NOT NULL DEFAULT now()
  FK tenant-scoped -> work_orders
  FK (organization_id, work_order_id, test_id) -> work_order_tests
  UNIQUE (organization_id, test_id, attempt)
```

Test results sao append-only. Um novo run cria novo `attempt`; nao sobrescreve resultado anterior. `command` e texto declarativo e nao e executado pelo banco ou por esta PRD.

### 6.7 Deliverables

```text
work_order_deliverables
  id uuid PK
  organization_id, work_order_id
  name text NOT NULL CHECK length 1..240
  description text NULL CHECK length <= 2000
  status deliverable_status NOT NULL DEFAULT 'expected'
  uri text NULL CHECK length <= 2048
  media_type text NULL CHECK length <= 255
  checksum_sha256 text NULL CHECK checksum_sha256 ~ '^[a-f0-9]{64}$'
  submitted_by_type principal_type NULL
  submitted_by_id text NULL
  submitted_at, verified_at timestamptz NULL
  version bigint NOT NULL DEFAULT 1
  created_at, updated_at
  FK tenant-scoped -> work_orders ON DELETE CASCADE
  UNIQUE (organization_id, id)
  CHECK status = 'expected' OR
        (uri IS NOT NULL AND submitted_by_type IS NOT NULL
         AND submitted_by_id IS NOT NULL AND submitted_at IS NOT NULL)
  CHECK status <> 'verified' OR verified_at IS NOT NULL
```

Arquivos ficam em storage/repository externo autorizado. A v1 persiste referencia e integridade, nao blobs.

### 6.8 Eventos append-only e idempotencia

```text
work_order_events
  id uuid PK
  organization_id uuid NOT NULL
  work_order_id uuid NOT NULL
  sequence bigint NOT NULL CHECK sequence > 0
  event_type text NOT NULL CHECK length 1..120
  from_state work_order_state NULL
  to_state work_order_state NULL
  actor_type principal_type NOT NULL
  actor_id text NOT NULL CHECK length 1..255
  command_id uuid NOT NULL
  command_hash text NOT NULL CHECK command_hash ~ '^[a-f0-9]{64}$'
  correlation_id uuid NULL
  causation_id uuid NULL
  payload jsonb NOT NULL DEFAULT '{}'
  occurred_at timestamptz NOT NULL DEFAULT now()
  FK tenant-scoped -> work_orders
  UNIQUE (organization_id, work_order_id, sequence)
  UNIQUE (organization_id, command_id)
```

`payload` tem schema por `event_type`, versao interna obrigatoria e limite de 32 KiB. Secrets, tokens, conteudo integral CML e output bruto de testes sao proibidos. Triggers bloqueiam `UPDATE` e `DELETE` para todos, inclusive funcoes de aplicacao. Retencao e correcao ocorrem por novo evento compensatorio; somente administracao de banco em incidente formal pode atuar fora do contrato.

Todo comando mutante recebe `command_id`. Retry com mesmo `command_id` retorna o resultado ja persistido; mesmo ID com payload diferente retorna `409 idempotency_conflict`.

---

## 7. State machine

### 7.1 Transicoes permitidas

| De | Para | Capability | Guards e efeito |
| --- | --- | --- | --- |
| `draft` | `ready` | `work_order.update` | campos minimos, >=1 criterio e >=1 teste; grava `ready_at` |
| `draft` | `archived` | `work_order.archive` | motivo obrigatorio; grava `archived_at` |
| `ready` | `draft` | `work_order.update` | motivo de replanejamento; limpa `ready_at` |
| `ready` | `assigned` | `work_order.assign` | assignee agente obrigatorio; grava `assigned_at` |
| `ready` | `archived` | `work_order.archive` | motivo obrigatorio |
| `assigned` | `ready` | `work_order.assign` | unassign; limpa assignee e `assigned_at` |
| `assigned` | `running` | `work_order.execute` | actor deve ser assignee; override exige tambem `work_order.assign`; grava `started_at` |
| `assigned` | `blocked` | `work_order.execute` | `blocked_reason` obrigatorio |
| `assigned` | `archived` | `work_order.archive` | somente sem execucao ativa; motivo obrigatorio |
| `running` | `blocked` | `work_order.execute` | `blocked_reason` obrigatorio |
| `running` | `review` | `work_order.execute` | deliverables esperados submetidos e testes required com ultimo resultado `passed`; grava `submitted_at` |
| `blocked` | `running` | `work_order.execute` | assignee presente; resolucao informada; limpa `blocked_reason` |
| `blocked` | `ready` | `work_order.assign` | replanejamento; limpa assignee e bloqueio |
| `blocked` | `archived` | `work_order.archive` | motivo obrigatorio |
| `review` | `accepted` | `work_order.review` | todos criterios `passed` ou `waived` com motivo; deliverables verificados; grava `accepted_at` |
| `review` | `rejected` | `work_order.review` | `rejection_reason` obrigatorio; grava `rejected_at` |
| `review` | `blocked` | `work_order.review` | dependencia externa descoberta; motivo obrigatorio |
| `rejected` | `ready` | `work_order.update` | plano/criterios/testes revisados ou justificativa explicita; limpa assignee e rejection ativa |
| `rejected` | `assigned` | `work_order.assign` | assignee obrigatorio; preserva historico de rejeicao em evento |
| `rejected` | `archived` | `work_order.archive` | motivo obrigatorio |
| `accepted` | `archived` | `work_order.archive` | arquivamento administrativo |

`archived` e terminal. Reabrir `accepted` ou `archived` exige novo Work Order relacionado em uma PRD futura; nao existe transicao escondida. Qualquer par nao listado retorna `409 invalid_transition`.

### 7.2 Comando transacional

`transition_work_order(organization_id, work_order_id, expected_version, target_state, command_id, actor, input)` executa em uma transacao:

1. valida JWT, membership e capability;
2. seleciona o Work Order sob RLS;
3. valida `expected_version` e state atual;
4. valida guards e invariantes;
5. atualiza row com `version = version + 1` e timestamps;
6. aloca `sequence = max(sequence) + 1` sob lock do Work Order;
7. insere evento com before/after minimo e razao;
8. commita ambos ou nenhum.

Os comandos sao o unico uso `security definer` aprovado por esta PRD. Cada funcao possui `search_path` fixo, owner dedicado sem login, superuser ou `BYPASSRLS`, valida claims/membership/capability internamente e opera com forced RLS. Privilegios DML diretos sao revogados dos roles de runtime; estes recebem apenas `EXECUTE` nas funcoes e `SELECT` autorizado. CI inspeciona owner, grants e `prosecdef`, e testes adversariais tentam chamar cada funcao com claims forjados.

---

## 8. Optimistic locking

Toda entidade mutavel do agregado possui `version bigint`. APIs de update exigem `expected_version` ou `If-Match`; ausencia retorna `428 precondition_required`.

```sql
update work_orders
set title = :title, version = version + 1, updated_at = now()
where organization_id = :organization_id
  and id = :id
  and version = :expected_version
returning *;
```

Zero rows retorna `409 version_conflict` com a versao atual somente se o caller ainda puder ler o objeto; caso contrario retorna `404`. Updates de criteria, tests e deliverables incrementam suas versoes e tambem incrementam `work_orders.version` na mesma transacao, evitando review sobre filhos alterados silenciosamente.

---

## 9. Capabilities e RLS

### 9.1 Capabilities aprovadas

```text
organization.read
organization.admin
project.read
project.manage
work_order.read
work_order.create
work_order.update
work_order.assign
work_order.execute
work_order.review
work_order.archive
event.read
event.append
```

`organization.admin` permite gerir memberships/grants, mas nao desativa RLS e nao substitui capabilities de dominio implicitamente. O seed Correnth concede grants explicitamente.

### 9.2 Identidade do request

JWT autenticado fornece `principal_type` e `principal_id`. A organization alvo vem da rota/recurso, nunca de um claim global confiado isoladamente. Helpers SQL resolvem membership ativa e `has_capability(organization_id, capability)`.

Service role nao e distribuida a UI, agentes ou integracoes. Migrations e jobs administrativos controlados sao os unicos usos permitidos no ambiente operacional.

### 9.3 Politicas

- `SELECT`: membership ativa na mesma `organization_id` e capability de leitura correspondente.
- `INSERT`: negado diretamente aos roles de runtime; funcoes de comando exigem capability de criacao/gestao e `WITH CHECK` na mesma organization.
- `UPDATE`: negado diretamente aos roles de runtime; funcoes de comando exigem capability e `USING`/`WITH CHECK` tenant-scoped.
- `DELETE`: negado em Work Orders, eventos, resultados e objetos com historico. Archive e o mecanismo de lifecycle.
- eventos: `SELECT` com `event.read`; insert somente pela funcao de comando com `event.append`; grants e trigger negam update/delete.
- memberships/grants: somente `organization.admin`, sem auto-grant cross-organization.

Toda tabela em `public` recebe RLS enabled e forced. Um teste de migration falha se tabela tenant-owned nova nao possuir policy. Views usam `security_invoker = true`.

### 9.4 Matriz minima de papeis de configuracao

| Perfil Correnth inicial | Capabilities |
| --- | --- |
| Operator | reads, create, update, assign, execute, archive, event append/read |
| Reviewer | reads, review, event append/read |
| Agent consumer | work order read/execute e event append no tenant autorizado |
| Organization admin | grants e configuracao, mais grants de dominio explicitamente escolhidos |

Perfis sao bundles de seed/configuracao, nao papeis hardcoded no enforcement.

---

## 10. Eventos de dominio

Eventos minimos:

```text
work_order.created
work_order.updated
work_order.transitioned
work_order.assigned
work_order.unassigned
work_order.blocked
work_order.context_ref_added
work_order.context_ref_resolved
work_order.criterion_updated
work_order.test_defined
work_order.test_recorded
work_order.deliverable_submitted
work_order.deliverable_verified
work_order.accepted
work_order.rejected
work_order.archived
```

Eventos usam nomes estaveis, payload `schema_version: 1`, actor, `command_id` e `command_hash` canonico. Um transition pode produzir um evento especializado e `work_order.transitioned`; para evitar duplicidade na v1, sera produzido apenas o evento especializado quando existir, sempre contendo `from_state` e `to_state`.

Outbox/event bus nao faz parte da v1. Consumers consultam API paginada por `(occurred_at, id)` ou `(work_order_id, sequence)`. Uma outbox futura nao altera a imutabilidade desta tabela.

---

## 11. Integracao CML

### 11.1 Contrato

- adapter usa SDK/API CML versionada e consumer RedScale revogavel;
- requests carregam organization/product/environment conforme contrato CML;
- RedScale nao recebe service role CML;
- timeouts sao curtos e configuraveis; retries apenas para falhas transitorias e operacoes idempotentes;
- circuit breaker impede cascata;
- logs registram request/correlation ID, status, latencia e external IDs, nunca secrets ou conteudo sensivel;
- retorno CML e tratado como dado externo nao confiavel, validado por schema e tamanho.

### 11.2 Fluxo de resolucao

1. Caller adiciona ref CML por ID/version conhecidos ou seleciona resultado via adapter.
2. RedScale persiste ref como `unverified` na transacao local.
3. Adapter resolve a ref pela CML e atualiza somente metadados permitidos e `resolution_status` com optimistic locking.
4. Inicio de execucao solicita Context Pack/version pelas refs resolvidas.
5. O run consumidor recebe resposta em memoria; RedScale nao persiste chunks ou embeddings.
6. Eventos guardam IDs, hash e status, nao o conteudo integral.

Refs versionadas sao preferidas. Ref sem versao deve registrar a versao retornada antes de contexto ser usado para execucao reproduzivel.

### 11.3 Fallbacks

| Falha | Comportamento |
| --- | --- |
| timeout/5xx CML | retry limitado com jitter; depois circuit open e `503 context_unavailable` |
| 404 externo | marca `unavailable`; nao remove ref; operador pode substituir |
| 401/403 | marca `forbidden`, alerta operacional e nao faz retry automatico continuo |
| resposta invalida/oversized | rejeita, registra erro de contrato e abre alerta |
| CML indisponivel ao editar estado local | permite CRUD/transicoes que nao exigem contexto live; mostra degradacao |
| CML indisponivel ao iniciar execucao que requer refs | bloqueia inicio com erro explicito; Work Order permanece `assigned` |
| contexto ja resolvido em cache TTL | pode ser usado somente se policy permitir e versao/hash coincidirem; resposta indica `stale_cache` |

Cache e opcional, criptografado quando contiver dados sensiveis, limitado por TTL e nunca pesquisavel como memoria. Nao ha fallback para Obsidian, GBrain, banco RedRise ou copia local permanente da CML.

---

## 12. API minima

```text
POST   /v1/organizations/:orgId/products
POST   /v1/organizations/:orgId/projects
GET    /v1/organizations/:orgId/work-orders
POST   /v1/organizations/:orgId/work-orders
GET    /v1/organizations/:orgId/work-orders/:id
PATCH  /v1/organizations/:orgId/work-orders/:id
POST   /v1/organizations/:orgId/work-orders/:id/transitions
POST   /v1/organizations/:orgId/work-orders/:id/context-refs
POST   /v1/organizations/:orgId/work-orders/:id/criteria
POST   /v1/organizations/:orgId/work-orders/:id/tests
POST   /v1/organizations/:orgId/work-orders/:id/test-results
POST   /v1/organizations/:orgId/work-orders/:id/deliverables
GET    /v1/organizations/:orgId/work-orders/:id/events
```

Mutacoes exigem `Idempotency-Key` UUID e `If-Match`/`expected_version`. Listas usam cursor, limite maximo e filtros allowlisted. Erros seguem envelope estavel com `code`, `message`, `request_id` e detalhes nao sensiveis. Banco nao e acessado diretamente por agentes.

---

## 13. Microtasks

### Fase A - Foundation e boundaries

| ID | Microtask | Dependencia | Aceite | Teste/fallback |
| --- | --- | --- | --- | --- |
| RS2-A01 | Vincular repo ao Supabase RedScale dedicado | Nenhuma | project ref difere de CML/RedRise e e validado por doctor | CI falha para refs/URLs proibidos |
| RS2-A02 | Criar env contract sem secrets | A01 | variaveis RedScale/CML separadas e documentadas | startup fail-closed sem config obrigatoria |
| RS2-A03 | Criar CI base | A02 | lint, typecheck, unit, migration reset e secret scan | merge bloqueado em job critico |
| RS2-A04 | Implementar seed Correnth idempotente | A01 | organization/products/config sem logica hardcoded | executar duas vezes sem duplicar |
| RS2-A05 | Adicionar architecture boundary checks | A01 | imports e SQL nao acessam RedRise/CML DB | fixtures proibidas falham CI |

### Fase B - Schema e invariantes

| ID | Microtask | Dependencia | Aceite | Teste/fallback |
| --- | --- | --- | --- | --- |
| RS2-B01 | Criar enums e organizations/products/projects | A01 | migrations aplicam em banco vazio | reset e rollback forward-only |
| RS2-B02 | Criar memberships/capabilities | B01 | grants tenant-scoped e allowlist | testes de duplicate/cross-tenant |
| RS2-B03 | Criar work_orders e key allocator | B01 | constraints, FKs compostas e indices presentes | concorrencia nao duplica key |
| RS2-B04 | Criar context refs | B03 | somente provider CML e sem FK externa | schema limita metadata e IDs invalidos |
| RS2-B05 | Criar criteria/tests/results | B03 | ordem, versao e results append-only | update/delete de result falha |
| RS2-B06 | Criar deliverables | B03 | URI/checksum/status consistentes | constraints rejeitam partial submit |
| RS2-B07 | Criar events e protections | B03 | sequence/idempotencia unicos; update/delete negados | adversarial SQL e retry tests |
| RS2-B08 | Criar invariant triggers deferred | B03-B07 | product/project/tenant e assignee consistentes | property tests geram combinacoes invalidas |

### Fase C - Autorizacao

| ID | Microtask | Dependencia | Aceite | Teste/fallback |
| --- | --- | --- | --- | --- |
| RS2-C01 | Implementar JWT principal resolution | B02 | identidade incompleta e negada | tokens ausentes/malformados |
| RS2-C02 | Implementar capability helpers | C01 | checks nao aceitam org do caller sem membership | revoke tem efeito imediato |
| RS2-C03 | Aplicar/force RLS em todas as tabelas | C02, B08 | policy coverage automatizada | suite cross-tenant CRUD |
| RS2-C04 | Restringir events e comandos | C03 | evento direto nao contorna domain command | actor spoof e delete falham |
| RS2-C05 | Implementar grant administration | C03 | admin nao cria grant em outra org | escalation e self-grant adversarial |

### Fase D - Commands e state machine

| ID | Microtask | Dependencia | Aceite | Teste/fallback |
| --- | --- | --- | --- | --- |
| RS2-D01 | Implementar CRUD versionado do agregado | B08, C03 | expected version obrigatoria | 428/409 e no lost update |
| RS2-D02 | Implementar transition command | D01, B07 | matrix e guards atomicos | todas as transicoes permitidas/proibidas |
| RS2-D03 | Implementar assignment/start atomicos | D02 | apenas um expected version inicia | teste concorrente com dois agentes |
| RS2-D04 | Implementar review/accept/reject | D02 | criterios, testes e deliverables gateiam review | fixtures incompletas falham fechadas |
| RS2-D05 | Implementar archive terminal | D02 | nenhum update/reopen escondido | API e DB rejeitam mutacao posterior |
| RS2-D06 | Implementar idempotency replay | D01-D05 | retry devolve mesmo resultado | payload divergente retorna conflito |

### Fase E - CML adapter

| ID | Microtask | Dependencia | Aceite | Teste/fallback |
| --- | --- | --- | --- | --- |
| RS2-E01 | Fixar SDK/API CML versionada | A02 | sem acesso DB/service role | secret/import scan |
| RS2-E02 | Implementar add/resolve context ref | B04, E01 | status e proveniencia persistidos | 200/404/403/invalid schema |
| RS2-E03 | Implementar Context Pack fetch | E02 | IDs/version/hash correlacionados | resposta sem citacao/versao rejeitada |
| RS2-E04 | Implementar timeout/retry/circuit breaker | E01 | falha nao bloqueia DB pool | fake server, latency e recovery tests |
| RS2-E05 | Implementar cache TTL opcional | E03 | nao pesquisavel, TTL/proveniencia explicitos | expiry, hash mismatch e encryption test |
| RS2-E06 | Implementar modo degradado UI/API | E04 | status visivel e nenhum fallback alternativo | outage end-to-end |

### Fase F - API, observabilidade e readiness

| ID | Microtask | Dependencia | Aceite | Teste/fallback |
| --- | --- | --- | --- | --- |
| RS2-F01 | Publicar OpenAPI v1 | D06, E06 | schemas, errors e headers versionados | contract snapshot |
| RS2-F02 | Implementar list/detail cursors | D01 | filtros allowlisted e tenant-scoped | pagination stability/cross-tenant |
| RS2-F03 | Implementar metrics/logs/audit views | F01 | request IDs, conflicts, transitions e CML status | secret redaction tests |
| RS2-F04 | Criar backup/restore runbook | B08 | restore em ambiente limpo comprovado | checksum/count comparison |
| RS2-F05 | Executar load/concurrency baseline | F02 | board query e transition dentro do SLO aprovado | explain plans e contention report |
| RS2-F06 | Executar readiness Correnth | F01-F05 | seed real, fluxo completo e evidencias versionadas | rollback e outage drill |

---

## 14. Gates de entrega

| Gate | Requisitos | Evidencia obrigatoria |
| --- | --- | --- |
| RS2-G01 Boundary | A01-A05 | project ref dedicado; scans sem dependencia DB CML/RedRise |
| RS2-G02 Schema | B01-B08 | clean reset; constraints e indices; schema dump revisado |
| RS2-G03 Isolation | C01-C05 | suites cross-tenant e privilege escalation verdes |
| RS2-G04 Workflow | D01-D06 | state matrix, concurrency, idempotencia e event atomicity verdes |
| RS2-G05 CML | E01-E06 | contract, outage, circuit recovery e no-alternate-memory verdes |
| RS2-G06 API/Operations | F01-F05 | OpenAPI, observabilidade, restore e baseline aprovados |
| RS2-G07 Customer validation | F06 | Correnth completa draft -> accepted -> archived sem bypass |

Nenhum gate e aprovado somente por demonstracao manual. Evidencias incluem comandos, versoes, fixtures e resultados reproduziveis. Falha de isolamento, evento mutavel, lost update ou dependencia de banco externo bloqueia release.

---

## 15. Estrategia de testes

### 15.1 Unitarios e property tests

- matrix completa de estados e guards;
- validacao de payload/event schema;
- capability mapping;
- optimistic locking e idempotency semantics;
- redaction e limites de metadata;
- geracao de combinations tenant/product/project invalidas.

### 15.2 Integration/database

- migrations em banco vazio e upgrade da versao anterior;
- RLS com duas organizations, principals ativos/revogados e todas capabilities;
- FKs compostas e deferred triggers;
- duas transacoes concorrentes para assignment/start/update;
- atomicidade row + event sob falha injetada;
- tentativa de update/delete em events e test results;
- explain dos indices principais;
- backup e restore.

### 15.3 Contract/CML

- fake CML server para success, timeout, 429, 5xx, 401, 403, 404 e payload invalido;
- SDK/API version mismatch;
- retry somente em metodo idempotente;
- circuit open/half-open/closed;
- stale cache marcado e hash/version mismatch rejeitado;
- verificacao de que nenhum teste conecta diretamente ao banco CML.

### 15.4 End-to-end

- Correnth seed -> project -> draft -> ready -> assigned -> running -> review -> accepted -> archived;
- reject -> revise -> assign -> accept;
- blocked -> running e blocked -> ready;
- CML outage durante edicao local e durante start;
- assignee concorrente e reviewer sem capability;
- acesso cross-tenant por URL, body tampered e ID conhecido.

---

## 16. SLOs e limites iniciais

- p95 read/list local <= 300 ms com 10 mil Work Orders por organization, excluindo rede do cliente;
- p95 transition local <= 500 ms sem chamada CML no caminho transacional;
- zero lost updates em testes de concorrencia;
- zero acesso cross-tenant em suite adversarial;
- evento presente para 100% das mutacoes de dominio bem-sucedidas;
- payload API maximo 256 KiB, evento 32 KiB, context metadata 16 KiB;
- timeout CML inicial de 3 s por tentativa, maximo 2 retries para falha transitoria, configuravel por ambiente;
- nenhuma chamada CML dentro de transacao Postgres.

Valores de performance sao baseline de aceite, nao promessa publica ate medicao em ambiente alvo.

---

## 17. Migracao, rollback e operacao

- migrations sao forward-only, imutaveis depois de aplicadas e testadas em clean reset;
- mudanca enum/constraint destrutiva usa expand-migrate-contract em releases separadas;
- deploy de API aceita schema anterior durante rollout somente quando houver necessidade concreta documentada;
- rollback de app preserva rows/eventos novos e nunca edita historico;
- rollback CML revoga/retrocede adapter, sem criar banco de memoria local;
- incidente de CML ativa modo degradado; incidente RedScale restaura backup no Supabase RedScale;
- refs externas quebradas permanecem auditaveis e podem ser substituidas por comando/evento.

## 18. Riscos e mitigacoes

| Risco | Mitigacao |
| --- | --- |
| tenant leak por query incorreta | forced RLS, FKs compostas e adversarial tests |
| double execution | expected version e transicao atomica |
| agent ID invalido | ID opaco nullable, capability/contract validation e eventos; registry futuro |
| drift CML | refs versionadas, hash, contract tests e status de resolucao |
| indisponibilidade CML | timeout, circuit breaker, modo degradado e cache TTL opcional |
| evento com segredo | allowlist de payload, redaction e limites de tamanho |
| Correnth virar hardcode | seed idempotente e teste com segunda organization fixture |
| escopo crescer para orquestrador completo | gates desta PRD e lista explicita de adiamentos |

## 19. Definition of Done

PRD-RS-002 esta concluida quando RS2-G01 a RS2-G07 estiverem aprovados, todas as microtasks possuirem evidencia, migrations forem reproduziveis e Correnth concluir o fluxo completo sem acesso direto a banco CML/RedRise. A release deve permanecer instalavel com uma segunda organization ficticia e sem qualquer ferramenta de memoria alem da CML.

Qualquer desvio de boundary, state machine, RLS, eventos ou memoria exige atualizacao desta PRD e, quando alterar decisao arquitetural, uma ADR substituta antes da implementacao.
