# Backend Developer Roadmap - Checklist (2026)

> Baseado em https://roadmap.sh/backend - Guia passo a passo para se tornar um desenvolvedor backend moderno.
>
> Fonte auxiliar: https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/backend

---

## 1. Fundamentos da Web

### 1.1 Internet & Protocolos

- [ ] Entender como a internet funciona: DNS, HTTP, HTTPS, TLS, hosting
- [ ] Conhecer request/response, headers, cookies, cache e status codes
- [ ] Diferenciar client, server, proxy, gateway e CDN
- [ ] Entender CORS, preflight requests e politicas de origem

### 1.2 Linha de Comando

- [ ] Navegacao em terminal
- [ ] Variaveis de ambiente
- [ ] Scripts de automacao
- [ ] SSH e chaves publicas/privadas
- [ ] Logs, pipes, redirecionamento e processos

### 1.3 Git & GitHub

- [ ] Init, clone, add, commit, push, pull
- [ ] Branching, merging, rebase e cherry-pick
- [ ] Pull requests e code review
- [ ] Conventional commits
- [ ] GitHub Actions basico para CI

---

## 2. Linguagem Backend

### 2.1 Escolher uma linguagem principal

- [ ] TypeScript/Node.js (recomendado para stack full-stack)
- [ ] Python
- [ ] Java
- [ ] Go
- [ ] C#/.NET
- [ ] Ruby ou PHP como conhecimento de ecossistema

### 2.2 Conceitos obrigatorios

- [ ] Tipos, funcoes, classes e modulos
- [ ] Tratamento de erros e excecoes
- [ ] Concorrencia, async/await, threads ou goroutines
- [ ] Gerenciamento de pacotes
- [ ] Padroes de projeto comuns
- [ ] Testes unitarios da linguagem escolhida

---

## 3. APIs

### 3.1 REST

- [ ] Recursos, colecoes e verbos HTTP
- [ ] Status codes corretos
- [ ] Paginacao, filtros, ordenacao e busca
- [ ] Versionamento de API
- [ ] Idempotencia
- [ ] OpenAPI / Swagger

### 3.2 GraphQL e RPC

- [ ] Schemas, queries e mutations
- [ ] Resolvers e N+1 problem
- [ ] gRPC e Protocol Buffers
- [ ] Webhooks
- [ ] Server-Sent Events (SSE)
- [ ] WebSockets

### 3.3 Contratos

- [ ] DTOs e validacao de entrada
- [ ] Serializacao e desserializacao
- [ ] Backward compatibility
- [ ] Error envelope padronizado
- [ ] Documentacao consumivel por frontend e integradores

---

## 4. Bancos de Dados

### 4.1 Relacionais

- [ ] PostgreSQL (recomendado)
- [ ] Modelagem relacional
- [ ] SQL: SELECT, JOIN, GROUP BY, indexes
- [ ] Transacoes, isolation levels e locks
- [ ] Migrations
- [ ] Query planning e EXPLAIN

### 4.2 NoSQL

- [ ] MongoDB/document stores
- [ ] Key-value stores
- [ ] Wide-column stores
- [ ] Trade-offs entre consistencia, consulta e escala

### 4.3 Cache e Busca

- [ ] Redis
- [ ] Cache aside, write-through e TTL
- [ ] Invalidation strategy
- [ ] Search engines: Elasticsearch, OpenSearch ou Meilisearch
- [ ] Denormalizacao consciente

---

## 5. Autenticacao & Autorizacao

- [ ] Sessions e cookies seguros
- [ ] JWT e refresh tokens
- [ ] OAuth 2.0 e OpenID Connect
- [ ] RBAC e ABAC
- [ ] Password hashing com Argon2 ou bcrypt
- [ ] MFA e recovery flows
- [ ] Secrets management
- [ ] Rate limiting por usuario, IP e chave de API

---

## 6. Frameworks Backend

### 6.1 Node.js / TypeScript

- [ ] Fastify
- [ ] NestJS
- [ ] Express como conhecimento legado
- [ ] Prisma ou Drizzle ORM
- [ ] Zod para validacao

### 6.2 Alternativas por linguagem

