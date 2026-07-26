# CML Source of Truth Policy

## Hierarquia

Em caso de divergência, a ordem de autoridade é:

1. PRD vigente em `platforms/cml/`.
2. `CURRENT_DIRECTION.md` como direção operacional vigente do ecossistema.
3. Contrato público versionado no repositório de implementação CML.
4. Migrations aplicadas e reproduzíveis do repositório CML.
5. Código e testes do repositório CML.

Runbooks, task logs, handoffs, roadmaps de referência, protótipos, conversas e implementações substituídas são fontes de suporte, sem autoridade normativa.

Uma camada inferior não pode alterar silenciosamente uma decisão de camada superior.

## Conflitos

- conflitos são registrados explicitamente;
- conteúdo conflitante não é promovido como decisão vigente;
- a CML deve apresentar conflito e fontes ao invés de escolher uma versão por inferência;
- decisões substituídas devem ser removidas da documentação operacional ou preservadas apenas em histórico Git;
- correções relevantes exigem atualização da PRD vigente e, quando aplicável, do contrato público.

## Autoridades por repositório

| Repositório | Autoridade |
|---|---|
| `correnthgroup/docs` | Estratégia, PRDs e direção operacional transversal |
| `correnthgroup/studio_context-memory` | Schema, contracts, runtime, migrations, testes e runbooks da CML |
| `correnthgroup/redrise-platform` | Arquitetura, runtime, migrations e comportamento do produto RedRise |
| `correnthgroup/labs_redrise` | Pacote operacional dos agentes internos RedRise autorizado por contratos CML |
| `correnthgroup/redrise` e `correnthgroup/redrise-v2` | Histórico e doadores arquivados, sem autoridade operacional |

## Política contra duplicação

- documentos canônicos são referenciados por link, não copiados;
- snapshots somente são permitidos quando exigidos para auditoria e devem indicar versão/commit;
- arquivos históricos não ficam na documentação operacional vigente;
- adapters não podem manter migrations, retrieval ou MCP concorrentes.

## Indexação

Somente fontes registradas e classificadas podem ser indexadas. `CURRENT_DIRECTION.md` deve ser indexado como `operating_context` com visibilidade `organization_shared` e `product_key` `correnth`; ele orienta o modus operandi, mas não sobrescreve a PRD vigente nem contratos técnicos. Artefatos semânticos do Graphify podem ser indexados ou anexados a Context Packs quando possuírem origem, versão e autorização registradas. `roadmaps_reference/` pode ser indexado apenas como material de referência, sem autoridade normativa. PRDs Draft, protótipos e implementações substituídas não podem substituir decisões vigentes durante retrieval.
