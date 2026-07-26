# Correnth Ecosystem Portfolio and Operating Model v1

- Status: Vigente
- Data: 2026-07-14
- Owner: Grupo Correnth
- Escopo: portfólio, fronteiras de produto e modelo operacional

## 1. Estrutura do grupo

O Grupo Correnth é a matriz do ecossistema. O site institucional `www.correnth.com` apresenta o grupo e direciona para os produtos e negócios. Cada unidade tem escopo, identidade, backlog, operação e equipe próprios, sem perder a governança compartilhada da Correnth.

```text
Grupo Correnth
├── Correnth.com — institucional e ponto de entrada
├── Produtos
│   ├── RedRose — ERP Agêntico
│   ├── RedRise — automação B2B com IA
│   └── Findfee — CRM
└── Negócios
    ├── ADGency — agência de marketing no-human
    └── Gauss — desenvolvimento de software
```

## 2. Portfólio

| Unidade | Tipo | Proposta definida |
|---|---|---|
| Correnth.com | Institucional | Apresentar o Grupo Correnth e direcionar para suas unidades. |
| RedRose | Produto | ERP Agêntico. |
| RedRise | Produto | Automação B2B com IA. |
| Findfee | Produto | CRM. |
| ADGency | Negócio | Agência de marketing no-human. |
| Gauss | Negócio | Desenvolvimento de software. |

## 3. Fronteiras obrigatórias

- RedRose e RedRise são produtos distintos, com problemas, posicionamento, dados, backlog e evolução próprios.
- RedRose é o ERP Agêntico do portfólio.
- RedRise mantém como escopo a automação B2B com IA.
- Findfee permanece dedicado ao domínio de CRM.
- ADGency e Gauss são negócios operacionais, não submódulos dos produtos.
- Cada unidade pode consumir fundações compartilhadas somente por contratos explícitos e versionados.

## 4. Estratégia de adoção

> Estratégia: uso interno primeiro, depois escalar conforme adoção e rentabilidade.

Cada unidade deve validar o próprio fluxo internamente antes de ampliar oferta, integrações, planos ou operação externa. A prioridade de construção não é a ordem do portfólio: ela é definida pelo que desbloqueia desenvolvimento, teste, deploy, operação, aprendizagem e rentabilidade das demais unidades.

Critérios para priorização:

1. desbloqueio técnico ou operacional de outras unidades;
2. redução de trabalho manual e risco;
3. possibilidade de uso interno imediato;
4. clareza de problema e validação de adoção;
5. custo, manutenção e retorno esperado.

## 5. Operação com agentes

A Correnth utilizará Paperclip para orquestrar agentes em operações internas e em partes autorizadas dos negócios.

```text
Objetivo humano
→ Paperclip organiza e acompanha o trabalho de agentes
→ agentes executam tarefas com contexto e ferramentas autorizadas
→ revisão, aprovação e publicação quando exigidas
```

O objetivo é operar fluxos **zero humans** sempre que forem reversíveis, observáveis e previamente autorizados. Interações humanas permanecem obrigatórias em gates HITL (human-in-the-loop), incluindo pelo menos:

- mudança irreversível ou destrutiva;
- acesso, credencial, segurança ou isolamento de dados;
- gasto, contratação, cobrança ou compromisso financeiro;
- publicação externa relevante;
- mudança de contrato, política ou escopo de produto;
- exceção operacional que ultrapasse limites pré-aprovados.

Paperclip é ferramenta de orquestração operacional; não substitui as fronteiras de domínio de cada produto nem se torna a autoridade de memória, dados ou decisões de produto.

### Organização vigente da Gauss

| Nome visual | Título oficial em pt-BR | Reporta a |
|---|---|---|
| CEO | Direção Executiva | Board humano |
| CPO | Liderança de Produto | CEO |
| PMO | Operações e Análise de Produto | CPO |
| CTO | Gerência de Engenharia | CEO |
| Sênior Full-Stack Dev | Desenvolvimento Full-Stack | CTO |
| QA | Revisão de Qualidade e Risco | CEO |

Os slugs técnicos permanecem no pacote `correnthgroup/labs_gauss`; os nomes e títulos acima são a identidade organizacional vigente no Paperclip. O idioma oficial dos textos operacionais e resultados gerados é pt-BR. A interface nativa do Paperclip, seus botões, menus, estados e enums não são traduzidos pela Correnth. A documentação Markdown interna de cada agente pode conter termos em inglês quando necessários ao runtime.

## 6. Contexto e memória compartilhados

A Shared Context Memory Platform (CML) é uma fundação transversal do grupo. Produtos, negócios e agentes autorizados a consomem por API, SDK ou MCP versionados, com isolamento por organização, produto, ambiente, visibilidade e capability.

Context Packs podem incluir documentos, decisões, contratos, código, resultados de execução e artefatos semânticos gerados pelo Graphify — por exemplo, `graph.json`, `GRAPH_REPORT.md` ou subgrafos consultados — desde que origem, versão, autorização e citações estejam registrados.

A ordem normativa para conflitos é:

```text
PRD vigente
→ direção operacional
→ contratos públicos
→ migrations
→ código e testes
```

## 7. Princípios de construção

- Projetos isolados por produto, com dados, configurações e regras de negócio próprios.
- Reuso visual exclusivamente via pacote local `@correnth/ui`.
- Serviços compartilhados devem ter contrato, controle de acesso e observabilidade explícitos.
- Paperclip coordena agentes; produtos mantêm responsabilidade sobre seus próprios domínios.
- Todo trabalho relevante deve ter contexto rastreável, critérios de aceite e registro de decisão.
- Evolução incremental é permitida; desvio de escopo entre unidades não é.

## 8. Decisões pendentes

- [DECIDIR] ordem de construção das unidades a partir de evidências de bloqueio, custo e uso interno;
- [DECIDIR] quais integrações e capacidades cada unidade poderá autorizar a agentes;
- [DECIDIR] modelo de custo, cobrança e planos de cada produto;
- [DECIDIR] limites operacionais que exigem HITL por unidade.
