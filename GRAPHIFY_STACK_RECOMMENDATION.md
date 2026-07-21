# Graphify — Recomendação de Stack Local para `D:\00_docs`

**Escopo:** exclusivamente este diretório documental. A política principal de Graphify do workspace vive em `D:\00_docs\AGENTS.md`; produtos Correnth devem ter seus próprios `AGENTS.md` locais.

**Estado do ambiente em 2026-07-14:** `uv 0.11.28` e `graphify 0.9.15` instalados. A skill do Graphify foi instalada localmente para Codex em `.codex/skills/graphify/`.

## Objetivo

Manter um grafo local e consultável dos roadmaps, decisões, PRDs, referências e demais documentos em `D:\00_docs`, para reduzir releitura de arquivos e melhorar a rastreabilidade entre decisões.

## Componentes

| Camada | Escolha | Regra |
|---|---|---|
| Runtime | Python 3.10+ | Python já instalado no ambiente; manter versão compatível com Graphify. |
| Gerenciador de ferramentas | uv | Instalar Graphify isoladamente, sem poluir dependências de projetos. |
| Indexador | `graphifyy` (CLI `graphify`) | Pacote oficial; fixar/revisar versão antes de upgrades. |
| Saída do grafo | `D:\00_docs\graphify-out` | Saída canônica local deste diretório. Não recriar aliases como `graphiy-out`. |
| Consulta | CLI `graphify query` | Toda interação neste diretório começa por consulta específica ao grafo. |
| Fonte de verdade | Arquivos originais | Grafo descobre relações; arquivos-fonte confirmam conteúdo. |
| Integração futura | MCP local via `python -m graphify.serve` | Ativar apenas quando houver cliente MCP configurado e necessidade recorrente. |

## Instalação padrão

```powershell
winget install --id astral-sh.uv
uv tool install graphifyy
```

## Operação

```powershell
# Geração inicial / rebuild AST-only
graphify update . --force

# Atualização incremental após mudanças relevantes
graphify update . --force

# Consulta focada
graphify query "quais documentos definem o padrão de stack?" --graph graphify-out\graph.json
```

> O Graphify gera nativamente `graphify-out`. Validar a existência de `graph.json` antes de consultar. Não execute Graphify a partir de `D:\` inteiro.

### Política de semântica

Semantic extraction é opt-in por projeto. Para `D:\00_docs`, a política vigente é AST-only por padrão; semantic/LLM output antigo deve ser desconsiderado salvo ADR local explícita reabilitando o modo semântico.

## Limites e segurança

- O grafo é local; não publicar `graph.json` ou documentos sensíveis sem revisão.
- Excluir segredos, `.env`, dependências, builds e saídas geradas (`graphify-out`, `.graphify-quarantine` e equivalentes) da indexação.
- Não substituir a leitura de documentos críticos por resumo do grafo.
- Regerar o grafo após alterações estruturais, movimentação de arquivos ou criação de decisões canônicas.
