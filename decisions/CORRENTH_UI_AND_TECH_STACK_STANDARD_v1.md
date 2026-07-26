# Correnth — Padrão de UI e Stack Técnica v1

**Status:** Decisão canônica

**Escopo:** Todos os produtos do Grupo Correnth, incluindo RedRise, RedRose, Findfee, ADGency e serviços internos.

**Pacote visual compartilhado:** `@correnth/ui`, localizado em `D:\01_studio\correnth-ui`.

**Princípio:** privilegiar tecnologias consolidadas, tipadas, com documentação oficial forte, comunidade ampla, depuração simples e baixo acoplamento a fornecedores. Uma ferramenta opcional só entra quando resolver uma necessidade mensurável.

---

## 1. Stack-base obrigatória

| Camada | Padrão Correnth | Regra de uso |
|---|---|---|
| Framework web | Next.js com App Router | Aplicações web full-stack e BFFs. Preferir Server Components; usar Client Components apenas para interatividade. |
| UI | React + TypeScript em modo estrito | Código de produto deve ser tipado; evitar `any` sem justificativa. |
| Estilo | Tailwind CSS v4 com tokens CSS/OKLCH | Tokens semânticos, sem cores arbitrárias espalhadas nos componentes. |
| Componentes | shadcn/ui, Radix e CVA | Componentes vivem no repositório e são adaptados; blocks comunitários servem apenas como referência visual. |
| Feedback de ação | Sonner | Ações iniciadas pelo usuário devem informar sucesso, erro ou processamento. |
| Formulários | React Hook Form + Zod | Zod é a fonte de validação compartilhável entre UI, API e jobs. |
| Tabelas | TanStack React Table | Tabelas operacionais reutilizáveis com filtros, ordenação, paginação, visibilidade, seleção e ações por linha quando aplicável. |
| Gráficos | Recharts | Dashboards e métricas; dados devem ter estados de carregamento, vazio e erro. |
| Canvas de fluxos | @xyflow/react (React Flow) | Exclusivo para fluxos, nodes e conexões. Configuração detalhada ocorre em Dialogs, não em painéis laterais. |
| Ícones | Lucide React; Tabler como complemento | Não misturar estilos arbitrariamente na mesma superfície. |
| Backend | Supabase | Auth, PostgreSQL, RLS, Storage, Realtime e Edge Functions leves. |
| Banco | PostgreSQL | Fonte de verdade relacional, migrations versionadas e RLS por `organization_id`. |
| PostgreSQL local integrado | Runtime PostgreSQL provisionado pelo instalador | Produtos distribuídos por npm/npx ou Desktop Wizard devem oferecer modo local/autogerenciado, sem exigir que o usuário modele o banco manualmente. |
| Testes | Vitest + Playwright | Vitest para unidades/integrações; Playwright para fluxos E2E. |
| Lint | ESLint + typescript-eslint | Erros de lint e typecheck bloqueiam CI. |
| Pacotes | npm | Lockfile obrigatório; versões relevantes fixadas ou limitadas por faixa controlada. |

---

## 1.1 Stack atual declarada

Esta é a composição atual de referência para os produtos web Correnth. Versões devem ser confirmadas por repositório antes de upgrade, mas a direção tecnológica é canônica.

| Área | Tecnologia atual | Finalidade |
|---|---|---|
| Aplicação | Next.js App Router + React | Web full-stack, rotas, layouts, renderização e interatividade. |
| Linguagem | TypeScript | Tipagem de UI, domínio, contratos e automações. |
| Visual | Tailwind CSS v4 + shadcn/ui + Radix + CVA | Tokens, primitives acessíveis, componentes e variantes. |
| Formulários | Zod + React Hook Form | Contratos e validação de formulários. |
| UX operacional | Sonner, Lucide React, Tabler Icons, Vaul | Feedback, iconografia e interfaces auxiliares. |
| Dados visuais | TanStack React Table + Recharts + @dnd-kit | Tabelas, dashboards, gráficos e interações de drag-and-drop. |
| Fluxos | @xyflow/react | Canvas de processos e nodes. |
| Dados e autenticação | Supabase, PostgreSQL e RLS | Auth, dados relacionais, Storage, Realtime e funções leves. |
| IA | Proxy OpenRouter | Camada inicial de modelos, sem vazar provedor no domínio. |
| Cobrança | Stripe via funções server-side | Planos e pagamentos, quando o produto exigir. |
| Ferramentas Python | Python 3.12 + uv | Ingestão, IA, análise de dados e workers especializados. |
| Qualidade | ESLint + typescript-eslint + Vitest + Playwright | Qualidade estática, testes unitários e E2E. |

