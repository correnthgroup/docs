# AGENTS.md — Regras de trabalho para `D:\00_docs`

Este arquivo é a política principal de Graphify para o workspace `D:\`. Arquivos `AGENTS.md` em projetos específicos devem referenciar esta regra e só podem divergir para definir root, saída canônica e comandos locais mais restritivos.

## Contexto obrigatório por grafo

Este diretório usa Graphify próprio como índice local de contexto. Antes de responder, analisar, planejar, criar ou editar qualquer artefato sob `D:\00_docs`, o agente deve consultar primeiro o grafo canônico em `graphify-out\graph.json` quando ele existir.

O antigo alias `graphiy-out` foi aposentado porque o junction podia ser seguido pelo scanner e provocar autoindexação. Não recrie aliases, junctions ou cópias da saída dentro do corpus.

1. Verifique se `graphify-out\graph.json` existe e representa o estado atual do diretório.
2. Se não existir ou estiver desatualizado, gere novamente em modo AST-only a partir de `D:\00_docs`: `graphify update . --force`. Não execute Graphify a partir de `D:\` inteiro.
3. Consulte o grafo com uma pergunta específica, por exemplo: `graphify query "quais documentos definem a stack Correnth?" --graph graphify-out\graph.json`.
4. Use a resposta do grafo para localizar os arquivos-fonte; leia os trechos necessários antes de concluir ou alterar algo.
5. Após criar, mover ou alterar documentos relevantes, atualize o grafo local AST-only quando viável e registre limitações. Semantic extraction está desabilitada por padrão e deve ser desconsiderada se não houver ADR local explícito reabilitando-a.

### Gate de integridade

- Nunca promover uma extração parcial. Se qualquer execução gerar saída incompleta, coloque-a em `.graphify-quarantine/` ou remova-a e preserve `graphify-out/` apenas para um índice completo.
- Antes de aceitar o índice, confirme que a contagem de `nodes` e `links` em `graph.json` coincide exatamente com `GRAPH_REPORT.md`, que não há endpoints pendentes/self-loops e que `manifest.json` não contém `graphify-out`, `graphiy-out` nem `.graphify-quarantine` como corpus.
- Saídas geradas não entram no corpus de entrada: ignore `graphify-out/`, `graphiy-out/`, aliases antigos e `.graphify-quarantine/`.

O grafo é um índice de descoberta, não a fonte de verdade. A fonte de verdade continua sendo os arquivos originais em `D:\00_docs`.

> A extração semântica/LLM está desativada por padrão em projetos Correnth. Qualquer reativação exige ADR ou instrução local explícita; sem isso, usar AST-only e desconsiderar semantic edges antigos.

## Política Graphify por projeto em `D:\`

Cada projeto Correnth tem seu próprio Graphify e seu próprio `AGENTS.md`. O agente deve consultar o `AGENTS.md` mais próximo para descobrir o root, a saída canônica e o comando permitido.

- Graphify nunca deve ser executado a partir de `D:\` inteiro.
- Semantic extraction é opt-in por projeto; se não houver política local ativa, usar AST-only.
- `D:\Invoke-CorrenthGraphify.ps1` só deve ser usado por projetos que optaram explicitamente por semântica/LLM.
- Nunca registrar, imprimir, versionar ou copiar chaves para `AGENTS.md`, Markdown, scripts, `.env`, logs ou argumentos visíveis.

## Saídas do Graphify

- `graphify-out\graph.json`: grafo consultável por agentes.
- `graphify-out\GRAPH_REPORT.md`: relatório de arquitetura e conexões.
- `graphify-out\graph.html`: visualização local.

Não usar os arquivos em `graphify-out` como evidência definitiva nem editá-los manualmente.

## Regras gerais

- Preservar os documentos existentes e tratar `decisions\` como decisões canônicas.
- Ao criar documentos de referência, registrar fonte, escopo, data de revisão e decisões pendentes quando aplicável.
- Não copiar blocks, código ou conteúdo externo literalmente sem adaptação e atribuição apropriada.
- Para mudanças de stack, registrar alternativas e marcar decisões sensíveis como `[DECIDIR]`.
- Manter as ações locais dentro de `D:\00_docs`, salvo autorização explícita do usuário.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying relevant files, run the local project Graphify command in AST-only mode unless this project's `AGENTS.md` explicitly opts into semantic extraction.
