# CML Consumer Quickstart

## Requisitos

- CML API v1 operacional.
- Consumer autorizado com capability `context.read`.
- `CML_API_BASE_URL` apontando para a API da CML.
- `CML_CONSUMER_ACCESS_TOKEN` em variável de ambiente server-side.
- SDK oficial `@correnth/context-memory/sdk` v1.x instalado no consumidor.

Nunca use o Supabase da CML diretamente, nunca use service role e nunca registre o token.

## Configuração

```text
CML_API_BASE_URL=https://<cml-api-host>
CML_CONSUMER_ACCESS_TOKEN=<secret-for-the-authorized-consumer>
```

O host e o token reais devem vir do provisionamento seguro do ambiente. Este arquivo não contém credenciais.

## Verificação

```text
GET ${CML_API_BASE_URL}/v1/health
GET ${CML_API_BASE_URL}/v1/readiness
```

`health` confirma liveness. `readiness` confirma as dependências essenciais. Uma resposta não pronta deve bloquear o uso dependente de CML de forma explícita.

## Consulta via SDK

```ts
import { CmlClient, searchGlobalContext } from "@correnth/context-memory/sdk"

const client = new CmlClient({
  baseUrl: process.env.CML_API_BASE_URL!,
  getAccessToken: () => process.env.CML_CONSUMER_ACCESS_TOKEN!,
})

const context = await searchGlobalContext(client, "qual e a direção vigente do Grupo Correnth?")
```

`searchGlobalContext` restringe a consulta a `organization_shared`, conteúdo `public/internal` e documentos não arquivados. Preserve citações e `correlationId` no resultado operacional.

## Regras de falha

- Token, identidade, produto ou ambiente ausente: falhar fechado.
- CML indisponível: informar indisponibilidade; não criar banco, embeddings ou retrieval local silencioso.
- Resultado degradado: expor o status e as citações retornadas; não tratá-lo como resposta completa.
- Escritas de decisão, documento ou ingestão exigem capability própria e `Idempotency-Key`.

## Referências

- PRD: `PRD-CML-001_CONTEXT_MEMORY_PLATFORM.md`
- Contrato: `D:\01_studio\context-memory\docs\api\openapi.v1.yaml`
- SDK: `D:\01_studio\context-memory\src\sdk\client.ts`
- Readiness: `READINESS-CML-L10.md`