---

## 2. Padrão de UI Correnth

### 2.1 Regras de composição

- Usar design tokens semânticos: `background`, `foreground`, `primary`, `muted`, `destructive`, `border` e equivalentes.
- Construir sobre primitives shadcn/ui e componentes locais; nunca depender de markup copiado de block externo sem adaptação.
- Usar `Dialog`/modal para criação, edição, configuração, confirmação e revisão. Painéis laterais não são o padrão do ecossistema.
- Toda tela autenticada possui breadcrumb no topo da área útil; não usar separator visual entre breadcrumb/header e conteúdo.
- Ações destrutivas usam `AlertDialog` e confirmação explícita.
- Inputs inválidos mostram estado visual e mensagem contextual; Sonner informa o resultado da ação, não substitui validação de campo.
- Estados obrigatórios para superfícies de dados: loading, vazio, erro, sem permissão e sucesso.
- Acessibilidade é requisito: HTML semântico, foco visível, navegação por teclado, labels, descrições e contraste adequado.

### 2.2 Padrões reutilizáveis

- App Shell configurável: sidebar, breadcrumb, seletor de organização, notification bell e área de conteúdo.
- DataTable reutilizável: filtros, sorting, pagination, column visibility, row selection e row actions conforme a tela exigir.
- Dialog Wizard reutilizável: cabeçalho, contexto lateral, etapas, validação, revisão, cancelar/salvar e estado de envio.
- Sonner global com mensagens claras, curtas e sem expor detalhes técnicos/sigilosos. O `Toaster` deve usar posição fixa **`top-center`** em todos os produtos.
- Referências de UI devem ser registradas por `SCREEN-ID` em arquivo próprio, contendo link, block, adaptação necessária e prioridade.

### 2.3 Compartilhamento visual entre produtos

- Todo projeto do Grupo Correnth compartilha **somente recursos visuais** pelo pacote local `@correnth/ui`, em `D:\01_studio\correnth-ui`.
- O pacote pode conter tokens, temas, primitives shadcn, componentes visuais reutilizáveis, layout genérico, breadcrumb, sidebar genérica, padrões de Dialog, DataTable, Sonner e utilitários de estilo.
- O pacote não pode conter regras de negócio, rotas, consultas Supabase específicas, RBAC específico, serviços, schemas de banco ou lógica própria de qualquer produto.
- Produtos devem declarar suas próprias configurações, variáveis de ambiente, rotas, domínios, serviços e dependências de negócio; não importar arquivos internos diretamente de outro produto.

### 2.4 Persistência visual

- Preferências pessoais de UI são persistidas no banco, vinculadas ao usuário; local storage é apenas cache opcional.
- `@correnth/ui` é a fonte canônica dos elementos visuais compartilhados; mudanças nele exigem verificação nos produtos consumidores.

---

## 3. Arquitetura de aplicações

### 3.1 Organização de código

```text
src/
├── app/                 # rotas, layouts e composição de páginas
├── domains/             # regras de negócio por domínio
├── components/          # UI compartilhada e layout genérico
├── lib/                 # infraestrutura, clientes e utilitários
├── server/              # serviços e ações exclusivamente server-side
└── styles/              # tokens e estilos globais
```

- Organizar por domínio, por exemplo: `workstation`, `agents`, `settings`, `notifications`, `approvals`, `integrations`.
- Cada domínio contém seus schemas, tipos, serviços, componentes, dialogs e testes.
- Rotas compõem a UI; não devem conter regra de negócio extensa.
- Preferir monólito modular até existir motivo mensurável para serviços separados.

### 3.2 Contratos e APIs

- Padrão externo: HTTP/JSON com REST e contrato OpenAPI quando a API for pública ou consumida por outro produto/agente.
- Usar Zod para validar entrada e saída nos limites do sistema.
- Versionar APIs públicas; não quebrar contratos silenciosamente.
- Para comunicação interna simples, chamar módulos/serviços tipados; introduzir gRPC somente se houver necessidade comprovada de alto volume ou baixa latência entre serviços independentes.
- Toda operação assíncrona deve expor `request_id`/`run_id` e ser idempotente quando puder receber eventos duplicados.

