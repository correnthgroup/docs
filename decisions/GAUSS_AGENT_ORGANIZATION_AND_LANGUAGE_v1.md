# Organização e idioma oficial dos agentes Gauss v1

- Status: Vigente
- Data: 2026-07-22
- Owner: Grupo Correnth / Board humano
- Escopo: identidade organizacional da Gauss no Paperclip
- Fonte operacional: `correnthgroup/labs_gauss`

## Decisão

Gauss é o nome vigente do negócio de desenvolvimento de software da Correnth. `Ghaus` e `Ghauss` são denominações substituídas e só podem aparecer em evidência histórica contextualizada.

O idioma oficial da operação da companhia Gauss é português do Brasil (`pt-BR`). Nomes, títulos, projetos, metas, rotinas, issues, instruções fornecidas pela Correnth e resultados gerados devem usar pt-BR. Esta decisão não localiza a interface nativa do Paperclip: botões, menus, navegação, estados, enums e demais textos pertencentes à aplicação permanecem no idioma fornecido pelo produto. Identificadores técnicos, slugs, nomes próprios, modelos, APIs e formatos versionados também permanecem inalterados. A documentação Markdown interna de cada agente pode usar inglês quando necessário ao runtime ou à precisão técnica.

## Organização vigente

| Nome visual | Título oficial | Papel técnico | Reporta a |
|---|---|---|---|
| CEO | Direção Executiva | `ceo` | Board humano |
| CPO | Liderança de Produto | `pm` | CEO |
| PMO | Operações e Análise de Produto | `pm` | CPO |
| CTO | Gerência de Engenharia | `cto` | CEO |
| Sênior Full-Stack Dev | Desenvolvimento Full-Stack | `engineer` | CTO |
| QA | Revisão de Qualidade e Risco | `qa` | CEO |

QA permanece fora da cadeia de engenharia e pode bloquear gates por evidência insuficiente ou risco não aceito. Nenhum agente aprova o próprio trabalho nem substitui o Board em decisões HITL.

## Identificadores portáteis

Os slugs técnicos permanecem estáveis para preservar contratos e rastreabilidade:

- `gauss-ceo-agent`;
- `gauss-product-lead-cpo-agent`;
- `gauss-product-operations-analytics-agent`;
- `gauss-cto-engineering-manager-agent`;
- `gauss-full-stack-engineer-agent`;
- `gauss-quality-risk-reviewer-agent`.

Alterações futuras de nome, título, reporting ou idioma exigem atualização coordenada do Paperclip, do pacote Gauss e desta decisão.
