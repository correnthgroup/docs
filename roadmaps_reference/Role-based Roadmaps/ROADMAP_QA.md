# QA Engineer Roadmap — referência enriquecida

- Categoria: role-based
- Fonte-base: [roadmap.sh — QA Engineer](https://roadmap.sh/qa)
- Mapa oficial: [PDF do roadmap](https://roadmap.sh/pdfs/roadmaps/qa.pdf)
- Revisado em: 2026-07-15
- Autoridade: material de referência; não substitui PRD, direção operacional ou contratos Correnth

## Objetivo da função

Quality Assurance organiza prevenção, detecção e aprendizado sobre falhas ao longo de todo o ciclo de produto. QA não é somente executar testes ao final: participa do refinamento, define riscos e oráculos, melhora testabilidade, automatiza verificações úteis e ajuda a equipe a entregar com confiança.

## Mapa dos tópicos principais

### 1. Fundamentos de qualidade e teste

- diferença entre quality assurance, quality control e testing;
- princípios de teste e QA mindset;
- test basis, test conditions, test cases e test data;
- test oracles e critérios objetivos de resultado;
- verificação versus validação;
- risco de produto e priorização de testes;
- defeito, erro, falha, causa raiz e severidade.

### 2. Ciclo de desenvolvimento e abordagens

- SDLC: iterativo, incremental, Agile, V-model e waterfall;
- Scrum, Kanban, XP e práticas DevOps;
- shift-left e shift-right;
- testes estáticos: revisão de requisitos, design e código;
- testes dinâmicos em diferentes níveis;
- colaboração entre Produto, Design, Engenharia, QA e Operações.

### 3. Técnicas de teste

- black-box, white-box e experience-based;
- particionamento de equivalência e análise de valor-limite;
- decision tables e state transition testing;
- pairwise/combinatorial testing;
- exploratory testing e session-based testing;
- error guessing e checklist-based testing;
- testes positivos, negativos e de abuso.

### 4. Níveis e tipos de teste

- unitários, componente, integração, sistema e aceitação;
- functional, regression, smoke e sanity;
- UAT e validação de regras de negócio;
- compatibilidade entre browsers, dispositivos e ambientes;
- acessibilidade;
- segurança;
- performance, carga, stress, soak e capacity;
- resiliência, recuperação e disaster scenarios.

### 5. Planejamento e gestão

- estratégia e plano de testes orientados a risco;
- escopo, prioridades, ambientes, dados e dependências;
- critérios de entrada, saída e suspensão;
- estimativas e capacidade;
- rastreabilidade entre requisitos, riscos e evidências;
- triagem de defeitos;
- relatórios concisos sobre qualidade e risco residual;
- ferramentas de test management como exemplos, não como competência central.

### 6. Fundamentos web e APIs

- HTML, CSS e JavaScript suficientes para investigar interfaces;
- HTTP, status codes, headers, cookies, cache e CORS;
- REST, JSON, autenticação e autorização;
- browser DevTools e inspeção de rede;
- client-side versus server-side rendering;
- testes de contratos, schemas, idempotência, paginação e rate limit;
- webhooks, filas e consistência eventual.

### 7. Automação de frontend e E2E

- pirâmide/troféu de testes e escolha do nível correto;
- seletores estáveis e acessíveis;
- isolamento, fixtures e dados determinísticos;
- Page Objects apenas quando reduzirem duplicação real;
- Playwright, Cypress, Selenium/WebDriver ou equivalente;
- paralelismo, retries controlados, screenshots, vídeo e traces;
- prevenção e diagnóstico de flaky tests;
- evitar E2E para lógica coberta de forma mais barata em níveis inferiores.

### 8. Backend, contrato e integração

- API testing manual e automatizado;
- Postman/Newman, REST Assured, Karate ou bibliotecas da stack;
- contract testing entre consumers e providers;
- test doubles, mocks, stubs, fakes e serviços virtuais;
- banco de dados, migrations e integridade;
- filas, jobs, eventos e timeouts;
- testes cross-tenant, RBAC/RLS e isolamento de dados.

### 9. Não funcional

- performance com k6, JMeter, Gatling, Locust ou equivalente;
- accessibility testing automatizado e manual conforme WCAG;
- segurança baseada em threat model e OWASP;
- compatibilidade e internacionalização;
- confiabilidade, observabilidade e comportamento degradado;
- privacy e proteção de dados de teste.

### 10. CI/CD, observabilidade e reporting

- Git e revisão de mudanças de teste;
- quality gates no pipeline;
- execução seletiva, paralela e por camadas;
- relatórios JUnit/HTML e evidências reproduzíveis;
- logs, métricas, traces e correlação de falhas;
- Sentry, OpenTelemetry, Grafana ou equivalentes;
- quarentena de flaky tests com owner e prazo, nunca ocultação permanente.

### 11. Testes de sistemas com IA

- datasets representativos e versionados;
- outputs estruturados e assertions determinísticas quando possível;
- avaliação de relevância, groundedness, segurança e consistência;
- testes de prompt injection, tool misuse e excessive agency;
- comparação de modelos e prompts por custo, latência e qualidade;
- HITL para ações críticas;
- replay de traces e regressão sobre casos reais anonimizados.

## Progressão sugerida

1. **Base:** princípios, SDLC, técnicas manuais e reporte.
2. **Web/API:** HTTP, DevTools, banco e contratos.
3. **Automação:** unit/integration/E2E e CI.
4. **Qualidade sistêmica:** performance, segurança, acessibilidade e observabilidade.
5. **Estratégia:** risco, arquitetura de testes, métricas e qualidade de IA.

## Evidências práticas de domínio

- criar estratégia de testes ligada a riscos do produto;
- escrever casos por equivalência, limites, estados e decisões;
- automatizar um fluxo crítico em Playwright com trace e dados isolados;
- testar API, autorização e isolamento cross-tenant;
- executar teste de carga com baseline e thresholds;
- auditar WCAG 2.2 combinando automação e inspeção manual;
- integrar testes em CI e diagnosticar um caso flaky;
- produzir relatório de risco residual que apoie decisão de release.

## Fontes complementares

- [ISTQB CTFL Syllabus v4.0.1](https://istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf): fundamentos, processo, técnicas e gestão de testes.
- [W3C — WCAG 2 Overview](https://www.w3.org/WAI/standards-guidelines/wcag/): padrão de acessibilidade e critérios de conformidade.
- [Playwright Documentation](https://playwright.dev/docs/intro): automação web, isolamento, traces e execução em CI.
- [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/): metodologia de testes de segurança web.
- [roadmap.sh — QA PDF](https://roadmap.sh/pdfs/roadmaps/qa.pdf): mapa principal de fundamentos, técnicas, automação, não funcional, CI/CD e observabilidade.

## Como manter este arquivo

Revisar semestralmente. Ferramentas podem mudar; técnicas, riscos, evidências e critérios devem permanecer independentes de fornecedor.
