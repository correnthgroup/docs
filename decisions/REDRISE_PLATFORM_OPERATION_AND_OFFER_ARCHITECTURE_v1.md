# RedRise Platform, Operation and Offer Architecture v1

- Status: Vigente
- Data: 2026-07-28
- Owner: Grupo Correnth
- Escopo: definição, fronteira plataforma/operação, absorção de capacidades Gauss, famílias de oferta e entrada comercial
- Complementa: `REDRISE_CANONICAL_PRODUCT_AND_INTERNAL_COMPANY_v1.md`

## Decisão

RedRise é a plataforma e operação agêntica B2B da Correnth. Ela diagnostica processos, constrói o software necessário, implementa automações e opera fluxos digitais com governança, evidência e controle humano nos pontos críticos.

Existem duas dimensões complementares:

| Dimensão | Responsabilidade | Repositório |
|---|---|---|
| Platform | software usado por clientes e pela companhia interna: tenants, agentes, projetos, Work Orders, integrações, execução, aprovações, custos e observabilidade | `correnthgroup/redrise-platform` |
| Operation | organização que entrega discovery, desenvolvimento, automação, QA, implantação, operação assistida, melhoria contínua, treinamento e handover | `correnthgroup/redrise-operation` |

O pacote operacional não é uma segunda aplicação nem um tenant de cliente. A plataforma permanece o único runtime implantável.

## Absorção da antiga Gauss

Gauss não é unidade comercial ativa. A identidade, os paths e os repositórios Gauss permanecem históricos; as capacidades úteis de desenvolvimento e delivery são absorvidas pela RedRise, principalmente em `RedRise Build`.

Nenhum documento ativo deve recriar Gauss como empresa, software house ou autoridade operacional.

## Famílias de capacidade

- `RedRise Automate`: integração e automação de processos existentes.
- `RedRise Build`: aplicações, portais, SaaS, modernização, módulos e interfaces agênticas.
- `RedRise Operate`: monitoramento, SLOs, manutenção, custos, incidentes e melhoria contínua.
- `RedRise Assurance`: QA independente, avaliação de agentes, segurança, testes, evidências, risco e readiness.

As famílias não substituem as fases `Discovery → Build → Operate`. Uma oferta pode atravessar as três fases; Assurance pode ser isolada ou transversal.

## Porta de entrada

A capacidade interna é ampla, mas a oferta inicial é específica:

### RedRise Workflow Pilot

Em um projeto delimitado, a RedRise analisa um processo B2B, implementa sua automação, integra os sistemas necessários e mede o resultado, mantendo aprovação humana para ações críticas.

Expansões para Build, Operate, Assurance ou licença da plataforma dependem de evidência produzida pelo piloto; não são contratação obrigatória.

## Receita

| Fonte | Modelo |
|---|---|
| Discovery | projeto fechado |
| Build / Automate | projeto ou milestones |
| Operate | mensalidade, capacidade reservada ou consumo |
| Platform | assinatura e/ou consumo |

## Validação e fronteiras

- RedRose, Findfee e ADGency são clientes internos possíveis, com contratos explícitos, dados e backlog próprios.
- RedRise fornece plataforma e operação agêntica sem transformar essas unidades em módulos.
- A mensagem externa é “automação agêntica com supervisão humana proporcional ao risco”; “zero humans” não é promessa comercial.
- `Account Owner` e `Responsible Executive / Human Board` permanecem funções humanas responsáveis por relacionamento, contratos, preço, produção, credenciais, risco e exceções.
- O ICP inicial são PMEs B2B com processo repetitivo, mensurável e de risco baixo ou médio.

## Posicionamento autorizado

Principal:

> RedRise transforma processos B2B em operações digitais inteligentes. Diagnosticamos o processo, construímos o software necessário, automatizamos a execução e mantemos controle humano nas decisões críticas.

Curto:

> Construa, automatize e opere processos B2B com agentes de IA.

Conservador:

> Automação e desenvolvimento B2B com rastreabilidade, revisão independente e aprovação humana baseada em risco.
