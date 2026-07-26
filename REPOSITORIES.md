# Correnth repository map

- Status: vigente
- Owner: Grupo Correnth
- Last reviewed: 2026-07-25
- Authority: `D:\00_docs\decisions\REDRISE_CANONICAL_PRODUCT_AND_INTERNAL_COMPANY_v1.md` and `D:\00_docs\platforms\GRAPHIFY_SEMANTIC_MEMORY.md`

This document is the operational index for the active Correnth repositories. It defines repository boundaries; it does not replace product PRDs, public contracts or migrations.

## Active repositories

| Repository | Status | Authority and purpose | Local source |
|---|---|---|---|
| `correnthgroup/docs` | Active, canonical | Group direction, transversal decisions, PRDs, policies and contracts | `D:\00_docs` |
| `correnthgroup/redrise-platform` | Active, canonical | Only deployable RedRise runtime: application, API, UI, adapters, migrations and deployment | `D:\01_studio\redrise-platform` |
| `correnthgroup/redrise-operation` | Active | RedRise internal operating package: agents, skills, governance and Paperclip reconciliation | `D:\02_labs\redrise-operation` |
| `correnthgroup/studio_findfee` | Active product | Findfee product development; product-specific authority remains in its own repository and future product docs | Product repository; local canonical path to be registered |

## Naming transition

`correnthgroup/redrise-operation` is the canonical GitHub repository for the RedRise internal operating package. Existing historical links may retain the prior name only as provenance.

## Boundary rules

- `docs` is the canonical transversal documentation repository; product repositories keep product-specific documentation.
- Semantic retrieval is performed locally through Graphify over each active repository. Generated graphs are discovery indexes and never replace the cited source document or code.
- `redrise-platform` is the only RedRise deployable runtime. The operating package must not become a second runtime or migration authority.
- `redrise-operation` is the semantic name for the internal operating package; it is not a customer tenant or deployment repository.
- Findfee remains a separate active product and must receive its own owner, direction and acceptance criteria before its status is treated as production readiness.
- Gauss repositories and material under `_legacy` or archived locations remain historical evidence and are not active authorities.

## Status vocabulary

- **Active, canonical**: current authority for a defined platform or transversal concern.
- **Active, transition name**: current authority whose repository identifier is pending an approved rename.
- **Active product**: product repository in development, with product-specific authority still to be formalized where noted.
- **Archived/historical**: retained for provenance only; cannot define current runtime, migrations or policy.