### 3.3 Multi-tenant e dados

- Toda entidade de negócio multi-tenant deve carregar `organization_id`.
- RLS é a última barreira de autorização, não apenas uma convenção da UI.
- Usar migrations SQL versionadas e revisadas; nunca alterar schema de produção manualmente.
- Adotar soft delete/auditoria quando exclusão ou reconstrução histórica forem relevantes.
- `created_at`, `updated_at`, `created_by` e `updated_by` são obrigatórios em entidades críticas.
- Eventos de auditoria devem registrar ator, ação, entidade, antes/depois resumido e data.

### 3.4 PostgreSQL integrado para distribuição local

Todo produto Correnth que puder ser distribuído para instalação local deve suportar dois modos de banco:

| Modo | Uso | Implementação padrão |
|---|---|---|
| Cloud gerenciado | SaaS e equipes conectadas | Supabase/PostgreSQL gerenciado. |
| Local integrado | Instalação por npm/npx ou Desktop Wizard | PostgreSQL autogerenciado e provisionado pelo próprio instalador. |

Regras para o modo local integrado:

- O usuário escolhe `Cloud` ou `Local` no setup inicial; a aplicação não deve pedir configuração manual de schema, migrations ou conexão como etapa normal de uso.
- O comando npm/npx e o Desktop Wizard devem gerar a configuração local, iniciar o runtime e aplicar migrations de maneira idempotente.
- O baseline de implementação é Docker Compose com a imagem oficial PostgreSQL, pois torna versão, atualização, backup e diagnóstico reproduzíveis. Se Docker não estiver disponível, o Wizard pode oferecer instalação guiada de runtime gerenciado, mas não deve embutir binários improvisados no app.
- A aplicação acessa o banco por uma interface de conexão configurável (`DATABASE_URL` ou adaptador equivalente), sem acoplar o domínio a Supabase.
- O instalador deve oferecer: escolha de diretório de dados, porta, credencial local, verificação de saúde, backup/exportação e instrução de restauração.
- Dados locais devem permanecer no dispositivo escolhido pelo usuário. Telemetria, atualização e suporte remoto só podem acessar dados mediante consentimento explícito.
- Cada produto mantém migrations próprias e versionadas; upgrades executam backup/verificação antes de mudanças incompatíveis.

---

## 4. Complementos técnicos recomendados

Estes complementos preservam a stack principal e devem ser adotados quando seu caso de uso existir.

| Necessidade | Padrão recomendado | Motivo |
|---|---|---|
| Runtime | Node.js LTS, fixado em `.nvmrc`/`package.json` | Compatibilidade previsível entre máquinas e CI. |
| Formatação | Prettier, com ESLint responsável por qualidade/regras | Um único formatador reduz diffs e discussão mecânica. |
| Teste de API no browser | Mock Service Worker (MSW) | Testes determinísticos sem depender de serviços externos. |
| Documentação técnica | Markdown versionado, ADRs e OpenAPI | Decisões e contratos auditáveis e revisáveis. |
| Git | GitHub, PRs pequenos e Conventional Commits | Histórico legível, revisão simples e automação futura. |
| CI/CD | GitHub Actions | Executar install, lint, typecheck, testes, build e checagens de segurança em cada PR. |
| Containers | Docker com imagens OCI e multi-stage build | Portabilidade de produção; desenvolvimento local continua com `npm run dev` quando mais eficiente. |
| Infraestrutura | OpenTofu/Terraform para recursos declarativos | Infra revisável e reprodutível; começar somente quando houver recursos fora do Supabase/host. |
| Observabilidade | OpenTelemetry como padrão de instrumentação | Vendor-neutral para traces, métricas e logs; backend de visualização é intercambiável. |
| Logs | JSON estruturado, com correlação por `request_id`, `run_id` e `organization_id` | Depuração e auditoria sem parsing de texto livre. |
| Erros de aplicação | Sentry ou destino compatível com OpenTelemetry | Captura de exceções, agrupamento e alertas; não enviar PII/segredos. |
| Jobs longos | Interface de fila/job agnóstica; Postgres/outbox como baseline | Edge Functions recebem/validam eventos; execução longa deve ser durável e observável. |
| Cache e rate limit | Redis, somente após necessidade medida | Bom ecossistema e diagnóstico; PostgreSQL continua fonte de verdade. |
| Arquivos | Supabase Storage com interface de storage agnóstica | Começar integrado; permitir migração futura para S3 compatível. |
| Busca semântica | pgvector no PostgreSQL | Compatível com Context Memory Layer; migrar para Qdrant/Weaviate somente com necessidade comprovada. |
| Serviços Python | Python 3.12 + uv + FastAPI, apenas para workloads que justifiquem Python | Bom para IA, ingestão, ciência de dados ou workers; não duplicar backend web sem razão. |
| IA | Interface de provider/model agnóstica | Permitir OpenRouter, OpenAI, Anthropic, modelos locais ou futuros provedores sem vazar SDK específico pelo domínio. |
| Feature flags | Abstração própria pequena ou serviço compatível | Lançamentos graduais, kill switch e experimentos sem bifurcar código. |

