# Graphify Semantic Memory Policy

- Status: vigente
- Owner: Grupo Correnth
- Reviewed: 2026-07-25

## Decision

Canonical memory is the versioned documentation and source code in active Correnth repositories. Graphify is the mandatory semantic retrieval index for that corpus; it never overrides a cited source.

Each project keeps its own `graphify-out/graph.json`. Cross-project lookup may use the local Graphify global graph, which is a convenience index and not a separate source of truth.

## Retrieval and authority

Use `query`, `path`, `explain` or `affected` against the project graph before analysing or changing a project. For cross-project discovery, obtain the graph with `graphify global path` and pass it through `--graph`. Read the returned source file and location before relying on the result. PRDs, current direction, public contracts, migrations and code/tests retain their authority order.

## Semantic refresh

Only `D:\00_docs\tools\Invoke-CorrenthSemanticPush.ps1` may refresh semantic graphs for active Correnth roots. It reads the MiniMax key from the Personal Vault in-process, invokes Graphify with the OpenAI-compatible MiniMax backend, validates graph integrity and pushes the generated commit. No key is stored in source control, logs, command arguments or GitHub Secrets.

The local `pre-push` guard rejects a direct push. GitHub MCP can coordinate GitHub operations only after the local wrapper has completed.

## Corpus and history

Generated output, caches, `node_modules`, `_legacy`, `archived` and quarantine directories are excluded from extraction. Historical retired-platform material is retained under `archived/` for provenance and is not part of active retrieval.
