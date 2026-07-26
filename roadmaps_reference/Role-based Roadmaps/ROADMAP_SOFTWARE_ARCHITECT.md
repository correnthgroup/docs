# Software Architect Roadmap - Checklist (2026)

> Baseado em https://roadmap.sh/software-architect - Guia passo a passo para se tornar Software Architect em 2026.
>
> Fonte auxiliar: https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/software-architect

---

## 1. Base Tecnica Solida

### 1.1 Engenharia de Software

- [ ] Estruturas de dados e algoritmos suficientes para avaliar complexidade
- [ ] Programacao orientada a objetos e funcional
- [ ] Clean Code e refactoring
- [ ] Design patterns
- [ ] Testes automatizados
- [ ] Debugging e profiling
- [ ] Controle de versao e code review

### 1.2 Backend, Frontend e Dados

- [ ] APIs REST, GraphQL e gRPC
- [ ] Bancos relacionais e NoSQL
- [ ] Cache e mensageria
- [ ] Fundamentos de frontend e UX
- [ ] Seguranca de aplicacoes
- [ ] Observabilidade
- [ ] CI/CD e release management

---

## 2. Arquitetura de Software

- [ ] Layered architecture
- [ ] Hexagonal / Ports and Adapters
- [ ] Clean Architecture
- [ ] Modular monolith
- [ ] Microservices
- [ ] Event-driven architecture
- [ ] Serverless architecture
- [ ] Multi-tenant architecture
- [ ] Distributed systems fundamentals

---

## 3. Modelagem e Design

- [ ] Domain-driven design
- [ ] Bounded contexts
- [ ] Ubiquitous language
- [ ] Aggregates, entities e value objects
- [ ] Context maps
- [ ] C4 Model
- [ ] UML suficiente para comunicacao
- [ ] Event storming
- [ ] Data flow diagrams

---

## 4. Decisoes Arquiteturais

- [ ] Escrever ADRs
- [ ] Registrar contexto, decisao e consequencias
- [ ] Comparar alternativas explicitamente
- [ ] Avaliar custo de mudanca
- [ ] Gerenciar technical debt
- [ ] Definir standards de engenharia
- [ ] Criar guardrails em vez de microgerenciar times

---

## 5. Qualidades Arquiteturais

- [ ] Performance
- [ ] Scalability
- [ ] Availability
- [ ] Reliability
- [ ] Security
- [ ] Maintainability
- [ ] Testability
- [ ] Operability
- [ ] Accessibility quando houver produto com UI
- [ ] Cost efficiency

---

## 6. Sistemas Distribuidos

- [ ] CAP theorem
- [ ] Consistencia eventual
- [ ] Consensus basico
- [ ] Idempotencia
- [ ] Retries, timeouts e circuit breakers
- [ ] Sagas
- [ ] Outbox pattern
- [ ] Distributed tracing
- [ ] Data ownership por servico

---

## 7. Cloud & Infraestrutura

- [ ] Containers e Docker
- [ ] Kubernetes como conhecimento de escala
- [ ] Serverless
- [ ] Networking cloud
- [ ] IAM e secrets
- [ ] Storage gerenciado
- [ ] Databases gerenciados
- [ ] Terraform/OpenTofu
- [ ] FinOps basico

---

## 8. Seguranca e Compliance

- [ ] Threat modeling
- [ ] Secure SDLC
- [ ] OWASP Top 10
- [ ] Least privilege
- [ ] Data classification
- [ ] Privacy by design
- [ ] Audit trails
- [ ] Incident response
- [ ] Compliance aplicavel ao dominio

---

## 9. Lideranca Tecnica

- [ ] Facilitar decisoes entre times
- [ ] Traduzir trade-offs para negocio
- [ ] Mentorar engenheiros
- [ ] Conduzir design reviews
- [ ] Construir consenso sem perder rigor
- [ ] Definir roadmaps tecnicos
- [ ] Negociar escopo e risco
- [ ] Comunicar por documentos claros

---

## 10. Governanca e Plataforma

- [ ] Golden paths
- [ ] Templates de servicos
- [ ] Standards de APIs
- [ ] Standards de observabilidade
- [ ] Catalogo de servicos
- [ ] Architecture review leve
- [ ] Scorecards tecnicos
- [ ] Politicas automatizadas em CI/CD

---

## 11. Entregaveis de Arquiteto

- [ ] ADRs versionados
- [ ] Diagramas C4
- [ ] Documento de trade-offs
- [ ] Threat model
- [ ] Plano de migracao
- [ ] Roadmap tecnico
- [ ] Runbooks e SLOs
- [ ] Provas de conceito para decisoes arriscadas

---

## Stack Recomendada para 2026

| Area | Ferramenta/Pratica |
| ---- | ------------------ |
| Documentacao | Markdown + ADRs |
| Diagramas | C4 Model + Mermaid |
| APIs | OpenAPI + AsyncAPI |
| Decisoes | RFCs leves |
| Observabilidade | OpenTelemetry |
| Plataforma | Docker + IaC |
| Governanca | CI policies + scorecards |
| Design reviews | Checklist por qualidade arquitetural |

---

## Fontes de pesquisa

- [roadmap.sh — Software Architect](https://roadmap.sh/software-architect) — estrutura principal do percurso.
- [Repositório oficial developer-roadmap — Software Architect](https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/software-architect) — tópicos e histórico da fonte.
- [C4 Model](https://c4model.com/) — modelo de comunicação visual da arquitetura.
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/) — observabilidade interoperável.
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html) — contratos públicos de APIs.
- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/) — requisitos arquiteturais e verificáveis de segurança.

---

*Ultima atualizacao: Julho 2026*