---

## 4.1 Stacks recomendadas por tipo de aplicação

Estas recomendações partem da stack Correnth e preservam fronteiras agnósticas. A escolha não autoriza introduzir todas as ferramentas: cada produto adota somente o que o seu caso exige.

| # | Tipo de aplicação | Stack recomendada | Adições/decisões específicas |
|---:|---|---|---|
| 1 | SaaS B2B multi-tenant | Next.js, React, TypeScript, Tailwind, shadcn/ui, Supabase/PostgreSQL/RLS, Zod, TanStack Table, Playwright/Vitest | Padrão para RedRise, CRM, ERP e backoffice. `organization_id`, RLS, auditoria e feature flags são obrigatórios. |
| 2 | Automação de processos e agentes | Stack SaaS B2B + React Flow + Realtime + jobs persistidos no PostgreSQL + adaptador de IA | Edge Functions recebem/validam eventos; workers duráveis executam tarefas longas. Usar runs, idempotência, logs estruturados e OpenTelemetry. |
| 3 | Aplicação desktop local-first | Tauri + React/TypeScript/Tailwind/shadcn + PostgreSQL local integrado + sync/API opcional | O Desktop Wizard provisiona PostgreSQL local, migrations e backup. Tauri é a escolha para binários menores; acesso local é permitido apenas por comandos/permissions explícitos. |
| 4 | Aplicação mobile complementar | React Native + Expo + TypeScript + Expo Router + Supabase/API | Reutilizar contratos Zod, tokens e componentes visuais possíveis do `@correnth/ui`; não acessar PostgreSQL diretamente no app móvel. |
| 5 | Site institucional, landing page ou portal público | Next.js, TypeScript, Tailwind, shadcn/ui, Markdown/MDX, analytics/privacy-first | Priorizar renderização estática, SEO, performance, formulários server-side e CMS somente quando houver equipe editorial recorrente. |
| 6 | API pública, integrações e webhooks | Next.js Route Handlers ou Supabase Edge Functions para operações curtas; PostgreSQL; OpenAPI; Zod | Para processamento Python intenso, adicionar FastAPI como serviço separado. Assinaturas de webhook, rate limit, idempotência e versionamento são obrigatórios. |
| 7 | Plataforma de dados, IA, RAG ou memória contextual | PostgreSQL + pgvector + Storage + Python/uv + FastAPI para ingestão/workers + OpenTelemetry | Usar documentos, chunks, summaries, entities e relations; busca híbrida e reranking. Migrar camada vetorial só se pgvector deixar de atender. |
| 8 | Dashboard interno, administração e operações | Next.js, shadcn/ui, TanStack Table, Recharts, Supabase/PostgreSQL/RLS | DataTables reutilizáveis, filtros salvos quando necessário, auditoria e RBAC forte. Não adicionar canvas/IA se a operação não precisar. |
| 9 | Comércio, billing ou marketplace | Stack SaaS B2B + Stripe + webhooks idempotentes + auditoria de transações | Cobrança ocorre server-side; tratar eventos Stripe como fonte de evento auditável. Nunca confiar no estado de pagamento vindo do cliente. |
| 10 | Central de documentação, suporte e conhecimento | Next.js, Markdown/MDX, busca full-text no PostgreSQL, Storage para anexos, Supabase Auth opcional | Manter conteúdo versionado no Git quando técnico; suporte/feedback persistidos no banco, enviados por e-mail e ligados a contexto de tela. |

