# Correnth Current Direction

- Status: Vigente
- Data de revisão: 2026-07-24
- Fonte: decisões canônicas em `decisions/` e PRDs em `platforms/`

## Direção operacional

- O Grupo Correnth opera produtos e negócios com fronteiras próprias e contratos explícitos.
- Paperclip coordena agentes e Work Orders; não substitui a autoridade dos produtos nem da CML.
- RedRise é o produto B2B agentic SaaS vigente e sua Company interna substitui a Gauss, conforme `decisions/REDRISE_CANONICAL_PRODUCT_AND_INTERNAL_COMPANY_v1.md`.
- O único runtime implantável está em `D:\01_studio\redrise-platform`; o pacote operacional interno está em `D:\02_labs\redrise`.
- A CML é a plataforma compartilhada de contexto em `D:\01_studio\context-memory`. Sessões locais usam MCP por padrão e SDK/CLI como diagnóstico.
- Os repositórios RedRise e RedRise v2 em `archived` são apenas doadores históricos e não têm autoridade operacional.
- Graphify opera por projeto em modo AST-only; extração semântica não está autorizada.
- Mudanças destrutivas, credenciais, segurança, produção e publicação exigem HITL conforme a política aplicável.

## Autoridade

Este arquivo orienta a operação e não substitui PRDs vigentes, contratos públicos ou migrations. Em caso de conflito, aplicar a hierarquia em `platforms/cml/SOURCE_OF_TRUTH.md`.
