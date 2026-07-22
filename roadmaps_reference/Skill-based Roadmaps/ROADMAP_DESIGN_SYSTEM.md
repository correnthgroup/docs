# Design System Roadmap - Checklist (2026)

> Baseado em https://roadmap.sh/design-system - Guia passo a passo para criar e evoluir um design system.
>
> Fonte auxiliar: https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/design-system
>
> Este roadmap tambem referencia [`SHADCN_GUIDE.md`](../outros/SHADCN_GUIDE.md) como guia operacional para componentes, composicao, theming e boas praticas shadcn/ui.

---

## 1. Fundamentos

- [ ] Entender o que e um design system
- [ ] Diferenciar brand guidelines, component library e design system
- [ ] Definir principios de produto
- [ ] Mapear usuarios internos: design, engenharia, produto, QA
- [ ] Inventariar telas e componentes existentes
- [ ] Identificar inconsistencias visuais e de comportamento

---

## 2. Fundacoes Visuais

### 2.1 Tokens

- [ ] Color tokens
- [ ] Typography tokens
- [ ] Spacing tokens
- [ ] Radius tokens
- [ ] Shadow/elevation tokens
- [ ] Motion tokens
- [ ] Breakpoints
- [ ] Z-index scale

### 2.2 shadcn/ui e Tailwind

- [ ] Usar CSS variables como fonte de tema
- [ ] Mapear tokens para `globals.css`
- [ ] Manter `--radius`, `--background`, `--foreground`, `--primary`, `--secondary`, `--muted`, `--accent`, `--destructive`, `--border` e `--ring`
- [ ] Usar `cn()` com `clsx` e `tailwind-merge`
- [ ] Customizar variantes via CVA quando necessario

---

## 3. Componentes

### 3.1 Componentes Base

- [ ] Button
- [ ] Input
- [ ] Field / Label
- [ ] Select
- [ ] Checkbox
- [ ] RadioGroup
- [ ] Switch
- [ ] Textarea
- [ ] Badge
- [ ] Avatar
- [ ] Separator
- [ ] Tooltip

### 3.2 Componentes de Composicao

- [ ] Card com `CardHeader`, `CardTitle`, `CardContent`, `CardFooter`
- [ ] Dialog com `DialogTitle` obrigatorio
- [ ] Sheet com `SheetTitle` obrigatorio
- [ ] AlertDialog para acoes destrutivas
- [ ] Tabs com `TabsTrigger` sempre dentro de `TabsList`
- [ ] Accordion
- [ ] DropdownMenu com items dentro de groups
- [ ] Command para command palette
- [ ] Table e Data Table
- [ ] Sidebar

### 3.3 Regras vindas do SHADCN_GUIDE

- [ ] Usar componentes shadcn existentes antes de criar UI customizada
- [ ] Usar `Alert` para callouts
- [ ] Usar `Empty` para empty states
- [ ] Usar `Sonner` para toasts
- [ ] Usar `Skeleton` para loading placeholders
- [ ] Usar `Badge` em vez de spans customizados de status
- [ ] Usar `Separator` em vez de `<hr>` customizado
- [ ] `Avatar` sempre inclui `AvatarFallback`
- [ ] `Button` em loading usa `Spinner` + `disabled`

---

## 4. Acessibilidade

- [ ] WCAG como baseline
- [ ] Contraste de cor
- [ ] Navegacao por teclado
- [ ] Focus visible
- [ ] Labels e descriptions
- [ ] Roles e ARIA apenas quando necessario
- [ ] Testes com screen reader
- [ ] Estados disabled, invalid, loading e required
- [ ] Dialog/Sheet/Drawer sempre com titulo acessivel

---

## 5. Padroes de Produto

- [ ] Formularios
- [ ] Tabelas e filtros
- [ ] Estados vazios
- [ ] Estados de erro
- [ ] Confirmacoes destrutivas
- [ ] Navegacao lateral
- [ ] Command palette
- [ ] Feedback de sucesso/erro
- [ ] Dashboards
- [ ] Settings pages

---

## 6. Documentacao

- [ ] Principios
- [ ] Tokens
- [ ] Componentes
- [ ] Variantes
- [ ] Quando usar / quando evitar
- [ ] Exemplos reais
- [ ] Guidelines de acessibilidade
- [ ] Guidelines de conteudo
- [ ] Changelog
- [ ] Processo de contribuicao

---

## 7. Ferramentas

- [ ] Figma variables
- [ ] Figma components e variants
- [ ] Storybook
- [ ] shadcn/ui CLI
- [ ] Tailwind CSS
- [ ] TypeScript
- [ ] Radix UI primitives
- [ ] React Hook Form + Zod para formularios
- [ ] TanStack Table para data tables
- [ ] Visual regression tests

---

## 8. Governanca

- [ ] Definir ownership
- [ ] Criar criterios de aceitacao para componentes
- [ ] Versionar mudancas
- [ ] Revisar breaking changes
- [ ] Medir adocao
- [ ] Criar canal de suporte
- [ ] Manter backlog publico
- [ ] Auditar duplicacao de componentes

---

## 9. Entregaveis

- [ ] Biblioteca base em `components/ui/`
- [ ] Tokens em CSS variables
- [ ] Storybook ou docs equivalentes
- [ ] Exemplos de composicao por fluxo
- [ ] Checklist de acessibilidade
- [ ] Guia de contribuicao
- [ ] Mapeamento Figma -> codigo
- [ ] Migration guide para produtos existentes

---

## Stack Recomendada para 2026

| Camada | Tecnologia |
| ------ | ---------- |
| UI base | shadcn/ui |
| Primitivas | Radix UI |
| Estilo | Tailwind CSS v4 |
| Tokens | CSS variables |
| Variantes | class-variance-authority |
| Formularios | React Hook Form + Zod |
| Tabelas | TanStack Table |
| Documentacao | Storybook + Markdown |
| Design | Figma variables/components |
| Testes visuais | Playwright screenshots |

---

## Fontes de pesquisa

- [roadmap.sh — Design System](https://roadmap.sh/design-system) — estrutura principal do percurso.
- [Repositório oficial developer-roadmap — Design System](https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/design-system) — tópicos e histórico da fonte.
- [shadcn/ui Documentation](https://ui.shadcn.com/docs) — componentes e composição adotados pela Correnth.
- [Tailwind CSS Documentation](https://tailwindcss.com/docs) — tokens utilitários e estilos.
- [Storybook Documentation](https://storybook.js.org/docs) — documentação, testes e catálogo de componentes.
- [W3C — ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/) — padrões de componentes acessíveis.

---

*Ultima atualizacao: Julho 2026*
