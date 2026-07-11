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

- [PRD-RS-002 - Work Order Data Model](platforms/redscale/PRD-RS-002_WORK_ORDER_DATA_MODEL.md)
- [Paperclip Benchmark](platforms/redscale/PAPERCLIP_BENCHMARK.md)
- [ADR-0002 - RedScale Independent Control Plane](decisions/ADR-0002_REDSCALE_INDEPENDENT_CONTROL_PLANE.md)
