# Correnth Documentation

Fonte canônica de estratégia, PRDs e decisões transversais do ecossistema Correnth.

## Organização

```text
docs/
|-- decisions/        ADRs transversais
`-- platforms/        PRDs e governanca de plataformas e produtos
```

Documentação específica de implementação deve permanecer próxima ao código no repositório responsável. Não mantenha duas cópias editáveis do mesmo documento.

## CML

- [PRD-CML-001 - Correnth Context Memory Platform](platforms/cml/PRD-CML-001_CONTEXT_MEMORY_PLATFORM.md)
- [Glossário](platforms/cml/GLOSSARY.md)
- [Política de fonte de verdade](platforms/cml/SOURCE_OF_TRUTH.md)
- [Execution tracker](platforms/cml/EXECUTION_TRACKER.md)
- [ADR-0001 - CML compartilhada](decisions/ADR-0001_SHARED_CONTEXT_MEMORY_PLATFORM.md)

## RedScale

- Especificação de produto vigente: `PRD-002 Workforce Spec v2/PDF`
- [ADR-0003 - RedScale como fork rastreável de Paperclip](decisions/ADR-0003_REDSCALE_TRACEABLE_PAPERCLIP_FORK.md)
- Baseline: fork rastreável de Paperclip `v2026.707.0` sob MIT; `PR-001` não introduz alteração comportamental.
- Stack: Express, Vite, Drizzle, Better Auth, PostgreSQL embedded e Gauss `v0.1.0` obrigatório.
- `correnth-ui` é somente referência visual.
- CML fica adiada até depois da paridade de workforce e permanece independente por API/SDK versionada quando retomada.
- A branch do protótipo Next.js/Supabase é material histórico arquivado, não baseline de implementação.

### Documentos históricos RedScale

- [PRD-RS-002 - Work Order Data Model (superseded)](platforms/redscale/PRD-RS-002_WORK_ORDER_DATA_MODEL.md)
- [Paperclip Benchmark (superseded)](platforms/redscale/PAPERCLIP_BENCHMARK.md)
- [ADR-0002 - RedScale Independent Control Plane (superseded somente para a arquitetura RedScale)](decisions/ADR-0002_REDSCALE_INDEPENDENT_CONTROL_PLANE.md)

`ADR-0003` não supersede nem altera [ADR-0001](decisions/ADR-0001_SHARED_CONTEXT_MEMORY_PLATFORM.md) ou a governança CML.

## Gauss

- [Organização e idioma oficial dos agentes Gauss v1](decisions/GAUSS_AGENT_ORGANIZATION_AND_LANGUAGE_v1.md)
