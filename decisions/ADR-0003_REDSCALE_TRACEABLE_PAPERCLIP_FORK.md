# ADR-0003 - RedScale como fork rastreavel de Paperclip

- Status: Aprovado
- Data: 2026-07-11
- Owner: Correnth / RedScale
- Relacionados: `ADR-0001`, `ADR-0002`, `PRD-002 Workforce Spec v2/PDF`, `PR-001`
- Supersede: `ADR-0002` somente para a arquitetura RedScale

## Contexto

RedScale precisa de um baseline de producao que alcance paridade de workforce sem manter uma segunda arquitetura de control plane. O prototipo independente em Next.js/Supabase validou hipoteses de produto, mas continuar a partir dele duplicaria capacidades ja disponiveis em Paperclip e aumentaria o custo de paridade, upgrades e auditorias de proveniencia.

Paperclip `v2026.707.0` fornece o baseline selecionado sob a licenca MIT. Sua adocao exige rastreabilidade upstream explicita, preservacao dos avisos de licenca e copyright e um primeiro pull request controlado que separe o estabelecimento de proveniencia das mudancas de produto.

## Decisao

1. RedScale e aprovado como fork rastreavel de Paperclip `v2026.707.0` sob a licenca MIT.
2. O fork deve preservar o historico upstream ou outro mapeamento auditavel de commits, a referencia da tag upstream e todos os avisos exigidos pela licenca MIT. Mudancas RedScale devem permanecer distinguiveis do codigo upstream.
3. `PR-001` estabelece o baseline do fork sem alteracao comportamental. Branding, comportamento de produto, mudancas de schema, adicao de features e adaptacoes especificas da Correnth nao fazem parte de `PR-001`.
4. A stack baseline e Express, Vite, Drizzle, Better Auth e PostgreSQL embedded. Substituir esses componentes exige uma decisao arquitetural posterior aprovada.
5. Ghaus `v0.1.0` e obrigatorio no RedScale. Sua adocao apos o baseline inalterado deve ser explicita, versionada e revisavel separadamente.
6. `correnth-ui` e somente referencia visual. Nao e baseline de codigo, componentes, runtime, pacotes ou arquitetura e nao deve obscurecer a proveniencia do fork.
7. A integracao CML fica adiada ate depois da paridade de workforce. Quando retomada, CML permanece uma plataforma independente consumida pelo RedScale somente por API/SDK versionada, com identidade revogavel de menor privilegio e sem acoplamento direto de banco.
8. A branch anterior do prototipo Next.js/Supabase fica arquivada. Ela e mantida somente como evidencia historica e nao e baseline de implementacao, migracao, comportamento, schema ou arquitetura.
9. `PRD-002 Workforce Spec v2/PDF` e a especificacao de produto vigente. O modelo anterior de work orders e o benchmark Paperclip permanecem disponiveis somente como registros historicos.

## Boundaries do baseline

```text
Paperclip v2026.707.0 (MIT)
`-- fork RedScale rastreavel
    |-- PR-001: baseline de proveniencia, sem alteracao comportamental
    |-- Express / Vite / Drizzle / Better Auth
    |-- embedded PostgreSQL
    |-- Ghaus v0.1.0 obrigatorio
    `-- adapter CML pos-paridade
        `-- CML independente somente por API/SDK versionada

correnth-ui
`-- somente referencia visual

branch arquivada do prototipo Next.js/Supabase
`-- evidencia historica, nao baseline
```

## Consequencias

- Proveniencia upstream e obrigacoes MIT tornam-se requisitos de review e release.
- RedScale parte do comportamento, arquitetura e modelo de dados de Paperclip na versao fixada, e nao do prototipo independente.
- `PR-001` pode ser auditado como baseline mecanicamente fiel antes do inicio de mudancas especificas do RedScale.
- A customizacao do produto segue `PRD-002 Workforce Spec v2/PDF`, com Ghaus `v0.1.0` obrigatorio e `correnth-ui` limitado a referencia visual.
- CML nao bloqueia a paridade de workforce nem se torna embedded no runtime RedScale quando o trabalho for retomado.
- O prototipo arquivado pode informar analise historica, mas nao pode justificar divergencia do baseline aprovado.

## Escopo da supersessao

Esta ADR supersede `ADR-0002` somente onde aquela ADR define arquitetura RedScale, baseline de implementacao, stack, escolha de persistencia ou rejeita derivacao de Paperclip. Essas decisoes especificas do RedScale deixam de reger.

Esta ADR nao supersede nem altera `ADR-0001`, `PRD-CML-001` ou qualquer governanca CML. CML permanece independente e regida por seus documentos existentes; somente o momento da integracao RedScale fica adiado ate depois da paridade de workforce. O boundary por API/SDK continua obrigatorio quando a integracao for retomada.

## Enforcement

- `PR-001` deve identificar Paperclip `v2026.707.0`, registrar a fonte upstream e o mapeamento de commits, preservar avisos MIT e nao produzir delta comportamental intencional.
- O review de `PR-001` deve rejeitar features RedScale, rebranding que altere comportamento, migrations de schema, substituicoes de stack ou importacao de codigo do prototipo.
- Mudancas posteriores devem estar separadas de `PR-001` e ser rastreaveis como deltas RedScale.
- CI e documentacao de release devem manter checks de licenca/proveniencia e a versao fixada de Ghaus.
- Nenhum runtime RedScale pode acessar tabelas ou credenciais CML diretamente; a integracao retomada exige o boundary por API/SDK versionada.

## Reversibilidade

Alterar a versao upstream, abandonar a rastreabilidade do fork, substituir a stack baseline, remover Ghaus ou tornar CML embedded exige nova ADR. O arquivamento do prototipo e reversivel somente como operacao de branch historica; promove-lo novamente a baseline exige ADR explicita que superseda esta decisao.