- [ ] Python: FastAPI, Django
- [ ] Java: Spring Boot
- [ ] Go: Gin, Echo, Fiber
- [ ] C#/.NET: ASP.NET Core
- [ ] Ruby: Rails

---

## 7. Arquitetura de Aplicacao

- [ ] Layered architecture
- [ ] Clean Architecture / Hexagonal Architecture
- [ ] Domain-driven design basico
- [ ] Repositories, services e use cases
- [ ] Dependency injection
- [ ] Monolith modular antes de microservices
- [ ] Background jobs e workers
- [ ] Event-driven architecture

---

## 8. Mensageria & Processamento Assincrono

- [ ] Queues e pub/sub
- [ ] RabbitMQ
- [ ] Kafka
- [ ] SQS ou Pub/Sub gerenciado
- [ ] Retry, backoff e dead-letter queues
- [ ] Idempotent consumers
- [ ] Outbox pattern
- [ ] Sagas para fluxos distribuidos

---

## 9. Observabilidade

- [ ] Logging estruturado
- [ ] Metrics e dashboards
- [ ] Tracing distribuido
- [ ] Correlation IDs
- [ ] Health checks
- [ ] Alertas por SLO
- [ ] OpenTelemetry
- [ ] Error tracking

---

## 10. Testes

- [ ] Unit tests
- [ ] Integration tests com banco real/container
- [ ] Contract tests
- [ ] E2E tests de API
- [ ] Load tests
- [ ] Security tests basicos
- [ ] Test data builders e fixtures
- [ ] CI rodando lint, typecheck e testes

---

## 11. Seguranca

- [ ] OWASP Top 10
- [ ] SQL injection e parameterized queries
- [ ] XSS e output encoding quando aplicavel
- [ ] CSRF em apps com cookies
- [ ] SSRF, path traversal e deserializacao insegura
- [ ] Validacao de input no limite da aplicacao
- [ ] Dependency scanning
- [ ] Audit logs

---

## 12. Deploy & Infraestrutura

- [ ] Docker
- [ ] Docker Compose para desenvolvimento
- [ ] CI/CD com GitHub Actions
- [ ] Render (recomendado no ecossistema local)
- [ ] Vercel/Cloudflare Workers para APIs leves
- [ ] AWS/GCP/Azure como conhecimento cloud
- [ ] IaC: Terraform ou OpenTofu
- [ ] Blue/green ou rolling deploy

---

## 13. Performance & Escala

- [ ] Profiling de CPU e memoria
- [ ] Connection pooling
- [ ] Index tuning
- [ ] Caching estrategico
- [ ] CDN e edge cache
- [ ] Load balancing
- [ ] Horizontal scaling
- [ ] Backpressure e circuit breakers

---

## 14. Entregaveis de Portfolio

- [ ] CRUD API com autenticacao e autorizacao
- [ ] API documentada com OpenAPI
- [ ] Sistema com filas e worker assincrono
- [ ] Projeto com PostgreSQL, migrations e seed
- [ ] Observabilidade com logs, metrics e traces
- [ ] Deploy automatizado com CI/CD
- [ ] Load test e relatorio de gargalos

---

## Stack Recomendada para 2026

| Camada | Tecnologia |
| ------ | ---------- |
| Linguagem | TypeScript |
| Runtime | Node.js LTS |
| Framework | Fastify ou NestJS |
| Validacao | Zod |
| Banco relacional | PostgreSQL |
| ORM/query | Prisma ou Drizzle |
| Cache | Redis |
| Mensageria | RabbitMQ ou SQS |
| Documentacao | OpenAPI / Swagger |
| Testes | Vitest + Supertest |
| Observabilidade | OpenTelemetry |
| Container | Docker |
| CI/CD | GitHub Actions |
| Deploy | Render |

---

## Fontes de pesquisa

- [roadmap.sh — Backend](https://roadmap.sh/backend) — estrutura principal do percurso.
- [Repositório oficial developer-roadmap — Backend](https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/backend) — tópicos e histórico da fonte.
- [MDN — HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP) — fundamentos e semântica do protocolo.
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) — banco relacional e operação.
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html) — contratos HTTP interoperáveis.
- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/) — requisitos verificáveis de segurança.

---

*Ultima atualizacao: Julho 2026*
