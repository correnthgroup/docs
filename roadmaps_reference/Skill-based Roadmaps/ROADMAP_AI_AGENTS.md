# AI Agents Roadmap — referência enriquecida

- Categoria: skill-based
- Fonte-base: [roadmap.sh — AI Agents](https://roadmap.sh/ai-agents)
- Revisado em: 2026-07-15
- Autoridade: material de referência; não substitui PRD, direção operacional ou contratos Correnth

## Objetivo da trilha

Aprender a projetar, construir, avaliar, proteger e operar agentes de IA. Um agente é um modelo configurado com instruções, contexto e ferramentas, executando um loop de decisão até concluir, parar ou solicitar intervenção humana.

## Mapa dos tópicos principais

### 1. Pré-requisitos

- desenvolvimento backend;
- terminal, Git e ambientes isolados;
- HTTP, REST, JSON, streaming e webhooks;
- concorrência, filas e background jobs;
- banco de dados e modelagem básica;
- autenticação, autorização e gestão de secrets;
- testes, logging e debugging.

### 2. Fundamentos de LLMs

- transformers e geração autoregressiva em nível conceitual;
- tokens, tokenização, context window e limites;
- modelos de reasoning versus modelos gerais;
- open-weight versus closed-weight e licenças;
- temperature, top-p, penalties, stop e max output;
- streamed versus unstreamed responses;
- custo, latência, throughput e cache;
- fine-tuning versus prompting versus retrieval;
- embeddings, busca vetorial e RAG.

### 3. Instruções e contratos de saída

- system/developer/user instructions e precedência;
- delimitação clara de contexto não confiável;
- few-shot examples quando agregarem estabilidade;
- structured outputs com JSON Schema/Pydantic/Zod;
- validação, retry e recuperação de parse;
- versionamento de prompts e configurações;
- testes de regressão sobre mudanças de instrução;
- evitar depender de raciocínio oculto como evidência.

### 4. Agent loop

- entrada/percepção;
- interpretação, planejamento e seleção de ação;
- chamada de ferramenta;
- observação do resultado;
- atualização de estado e reflexão operacional;
- critérios de conclusão;
- limites de passos, tempo e custo;
- detecção de loop e ausência de progresso;
- cancelamento e retomada segura.

### 5. Tools e actions

- function calling e schemas estritos;
- descrição precisa, inputs mínimos e outputs estruturados;
- ferramentas de leitura versus escrita;
- timeouts, retries, idempotência e circuit breakers;
- least privilege e capability-based access;
- sandbox para shell, código, filesystem e browser;
- approval gates para ações sensíveis;
- tratamento de erro compreensível pelo modelo;
- auditoria de cada chamada e resultado.

### 6. Model Context Protocol (MCP)

- hosts, clients, servers, tools, resources e prompts;
- transportes e lifecycle;
- discovery e schemas;
- autenticação e autorização;
- trust boundaries e servidores não confiáveis;
- composição de múltiplos MCPs sem expor ferramentas excessivas;
- versionamento e compatibilidade;
- logs e telemetria sem vazamento de secrets.

### 7. Contexto, RAG e memória

- contexto de execução versus memória persistente;
- seleção e compressão de contexto;
- chunking, embeddings, hybrid search e reranking;
- citações e provenance;
- short-term, episodic, semantic e procedural memory;
- isolamento por usuário, organização, produto e tarefa;
- freshness, versionamento e invalidação;
- prevenção de context poisoning;
- Context Packs compactos e imutáveis quando aplicável.

### 8. Arquiteturas de agentes

- agente único com tools;
- deterministic workflow com etapas fixas;
- ReAct;
- router/classifier;
- planner-executor;
- evaluator-optimizer;
- parallelization e fan-out/fan-in;
- manager com agentes como tools;
- handoffs entre especialistas;
- escolha do padrão mais simples que satisfaça o problema.

### 9. Sistemas multiagente

- definição de papéis e ownership;
- supervisor-worker e peer collaboration;
- handoff contract e estado compartilhado mínimo;
- prevenção de delegação circular;
- concorrência, filas e prioridades;
- isolamento de contexto e credenciais;
- resolução de conflito e síntese;
- orçamento por agente/run;
- rastreabilidade da contribuição de cada agente.

### 10. Avaliação

- objetivo e critérios de sucesso antes do agente;
- datasets representativos e versionados;
- assertions determinísticas para tool use e outputs estruturados;
- task completion, accuracy, groundedness e citation quality;
- custo, latência, passos e taxa de intervenção;
- model-graded evals calibradas com revisão humana;
- adversarial e edge cases;
- regressão contínua em CI;
- comparação de configurações por experimento reproduzível.

### 11. Observabilidade

- traces de runs, turns, tools, handoffs e approvals;
- correlação por run ID;
- inputs/outputs com redaction;
- token usage, custo e cache;
- tempo por etapa e bottlenecks;
- classificação de falhas;
- replay e debugging;
- dashboards e alertas;
- retenção e controle de acesso à telemetria.

### 12. Segurança e governança

- prompt injection direta e indireta;
- insecure output handling;
- excessive agency;
- tool poisoning e supply chain;
- data exfiltration e vazamento entre tenants;
- sandbox escape e execução arbitrária;
- autenticação, autorização e secret isolation;
- allowlists, policy enforcement e approvals;
- red teaming e abuse testing;
- transparência, privacidade e controle humano.

### 13. Human-in-the-loop

- aprovação antes de escrita externa, gasto ou ação irreversível;
- escalonamento por baixa confiança, conflito ou falta de permissão;
- estados pausáveis e retomáveis;
- resumo claro do que será feito e por quê;
- timeout, rejeição e caminho alternativo;
- registro do aprovador e da evidência;
- políticas distintas por ferramenta e risco.

### 14. Produção e operação

- API e workers assíncronos;
- filas, retries, idempotência e dead-letter queues;
- persistência de estado e retomada;
- containers, CI/CD e environments;
- model/provider routing e fallback testado;
- quotas, budget e rate limits;
- feature flags, canary e rollback;
- SLOs, incident response e modo degradado;
- retenção de logs e proteção de dados.

## Progressão sugerida

1. **Fundamentos:** backend, LLMs, prompts e structured outputs.
2. **Agente único:** loop, tools, stop rules e traces.
3. **Contexto:** MCP, RAG, memória e citações.
4. **Sistemas:** padrões, multiagente, evals e observabilidade.
5. **Produção:** segurança, HITL, filas, custos e incidentes.

## Evidências práticas de domínio

- construir agente único com duas tools tipadas e stop rule;
- implementar approval gate para ação de escrita;
- conectar um MCP com escopo mínimo;
- criar retrieval híbrido com citações e teste de autorização;
- comparar deterministic workflow, router e manager pattern;
- executar eval suite com casos normais e adversariais;
- rastrear custo, latência, ferramentas e handoffs;
- demonstrar recuperação de timeout, provider failure e loop;
- publicar runbook e threat model do agente.

## Fontes complementares

- [OpenAI Agents SDK — Agents](https://openai.github.io/openai-agents-python/agents/): instruções, tools, guardrails, handoffs, contexto e outputs estruturados.
- [OpenAI Agents SDK — Tools](https://openai.github.io/openai-agents-python/tools/): function tools, agentes como tools, approvals e execução local.
- [OpenAI Agents SDK — Examples](https://openai.github.io/openai-agents-python/examples/): workflows determinísticos, routing, parallel execution, guardrails e HITL.
- [Model Context Protocol — Specification](https://modelcontextprotocol.io/specification/): contratos e lifecycle do MCP.
- [Anthropic — Trustworthy agents in practice](https://www.anthropic.com/research/trustworthy-agents): autonomia, controle humano, segurança, transparência e privacidade.
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework): governança e gestão de riscos de IA.
- [OWASP GenAI Security Project](https://genai.owasp.org/): riscos e práticas de segurança para LLMs e sistemas agênticos.

## Como manter este arquivo

Revisar trimestralmente, pois APIs e frameworks mudam rapidamente. Preservar conceitos, contratos, testes e fronteiras de segurança; tratar frameworks como implementações substituíveis.
