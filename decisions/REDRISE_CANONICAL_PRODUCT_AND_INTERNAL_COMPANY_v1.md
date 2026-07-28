# RedRise Canonical Product and Internal Company v1

- Status: Vigente
- Data: 2026-07-24
- Owner: Grupo Correnth
- Escopo: identidade, repositórios, operação interna, isolamento e migração Gauss
- Supersede: `GAUSS_AGENT_ORGANIZATION_AND_LANGUAGE_v1.md` e as seções Gauss de `CORRENTH_ECOSYSTEM_PORTFOLIO_AND_OPERATING_MODEL_v1.md`

## Decisão

RedRise é a plataforma e operação agêntica B2B vigente da Correnth e também o nome da companhia operacional interna que a desenvolve e opera. Gauss deixa de ser uma unidade ativa; sua identidade de software house e venture studio permanece apenas como histórico, enquanto capacidades úteis de desenvolvimento, automação, QA e operação são absorvidas pela RedRise.

A arquitetura de posicionamento e ofertas é detalhada por `REDRISE_PLATFORM_OPERATION_AND_OFFER_ARCHITECTURE_v1.md`.

O runtime do produto é um fork mantido do Paperclip. A operação interna e o código implantável permanecem separados:

| Autoridade | Local |
|---|---|
| Aplicação, API, migrations, UI, adapters e deploy | `D:\01_studio\redrise-platform` |
| Agentes, skills e governança da companhia interna | `D:\02_labs\redrise-operation` |
| Descoberta de contexto compartilhado | Graphify semântico por projeto, com fontes versionadas em seus repositórios |
| Estratégia, PRDs e decisões | `D:\00_docs` |

Os repositórios históricos `archived\redrise` e `archived\redrise v2` são doadores somente leitura. Eles não podem voltar a ser runtime, fonte de migrations ou autoridade operacional.

## Companhia interna

A Company Paperclip existente é renomeada in-place para RedRise, preservando o UUID `133c48c0-e38e-4037-ae7e-0fb5cec20fb3`, relações e histórico. Agentes ativos, skills e identificadores canônicos usam `redrise-*`.

Issues históricas `COR-*` permanecem válidas. Novas issues usam `RRI-*` somente quando o alias de prefixo estiver validado; caso contrário, `COR` permanece como fallback compatível.

## Isolamento

Agentes internos RedRise nunca acessam Companies de clientes. Não existe impersonação, membership automática de suporte ou bypass de conteúdo por `instance_admin`.

Administração de instância limita-se a lifecycle e metadados de control plane. Conteúdo de cliente continua protegido por sessão, membership, role, entitlement e `company_id`.

## Memória e Graphify

Sessões locais consultam Graphify semântico no projeto relevante e leem as fontes citadas antes de decidir. O runtime RedRise no Render não recebe credenciais de memória compartilhada.

Graphify é sempre local por projeto. A atualização semântica ocorre somente pelo wrapper de push, usando a chave MiniMax no Cofre Pessoal; fontes versionadas continuam a autoridade.

## Consequências

- O remoto canônico do pacote operacional é `correnthgroup/redrise-operation`.
- `correnthgroup/redrise-platform` é o único repositório implantável.
- As famílias de capacidade são `RedRise Automate`, `RedRise Build`, `RedRise Operate` e `RedRise Assurance`; elas não recriam Gauss como unidade ativa.
- Documentos ativos devem apontar para os novos paths.
- Histórico Git e evidência Gauss não são reescritos.
