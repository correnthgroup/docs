# Forward Deployed Engineer Roadmap — referência enriquecida

- Categoria: role-based
- Fonte-base: [roadmap.sh — Forward Deployed Engineer](https://roadmap.sh/forward-deployed-engineer)
- Revisado em: 2026-07-15
- Autoridade: material de referência; não substitui PRD, direção operacional ou contratos Correnth

## Objetivo da função

O Forward Deployed Engineer (FDE) trabalha na interseção entre engenharia, implantação e problema do cliente. Assume discovery técnico, scoping, desenho, implementação, rollout e adoção de uma solução real, levando aprendizados de campo de volta ao produto e à plataforma.

## Mapa dos tópicos principais

### 1. Fundamentos da função

- diferenças entre FDE, Solutions Architect, Sales Engineer, Consultant e Product Engineer;
- ownership ponta a ponta, do problema à produção;
- proximidade com domínio e equipe do cliente;
- execução em ambiente ambíguo e com restrições reais;
- equilíbrio entre solução específica e capacidade reutilizável do produto;
- sucesso medido por adoção e impacto no workflow, não apenas deploy.

### 2. Discovery e entendimento do domínio

- entrevistas com operadores, gestores e equipes técnicas;
- mapeamento do processo atual, dados, sistemas e handoffs;
- identificação de dor, causa, frequência, impacto e workaround;
- requisitos funcionais e não funcionais;
- constraints legais, de segurança, infraestrutura e prazo;
- definição de baseline e outcome mensurável;
- documentação de assumptions e perguntas abertas.

### 3. Scoping e desenho da solução

- problem statement e critérios de sucesso;
- protótipo versus piloto versus produção;
- decomposição em milestones e thin slices;
- arquitetura e fluxos de dados;
- build, buy, configure ou integrate;
- trade-offs entre escopo, velocidade, qualidade e manutenção;
- riscos, dependências, fallback e plano de rollout;
- alinhamento explícito sobre fora de escopo.

### 4. Base de engenharia de software

- pelo menos uma stack full-stack de produção;
- APIs, background jobs, queues e event-driven systems;
- modelagem de dados, SQL e migrations;
- autenticação, autorização e multi-tenancy;
- testes unitários, integração, contrato e E2E;
- Git, code review, CI/CD e observabilidade;
- profiling, debugging e incident response;
- código legível que a equipe central possa manter.

### 5. Integrações e dados do cliente

- REST, GraphQL, gRPC, webhooks, polling e file exchange;
- OAuth, API keys, service accounts e secret rotation;
- schemas, validação, idempotência e retries;
- ETL/ELT, qualidade de dados e reconciliação;
- sistemas legados e formatos inconsistentes;
- rate limits, timeouts, partial failures e backpressure;
- lineage, auditabilidade e proteção de PII;
- contratos e testes com sistemas externos.

### 6. Sistemas com IA

- seleção de modelo por qualidade, custo, latência e restrições;
- prompting, structured outputs e tool use;
- retrieval, embeddings, RAG e memória quando necessários;
- datasets de avaliação ligados ao workflow;
- human-in-the-loop para ações críticas;
- prompt injection, excessive agency e data leakage;
- tracing de chamadas, ferramentas, custos e resultados;
- fallback determinístico e modo degradado.

### 7. Segurança, governança e compliance

- threat modeling;
- least privilege e separation of duties;
- isolamento entre organizações/tenants;
- data classification, retention e deletion;
- encryption in transit/at rest;
- audit logs e evidências de mudança;
- revisão de fornecedores e dependências;
- requisitos regulatórios do domínio;
- aprovação antes de ações irreversíveis.

### 8. Deploy e operação

- ambientes local, development, staging e production;
- IaC, containers e cloud fundamentals;
- feature flags e rollout gradual;
- migrations reversíveis e compatíveis;
- observabilidade com logs, métricas e traces;
- SLOs e alertas orientados a impacto;
- runbooks, on-call, rollback e disaster recovery;
- handover sem abandonar ownership prematuramente.

### 9. Comunicação e gestão de stakeholders

- comunicação técnica e executiva;
- demos ligadas a outcome, não apenas funcionalidades;
- registro de decisões, riscos e mudanças de escopo;
- negociação de prioridades e prazos;
- status reporting conciso;
- facilitação entre cliente, Produto, Engenharia, Segurança e GTM;
- gestão de expectativa sem mascarar incerteza.

### 10. Adoção e mudança operacional

- onboarding e enablement dos usuários;
- documentação, treinamento e suporte;
- champion interno e ownership no cliente;
- telemetria de adoção e workflow impact;
- feedback loops e entrevistas pós-rollout;
- rollout por cohort e expansão progressiva;
- plano para resistência, exceções e processos paralelos;
- critérios de conclusão e transição para operação estável.

### 11. Productização dos aprendizados

- separar configuração reutilizável de customização isolada;
- transformar padrões recorrentes em primitives, templates e playbooks;
- reportar lacunas de produto com evidências;
- contribuir com APIs, SDKs, docs e ferramentas internas;
- evitar forks permanentes por cliente;
- medir frequência e impacto antes de generalizar;
- manter feedback de campo rastreável até roadmap de Produto.

## Progressão sugerida

1. **Base técnica:** full-stack, APIs, dados, cloud e debugging.
2. **Cliente:** discovery, scoping, comunicação e domínio.
3. **Entrega:** arquitetura, implementação, rollout e operação.
4. **Impacto:** adoção, métricas e gestão de mudança.
5. **Escala:** productização, playbooks e feedback para plataforma.

## Evidências práticas de domínio

- mapear workflow real e identificar baseline/target;
- escrever technical scope com riscos, milestones e fora de escopo;
- integrar dois sistemas com auth, idempotência e observabilidade;
- entregar piloto com dataset de avaliação e plano de rollout;
- conduzir deploy acompanhado e rollback simulado;
- criar runbook e treinar equipe operadora;
- demonstrar adoção e impacto mensurável;
- converter aprendizado específico em componente ou playbook reutilizável.

## Fontes complementares

- [OpenAI — Forward Deployed Engineer](https://openai.com/careers/forward-deployed-engineer-seoul-seoul-south-korea/): ownership de discovery, scoping, system design, build, rollout, adoção e feedback ao produto.
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html): contratos interoperáveis para integrações HTTP.
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/): observabilidade agnóstica para sistemas distribuídos e integrações.
- [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/): requisitos verificáveis de segurança de aplicações.
- [DORA — software delivery performance metrics](https://dora.dev/guides/dora-metrics/): medição de fluxo e estabilidade da entrega.

## Como manter este arquivo

Revisar semestralmente. Como o roadmap oficial é recente e interativo, enriquecer este documento apenas com práticas sustentadas por experiência operacional e fontes primárias.
