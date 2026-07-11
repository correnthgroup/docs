# ADR-0002 - RedScale Independent Control Plane

- Status: Approved
- Data: 2026-07-10
- Owner: Correnth / RedScale
- Relacionados: `PRD-RS-002`, `ADR-0001`, `PRD-CML-001`

## Contexto

RedScale precisa coordenar trabalho entre operadores e agentes sem herdar os limites de um produto cliente, de um banco existente ou de uma ferramenta de memoria. A primeira configuracao sera usada pela Correnth, mas o produto deve continuar instalavel e util por outras organizacoes.

Paperclip e uma referencia funcional relevante para control planes de agentes. Isso nao torna RedScale um fork, uma copia, uma distribuicao ou uma dependencia de Paperclip.

## Decisao

1. RedScale e um produto open-source e self-hosted generico.
2. Correnth e o primeiro customer e a primeira configuracao do produto, nao o tenant hardcoded nem uma edicao separada.
3. RedScale possui control plane, ciclo de release, schema e Supabase operacional dedicados e independentes.
4. O banco RedScale nao usa tabelas, views, foreign data wrappers, triggers, service roles ou FKs dos bancos RedRise ou CML.
5. RedScale nao depende do banco RedRise e nao depende do banco CML para preservar seus objetos operacionais.
6. A CML e um servico dedicado e independente. RedScale a consome somente por API/SDK versionada e com identidade revogavel de menor privilegio.
7. Identificadores CML persistidos pelo RedScale sao referencias externas opacas, sem FK cross-database.
8. CML e a unica camada de memoria aprovada por enquanto. RedScale nao integra nem mantem memoria paralela em Obsidian, GBrain ou outras ferramentas.
9. Cache tecnico temporario de resposta CML pode existir para resiliencia, mas nao constitui memoria, nao vira fonte de verdade e deve ter TTL e proveniencia explicitos.
10. Inspiracao funcional em Paperclip deve ser documentada como benchmark. Nao se deve alegar afiliacao, compatibilidade, origem comum ou reutilizacao de codigo sem evidencia e revisao de licenca.

## Boundaries

```text
RedScale
|-- Supabase RedScale dedicado
|   `-- organizations, products, projects, work orders e eventos
|-- API/UI do control plane
`-- adapter CML por API/SDK
    `-- IDs externos opacos, sem FK

CML
|-- servico e Supabase proprios
`-- memoria, retrieval e Context Packs

RedRise
`-- produto e banco proprios; nenhuma dependencia de persistencia do RedScale
```

RedScale pode continuar operando work orders quando CML estiver indisponivel, com degradacao explicita. Nessa condicao, nao inventa contexto, nao consulta uma memoria alternativa e nao replica o banco CML.

## Consequencias positivas

- instalacao self-hosted sem ativos privados da Correnth;
- isolamento de falhas, migrations, credenciais e ciclos de deploy;
- Correnth exercita a mesma configuracao extensivel oferecida a outros customers;
- integracao CML substituivel por versao de contrato, sem acoplamento de schema;
- ownership claro entre dados operacionais e memoria.

## Consequencias negativas

- operacao de um Supabase adicional;
- necessidade de autenticacao, retry e observabilidade entre RedScale e CML;
- referencias externas podem ficar indisponiveis ou apontar para versoes retiradas;
- joins entre operacao e memoria precisam ocorrer na aplicacao, nao no banco.

## Alternativas rejeitadas

### Reusar o banco RedRise

Rejeitada porque acoplaria um control plane generico a um produto consumidor, suas migrations e seu ciclo de vida.

### Reusar o banco CML

Rejeitada porque mistura dados operacionais mutaveis com a plataforma dedicada de memoria e viola o contrato API/SDK.

### Criar memoria interna ou integrar varias ferramentas

Rejeitada nesta fase porque duplica autoridade, retrieval e governanca. CML permanece a unica camada de memoria ate uma nova decisao aprovada.

### Derivar RedScale por fork de Paperclip

Rejeitada. O benchmark informa capacidades e riscos, mas RedScale possui produto, arquitetura, implementacao e roadmap proprios.

## Enforcement

- CI deve rejeitar connection strings, project refs e service roles de RedRise ou CML no runtime RedScale.
- Migrations RedScale devem aplicar em um Supabase vazio e dedicado.
- Testes de contrato devem simular CML somente por HTTP/SDK.
- Revisoes arquiteturais devem bloquear novas camadas de memoria sem ADR substituta.
- Branding e documentacao publica devem declarar inspiracao apenas quando relevante e nunca afiliacao.

## Reversibilidade

Hosting, provider de Postgres e implementacao do adapter CML podem mudar mantendo os boundaries. Compartilhar banco, adicionar memoria paralela ou adotar dependencia de Paperclip exige nova ADR que substitua explicitamente esta decisao.