### Regras transversais para as dez stacks

- `@correnth/ui` é compartilhado apenas para visuais; dados e domínio continuam isolados por produto.
- Todo produto escolhe `Cloud gerenciado` ou `PostgreSQL local integrado` conforme seu modo de distribuição.
- Zod, logs estruturados, CI, testes proporcionais ao risco e revisão de segurança são padrão em todos os casos.
- APIs, IA, filas, observabilidade, storage e feature flags devem ser consumidos por interfaces/adapters, evitando dependência direta do fornecedor dentro do domínio.
- Preferir o monólito modular Next.js/PostgreSQL; extrair FastAPI, workers ou serviços separados apenas quando o perfil de carga, bibliotecas ou isolamento justificar.

### Decisões sensíveis por tipo de aplicação

Os itens abaixo são marcados como **[DECIDIR]**. Eles exigem decisão consciente por produto/PRD; não devem ser adotados automaticamente.

| Tipo | [DECIDIR] | Alternativas | Critério de decisão |
|---|---|---|---|
| SaaS B2B | Banco/distribuição | Supabase cloud; PostgreSQL local integrado; ambos | SaaS colaborativo tende a cloud; instalação isolada/offline pede runtime local. |
| Automação/agentes | Executor de jobs | Postgres/outbox + worker; serviço gerenciado; worker Python dedicado | Duração, volume, necessidade de retry, isolamento e bibliotecas necessárias. |
| Desktop local-first | Runtime local | Docker Compose; runtime PostgreSQL gerenciado pelo Wizard; apenas cloud | Disponibilidade de Docker, requisito offline, suporte técnico e sensibilidade dos dados. |
| Mobile | Estratégia de entrega | Expo gerenciado; Expo com development builds; nativo específico | Necessidade de módulos nativos, distribuição, notificações, offline e complexidade de plataforma. |
| Site público | Gestão de conteúdo | Markdown/MDX no Git; CMS headless; híbrido | Frequência editorial, autonomia de não-técnicos e necessidade de revisão/publicação. |
| APIs/integrações | Serviço de execução | Route Handler/Edge Function; FastAPI; serviço Node dedicado | Tempo de execução, dependências Python, streaming, volume e proximidade com dados. |
| IA/RAG | Camada vetorial | pgvector; Qdrant; Weaviate | Volume de vetores, latência, filtros, custo operacional e limites observados no PostgreSQL. |
| Dashboard interno | Forma de acesso a dados | Supabase direto com RLS; BFF/serviço de domínio; híbrido | Sensibilidade das regras, agregações complexas, auditoria e necessidade de esconder contratos internos. |
| Billing/comércio | Provedor e modelo de cobrança | Stripe; provedor regional; múltiplos provedores via adapter | Países atendidos, métodos de pagamento, impostos, custo e requisitos de recorrência. |
| Documentação/suporte | Visibilidade e autoria | Público; autenticado; híbrido; documentação em Git ou CMS | Sigilo do conteúdo, público-alvo, cadência editorial e participação de usuários externos. |

**Regra:** toda decisão marcada como **[DECIDIR]** deve ser registrada no PRD ou em um ADR antes da implementação, incluindo a alternativa escolhida, motivo, impacto e data prevista para revisão.

---

## 5. Segurança e privacidade

- Segredos ficam apenas em variáveis de ambiente/secret manager; nunca em commits, logs, mensagens Sonner ou payloads de cliente.
- Chaves Supabase com privilégio administrativo são exclusivamente server-side.
- Aplicar RLS, validação Zod, autorização por domínio e auditoria para ações sensíveis.
- Webhooks verificam assinatura, timestamp, idempotência e schema antes de criar Runs.
- Limitar upload por tipo/tamanho; fazer varredura/validação antes de processamento sensível.
- Sanitizar conteúdo exibido vindo de usuários, integrações ou LLMs; Markdown não confiável não pode executar HTML/script.
- Revisar dependências e vulnerabilidades no CI; atualizar dependências de segurança com prioridade.
- Definir retenção e exclusão de logs, arquivos e outputs de IA por produto/organização.

---

## 6. Confiabilidade e execução assíncrona

