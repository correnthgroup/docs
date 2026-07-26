# DevOps / SRE Roadmap — referência enriquecida

- Categoria: role-based
- Fonte-base: [roadmap.sh — DevOps](https://roadmap.sh/devops)
- Mapa oficial: [PDF do roadmap](https://roadmap.sh/pdfs/roadmaps/devops.pdf)
- Revisado em: 2026-07-15
- Autoridade: material de referência; não substitui PRD, direção operacional ou contratos Correnth

## Objetivo da função

DevOps é uma abordagem sociotécnica para reduzir o tempo entre mudança e valor em produção, mantendo segurança e confiabilidade. A função de DevOps/SRE cria automação, plataformas e práticas que tornam build, teste, deploy, operação e recuperação repetíveis.

## Mapa dos tópicos principais

### 1. Fundamentos e mentalidade

- colaboração entre desenvolvimento, QA, segurança e operações;
- fluxo, feedback e melhoria contínua;
- automação com ownership claro;
- sistemas como código;
- redução de toil;
- blameless learning e post-mortems;
- segurança e confiabilidade como responsabilidades compartilhadas.

### 2. Linguagem e scripting

- escolher ao menos uma linguagem: Python, Go, JavaScript/TypeScript, Ruby ou equivalente;
- Bash e PowerShell para automação operacional;
- manipulação de arquivos, processos, streams e exit codes;
- APIs, JSON/YAML, templating e validação;
- scripts idempotentes, observáveis e testáveis;
- tratamento de erro, retry, timeout e rollback.

### 3. Sistemas operacionais

- Linux e terminal;
- processos, sinais, serviços e systemd;
- usuários, grupos, permissões e sudo;
- filesystem, mounts, storage e capacity;
- logs do sistema;
- performance: CPU, memória, disco e I/O;
- troubleshooting com ferramentas nativas;
- noções de Windows quando o ambiente exigir.

### 4. Rede e protocolos

- TCP/IP, OSI, subnets, routing e NAT;
- DNS, HTTP/HTTPS, TLS e certificados;
- SSH, proxies, firewalls e load balancers;
- SMTP e fundamentos de entrega de e-mail;
- troubleshooting com curl, dig/nslookup, ping, traceroute, ss/netstat e packet capture;
- service discovery e health checks.

### 5. Versionamento e colaboração

- Git, branches, tags e estratégias de integração;
- pull requests e code review;
- conventional commits somente quando houver benefício operacional;
- proteção de branches e required checks;
- assinatura, provenance e histórico auditável;
- GitHub, GitLab ou outro forge.

### 6. Build, artifacts e CI/CD

- pipeline como código;
- build reproduzível e cache;
- testes, lint, SAST, dependency scanning e SBOM;
- artifact registries e versionamento imutável;
- secrets no pipeline;
- promoção entre ambientes;
- blue-green, canary, rolling, feature flags e rollback;
- GitHub Actions, GitLab CI, Jenkins ou equivalente.

### 7. Containers e orquestração

- imagens, layers, registries e Dockerfile;
- non-root, minimal images e scanning;
- volumes, networks e resource limits;
- Docker Compose para ambientes locais;
- Kubernetes: pods, deployments, services, ingress, config, secrets e policies;
- autoscaling, probes, requests/limits e disruption budgets;
- alternativas gerenciadas ou serverless quando reduzirem complexidade.

### 8. Cloud e infraestrutura como código

- fundamentos de AWS, Azure, GCP ou provedor escolhido;
- identidade, rede, compute, storage e managed databases;
- Terraform/OpenTofu, Pulumi, CDK ou ferramentas nativas;
- state, locking, modules, drift e policy as code;
- ambientes reprodutíveis;
- least privilege e separação de contas/projetos;
- custo, quotas, backups e lifecycle.

### 9. Configuration e secrets management

- Ansible ou alternativa para configuração;
- Vault, SOPS, sealed secrets ou secret manager do provedor;
- rotação e revogação;
- nenhuma credencial em repositório ou imagem;
- separação entre config e secret;
- auditoria de acessos.

### 10. Observabilidade

- métricas, logs e traces como sinais complementares;
- OpenTelemetry para instrumentação agnóstica;
- SLIs, SLOs e error budgets;
- alertas acionáveis baseados em sintomas;
- dashboards orientados a decisão;
- correlação por request/run/trace ID;
- Prometheus, Grafana, Loki, Elastic, Jaeger ou serviços gerenciados;
- retenção, custo e proteção de dados sensíveis em telemetria.

### 11. Confiabilidade e incidentes

- on-call sustentável;
- classificação e declaração de incidentes;
- Incident Command System;
- runbooks, playbooks e comunicação fora de banda;
- backup, restore testado, RPO e RTO;
- disaster recovery e business continuity;
- chaos/resilience testing proporcional ao risco;
- post-mortem com ações acompanhadas.

### 12. Segurança e supply chain

- threat modeling e hardening;
- IAM e least privilege;
- network segmentation e zero trust quando justificável;
- SAST, DAST, SCA, container e IaC scanning;
- SBOM, assinatura de artifacts e provenance;
- patching e vulnerability management;
- políticas, auditoria e resposta a incidentes de segurança.

### 13. Métricas de fluxo e operação

- deployment frequency;
- change lead time;
- failed deployment recovery time;
- change fail rate;
- deployment rework rate;
- disponibilidade, latência, saturação e erros;
- custo por serviço/ambiente;
- toil e experiência do desenvolvedor.

## Progressão sugerida

1. **Base:** Linux, scripting, Git, rede e HTTP.
2. **Entrega:** CI/CD, containers e artifacts.
3. **Infraestrutura:** cloud, IaC, configuração e secrets.
4. **Operação:** observabilidade, SLOs, incidentes e recuperação.
5. **Plataforma:** self-service, segurança de supply chain e otimização sistêmica.

## Evidências práticas de domínio

- provisionar ambiente reproduzível por IaC;
- criar pipeline com build, testes, scan, artifact e deploy;
- containerizar serviço como non-root e com health checks;
- instrumentar métricas, logs e traces com OpenTelemetry;
- definir SLO e alerta baseado em impacto;
- executar restore real de backup;
- conduzir game day de incidente e produzir post-mortem;
- medir e melhorar ao menos uma métrica DORA sem gamificação.

## Fontes complementares

- [DORA — software delivery performance metrics](https://dora.dev/guides/dora-metrics/): métricas de entrega e estabilidade.
- [Google SRE — Managing Incidents](https://sre.google/sre-book/managing-incidents/): papéis, comando, comunicação e recuperação.
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/): instrumentação vendor-neutral para logs, métricas e traces.
- [CNCF Landscape](https://landscape.cncf.io/): catálogo de tecnologias cloud native; usar para descoberta, não como lista obrigatória.
- [roadmap.sh — DevOps PDF](https://roadmap.sh/pdfs/roadmaps/devops.pdf): mapa principal de OS, rede, cloud, IaC, CI/CD, containers, observabilidade e segurança.

## Como manter este arquivo

Revisar semestralmente. Priorizar padrões abertos e capacidades; ferramentas específicas devem permanecer alternativas substituíveis.
