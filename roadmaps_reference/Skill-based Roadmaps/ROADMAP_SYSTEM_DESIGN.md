# System Design Roadmap - Checklist (2026)

> Baseado em https://roadmap.sh/system-design - Tudo que voce precisa saber para desenhar sistemas de larga escala em 2026.
>
> Fonte auxiliar: https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/system-design

---

## 1. Fundamentos

### 1.1 Requisitos

- [ ] Separar requisitos funcionais e nao funcionais
- [ ] Definir restricoes de negocio, custo, prazo e regulacao
- [ ] Estimar usuarios, trafego, armazenamento e crescimento
- [ ] Identificar SLOs, SLIs e SLAs
- [ ] Explicitar trade-offs antes da solucao

### 1.2 Conceitos Base

- [ ] Latencia, throughput e disponibilidade
- [ ] Consistencia, durabilidade e resiliencia
- [ ] Escala vertical vs horizontal
- [ ] Stateful vs stateless services
- [ ] Backpressure, timeouts e retries
- [ ] CAP theorem e PACELC

---

## 2. Networking & Web

- [ ] DNS
- [ ] HTTP/HTTPS
- [ ] TCP/UDP
- [ ] TLS
- [ ] Proxies e reverse proxies
- [ ] API gateways
- [ ] Load balancers L4/L7
- [ ] CDNs e edge caching

---

## 3. Dados

### 3.1 Modelagem

- [ ] Entidades, relacionamentos e invariantes
- [ ] Normalizacao e denormalizacao
- [ ] Particionamento por dominio
- [ ] Data ownership por servico
- [ ] Retencao, arquivamento e purga

### 3.2 Bancos

- [ ] Relacionais: PostgreSQL, MySQL
- [ ] Document stores: MongoDB
- [ ] Key-value stores: Redis, DynamoDB
- [ ] Columnar/analytics: BigQuery, ClickHouse
- [ ] Search: Elasticsearch, OpenSearch
- [ ] Graph databases quando o problema pedir relacoes complexas

### 3.3 Escala de Dados

- [ ] Indexes
- [ ] Read replicas
- [ ] Sharding
- [ ] Partitioning
- [ ] Caching
- [ ] CQRS quando leitura e escrita divergem muito
- [ ] Event sourcing quando auditoria e reconstrucao forem centrais

---

## 4. Cache

- [ ] Browser cache
- [ ] CDN cache
- [ ] Application cache
- [ ] Database query cache
- [ ] Cache aside
- [ ] Write-through e write-behind
- [ ] TTL, invalidacao e cache stampede
- [ ] Consistencia entre cache e fonte de verdade

---

## 5. Comunicacao entre Servicos

- [ ] REST
- [ ] GraphQL
- [ ] gRPC
- [ ] WebSockets
- [ ] Server-Sent Events
- [ ] Message queues
- [ ] Pub/sub
- [ ] Event-driven architecture
- [ ] Idempotencia em chamadas e consumidores

---

## 6. Arquiteturas

- [ ] Monolith
- [ ] Modular monolith
- [ ] Microservices
- [ ] Service-oriented architecture
- [ ] Serverless
- [ ] Event-driven systems
- [ ] Hexagonal architecture para limites internos
- [ ] Multi-tenant architecture

---

## 7. Confiabilidade

- [ ] Health checks
- [ ] Graceful degradation
- [ ] Circuit breakers
- [ ] Bulkheads
- [ ] Retry com exponential backoff
- [ ] Dead-letter queues
- [ ] Disaster recovery
- [ ] RPO e RTO
- [ ] Chaos testing basico

---

## 8. Seguranca

- [ ] Autenticacao e autorizacao
- [ ] OAuth 2.0 e OIDC
- [ ] Least privilege
- [ ] Secrets management
- [ ] Criptografia em transito e repouso
- [ ] Rate limiting
- [ ] WAF e DDoS protection
- [ ] Audit logging
- [ ] Threat modeling

---

## 9. Observabilidade

- [ ] Logs estruturados
- [ ] Metrics
- [ ] Traces distribuidos
- [ ] Dashboards
- [ ] Alertas orientados a sintomas
- [ ] Correlation IDs
- [ ] OpenTelemetry
- [ ] Runbooks

---

## 10. Padroes de Design de Sistemas

- [ ] API Gateway
- [ ] BFF (Backend for Frontend)
- [ ] Saga pattern
- [ ] Outbox pattern
- [ ] Strangler Fig
- [ ] CQRS
- [ ] Event sourcing
- [ ] Leader election
- [ ] Consistent hashing
- [ ] Rate limiter

---

## 11. Entrevistas e Pratica

- [ ] Clarificar requisitos antes de desenhar
- [ ] Fazer estimativas rapidas
- [ ] Definir APIs e modelo de dados
- [ ] Desenhar arquitetura de alto nivel
- [ ] Explorar gargalos
- [ ] Discutir trade-offs
- [ ] Evoluir para escala maior
- [ ] Documentar riscos e alternativas

### Sistemas para praticar

- [ ] URL shortener
- [ ] Feed de noticias
- [ ] Chat em tempo real
- [ ] File storage
- [ ] Video streaming
- [ ] Notification system
- [ ] Search autocomplete
- [ ] Rate limiter
- [ ] Payment processing

---

## Stack Recomendada para 2026

| Area | Escolha base |
| ---- | ------------ |
| Diagramas | C4 Model + Mermaid |
| APIs | REST + OpenAPI; gRPC para chamadas internas criticas |
| Banco principal | PostgreSQL |
| Cache | Redis |
| Mensageria | Kafka, RabbitMQ ou SQS |
| Observabilidade | OpenTelemetry + dashboards |
| Infra | Docker + IaC |
| Deploy | CI/CD com GitHub Actions |
| Documentacao | ADRs + diagramas versionados |

---

## Fontes de pesquisa

- [roadmap.sh — System Design](https://roadmap.sh/system-design) — estrutura principal do percurso.
- [Repositório oficial developer-roadmap — System Design](https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/system-design) — tópicos e histórico da fonte.
- [Google SRE Book](https://sre.google/sre-book/table-of-contents/) — confiabilidade, capacidade e operação em escala.
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/) — observabilidade distribuída.
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) — persistência relacional e operação.
- [C4 Model](https://c4model.com/) — comunicação visual de sistemas e contêineres.

---

*Ultima atualizacao: Julho 2026*
