# CML Consumer Quickstart

## Ordem de consulta

1. MCP Gateway global da CML.
2. SDK oficial para integração ou diagnóstico.
3. CLI de diagnóstico.
4. Documentos canônicos locais como fallback explicitamente declarado.

## Requisitos

- CML API v1 operacional.
- Consumer autorizado com capability `context.read`.
- Configuração e token `context.read` disponíveis no Cofre Pessoal desbloqueado para sessões locais.
- SDK oficial `@correnth/context-memory/sdk` v1.x instalado no consumidor.

Nunca use o Supabase da CML diretamente, nunca use service role e nunca registre o token.

## Configuração local

```text
C:\Users\raulv\OneDrive\Cofre Pessoal\Correnth\CML\consumer.json
```

O provider MCP lê o arquivo em cada requisição. O host e o token reais nunca são copiados para `.env`, configuração Codex, logs ou argumentos.

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
