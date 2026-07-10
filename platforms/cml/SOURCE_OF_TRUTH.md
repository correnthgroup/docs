# CML Source of Truth Policy

## Hierarquia

Em caso de divergência, a ordem de autoridade é:

1. ADR aprovado mais recente em `decisions/`.
2. PRD vigente em `platforms/cml/`.
3. Contrato público versionado no repositório de implementação CML.
4. Migrations aplicadas e reproduzíveis do repositório CML.
5. Código e testes do repositório CML.
6. Runbooks e documentação operacional próxima ao código.
7. Task logs, handoffs e documentos históricos.
8. Protótipos, conversas e implementações substituídas.

Uma camada inferior não pode alterar silenciosamente uma decisão de camada superior.

## Conflitos

- conflitos são registrados explicitamente;
- conteúdo conflitante não é promovido como decisão vigente;
- a CML deve apresentar conflito e fontes ao invés de escolher uma versão por inferência;
- decisões substituídas permanecem auditáveis com status e referência à sucessora;
- correções relevantes exigem atualização da PRD ou novo ADR.

## Autoridades por repositório

| Repositório | Autoridade |
|---|---|
| `correnthgroup/docs` | Estratégia, PRDs e ADRs transversais |
| `correnthgroup/CML` | Schema, contracts, runtime, migrations, testes e runbooks da CML |
| `correnthgroup/redrise-v2` | Arquitetura e comportamento próprios do RedRise v2 |
| RedScale | Arquitetura e comportamento próprios do control plane |

## Política contra duplicação

- documentos canônicos são referenciados por link, não copiados;
- snapshots somente são permitidos quando exigidos para auditoria e devem indicar versão/commit;
- arquivos históricos devem informar que não são fonte vigente;
- adapters não podem manter migrations, retrieval ou MCP concorrentes.

## Indexação

Somente fontes registradas e classificadas podem ser indexadas. PRDs Draft, documentos históricos e protótipos devem carregar status e não podem substituir decisões aprovadas durante retrieval.
