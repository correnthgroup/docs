# AGENTS.md — Documentação canônica Correnth

## Autoridade e descoberta

Os arquivos originais em `D:\00_docs` são a fonte de verdade. `graphify-out\graph.json` é o índice semântico obrigatório de descoberta: antes de analisar, planejar ou editar, consulte-o com uma pergunta específica e leia os arquivos-fonte indicados.

PRDs vigentes prevalecem sobre `CURRENT_DIRECTION.md`; contratos públicos, migrations e código/testes seguem na hierarquia. Conteúdo em `archived`, `_legacy`, logs, roadmaps de referência e artefatos gerados não altera autoridade.

## Graphify semântico

- Cada projeto Correnth possui um grafo próprio; nunca indexe `D:\` inteiro.
- O corpus exclui `graphify-out`, `.graphify-quarantine`, `node_modules`, caches, `_legacy` e `archived`.
- Use `query`, `path`, `explain` e `affected` para descoberta; preserve a referência ao arquivo e seção de origem ao responder.
- Para descoberta entre projetos, obtenha o caminho com `graphify global path` e informe-o com `--graph`; o resultado continua sendo somente um índice.
- Atualize o índice somente antes de push com `D:\00_docs\tools\Invoke-CorrenthSemanticPush.ps1 -ProjectRoot <raiz>`.
- O wrapper usa MiniMax via compatibilidade OpenAI, lê a chave exclusivamente do Cofre Pessoal e registra proveniência de revisão, modelo e extrator nos artefatos gerados.
- O GitHub MCP não substitui o wrapper local: ele só pode seguir com operações remotas após a atualização semântica validada.

## Integridade

Aceite um grafo somente quando manifest e relatório concordarem, endpoints existirem, não houver self-loops e entradas geradas estiverem excluídas. O grafo é um índice de recuperação; documentos e código continuam sendo a memória canônica.
