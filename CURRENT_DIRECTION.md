# Correnth Current Direction

- Status: Vigente
- Data de revisão: 2026-07-24
- Fonte: decisões canônicas em `decisions/` e PRDs em `platforms/`

## Direção operacional

- O Grupo Correnth opera produtos e negócios com fronteiras próprias e contratos explícitos.
- Paperclip coordena agentes e Work Orders; não substitui a autoridade dos produtos nem das fontes canônicas versionadas.
- RedRise é a plataforma e operação agêntica B2B vigente; sua Company interna absorve as capacidades de desenvolvimento, automação, QA e operação antes atribuídas à Gauss, conforme `decisions/REDRISE_CANONICAL_PRODUCT_AND_INTERNAL_COMPANY_v1.md` e `decisions/REDRISE_PLATFORM_OPERATION_AND_OFFER_ARCHITECTURE_v1.md`.
- A capacidade interna é ampla (`Automate`, `Build`, `Operate`, `Assurance`), mas a porta de entrada comercial é o `RedRise Workflow Pilot`: automação mensurável de um processo B2B com supervisão humana proporcional ao risco.
- O único runtime implantável está em `D:\01_studio\redrise-platform`; o pacote operacional interno está em `D:\02_labs\redrise-operation`.
- A memória compartilhada é recuperada por Graphify semântico sobre documentação e código versionados; os artefatos gerados permanecem índices, não autoridade.
- Os repositórios RedRise e RedRise v2 em `archived` são apenas doadores históricos e não têm autoridade operacional.
- Graphify opera semanticamente por projeto e é atualizado apenas no fluxo local de push com a chave MiniMax no Cofre Pessoal.
- Mudanças destrutivas, credenciais, segurança, produção e publicação exigem HITL conforme a política aplicável.

## Autoridade

Este arquivo orienta a operação e não substitui PRDs vigentes, contratos públicos ou migrations. Em caso de conflito, aplicar a hierarquia em `platforms/GRAPHIFY_SEMANTIC_MEMORY.md`.
