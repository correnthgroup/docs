# CML Glossary

Vocabulário canônico para documentos, contratos, banco e APIs da Context Memory Platform.

| Termo | Definição | Não confundir com |
|---|---|---|
| Organization | Limite principal de propriedade e isolamento de dados | Workspace ou slug de rota |
| Product | Unidade do ecossistema registrada, como RedRise ou RedRose | Repositório ou environment |
| Environment | Contexto de execução: development, preview, staging ou production | Organization |
| Consumer | Aplicação, agente, operador ou integração autenticada | Usuário final genérico |
| Capability | Permissão explícita concedida a um consumer | Role textual sem enforcement |
| Source | Origem autorizada e configurada de conteúdo | Documento já indexado |
| Document | Identidade lógica estável de um conteúdo | Versão específica |
| Document Version | Snapshot imutável do conteúdo em determinado momento | Documento lógico |
| Chunk | Segmento citado de uma Document Version | Summary |
| Decision | Decisão registrada com estado, rationale e evidências | Inferência de modelo |
| Context Query | Pedido auditável de recuperação de contexto | Busca irrestrita no banco |
| Context Pack | Snapshot compacto, citado e imutável preparado para um objetivo | Prompt livre ou conjunto bruto de chunks |
| Graph Artifact | Arquivo semântico gerado pelo Graphify, como `graph.json`, relatório ou subgrafo | Fonte canônica sem classificação |
| Retrieval | Processo autorizado de localizar e ordenar contexto | Acesso direto a tabelas |
| Adapter | Integração fina de um consumidor com contratos CML | Cópia local da CML |
| Workspace | Conceito de produto permitido somente quando modelado pelo próprio consumidor | Organization canônica da CML |

## Regras de nomenclatura

- IDs de organization, product, environment e consumer são conceitos distintos.
- Slugs são identificadores de apresentação e nunca substituem IDs de autorização.
- `product_key` hardcoded não é autoridade de produto.
- `workspace_id` não será usado como sinônimo de `organization_id`.
- Toda fronteira pública usa contratos versionados e termos deste glossário.
- Termo ambíguo deve ser corrigido antes de virar migration ou API pública.