- Processos de longa duração, ingestões, agentes e automações usam job/run persistido no banco.
- Uma ação externa recebe status explícito: `queued`, `running`, `completed`, `failed`, `cancelled` ou equivalente do domínio.
- Eventos externos criam Run separada e idempotente; guardar identificador do evento de origem.
- Falhas mostram razão acionável ao usuário e preservam contexto técnico nos logs.
- Não implementar retry automático genérico sem semântica definida; cada domínio decide quando repetir é seguro.
- Adotar timeout, cancelamento e limites de tamanho para jobs e respostas.
- Health checks, backup/restauração e ambiente de staging são obrigatórios antes de produção crítica.

---

## 6.1 Operação agêntica do Grupo Correnth

- Os produtos e iniciativas internas do Grupo Correnth devem ser operados/orquestrados por **Paperclip**, como camada de coordenação de workforce agêntica.
- O objetivo operacional é **zero humans**: agentes executam planejamento, pesquisa, implementação, testes, documentação, deploy e monitoramento dentro de limites autorizados.
- Interações humanas ocorrem somente como **HITL (Human in the Loop)**, para decisões irreversíveis, gasto financeiro relevante, alteração de credenciais, publicação/produção, exceções de segurança e aprovações de negócio.
- Toda ação HITL deve ter contexto, impacto esperado, responsável, prazo e decisão registrada (`approved`, `rejected` ou `expired`).
- Agentes devem trabalhar por Work Orders com escopo, critérios de aceite, arquivos permitidos, testes exigidos e resultado esperado; nenhum agente recebe autorização implícita para alterar sistemas fora da Work Order.
- O Paperclip é ferramenta de operação interna e não deve vazar como dependência ou conceito obrigatório para clientes dos produtos Correnth.

---

## 7. Qualidade e testes

### Obrigatório em cada pull request

```text
npm ci
npm run lint
npm run typecheck
npm run test
npm run build
```

### Pirâmide mínima

- **Vitest:** schemas Zod, regras de RBAC, transições de status, serviços e utilitários.
- **Integração:** queries, RLS e Edge Functions contra ambiente de teste controlado.
- **Playwright:** autenticação, rotas, dialogs, fluxos críticos, permissões e estados de erro.
- **Teste manual guiado:** acessibilidade, responsividade e fluxos com integrações reais antes de release.

### Regra Correnth

Cada botão, opção, role, dialog, estado e fluxo crítico deve possuir critério de aceite e cobertura proporcional ao risco.

---

## 8. Adoção e exceções

1. A stack-base é o default; não se adiciona biblioteca por conveniência momentânea.
2. Uma exceção precisa registrar: problema, alternativas avaliadas, impacto, custo, risco, responsável e data de revisão.
3. Preferir padrões e interfaces próprias nos limites com fornecedores: storage, IA, jobs, observabilidade e feature flags.
4. Não antecipar microserviços, Kubernetes, event sourcing, Redis, vector DB externo ou Python service sem sinal concreto de necessidade.
5. Toda nova dependência deve ter licença compatível, manutenção ativa, documentação adequada e caminho de remoção.

---

## 9. Base de referências locais

Este padrão foi consolidado a partir dos materiais em `D:\00_docs\roadmaps_reference`, com ênfase em:

- `outros/SHADCN_GUIDE.md` — primitives, formulários, DataTable, theming, acessibilidade e composição.
- `Skill-based Roadmaps/ROADMAP_SYSTEM_DESIGN.md` — PostgreSQL, APIs, cache, arquitetura multi-tenant, segurança, observabilidade, Docker, IaC e CI/CD.
- `Skill-based Roadmaps/ROADMAP_DESIGN_SYSTEM.md` — tokens, governança, acessibilidade, TypeScript e TanStack Table.
- Roadmaps de Backend, Frontend, DevOps, DevSecOps, Docker, Git/GitHub, API Design, PostgreSQL, Redis, Python, Kubernetes e Terraform como referências complementares.

---

## 10. Revisão

- Revisar este documento a cada seis meses ou antes de uma mudança estrutural relevante.
- Mudanças devem ser registradas por ADR e aprovadas pelo responsável técnico do Grupo Correnth.
- A versão v1 é deliberadamente modular: a meta é evoluir sem reescrever os fundamentos.
