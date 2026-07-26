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

The local `pre-push` guard rejects a direct push. When the canonical
`graphify-out/graph.json` is tracked by Git LFS, the same hook invokes
`git lfs pre-push` only after the semantic wrapper gate passes, so the pointer
and its object cannot diverge. GitHub MCP can coordinate GitHub operations only
after the local wrapper has completed.

Semantic extraction continues to use MiniMax in `deep` mode. Community naming
uses deterministic `Community N` placeholders (`cluster-only --no-label`):
labels are presentation metadata, and this avoids an unbounded labeling request
when an OpenAI-compatible backend emits reasoning outside the expected JSON.
The wrapper writes `.graphify_labels.json` from the final community IDs before
hashing and promoting the canonical artifact set.

## Corpus and history

Generated output, caches, `node_modules`, `_legacy`, `archived` and quarantine directories are excluded from extraction. Historical retired-platform material is retained under `archived/` for provenance and is not part of active retrieval.
