# Frontend Developer Roadmap - Checklist (2026)

> Baseado em [https://roadmap.sh/frontend](https://roadmap.sh/frontend) - Guia passo a passo para se tornar um desenvolvedor frontend moderno.

---

## 1. Fundamentos

### 1.1 Internet & Como Funciona

- [ ] Entender como a internet funciona (HTTP, DNS, hosting)
- [ ] Conhecer o processo de como um site é carregado

### 1.2 HTML

- [ ] Tags semânticas (header, main, footer, nav, article, section)
- [ ] Forms e validações
- [ ] Acessibilidade básica (aria labels, roles)
- [ ] SEO fundamentals (meta tags, heading hierarchy, alt text)

### 1.3 CSS

- [ ] Selectors, specificity, cascade
- [ ] Box model (margin, border, padding, content)
- [ ] Flexbox
- [ ] CSS Grid
- [ ] Responsive design (media queries, fluid typography)
- [ ] Animations & transitions
- [ ] CSS Variables / Custom Properties
- [ ] Tailwind CSS (utility-first)



### 1.4 JavaScript

- [ ] Sintaxe básica e tipos de dados
- [ ] DOM manipulation
- [ ] Event handling
- [ ] ES6+ (arrow functions, destructuring, spread/rest, template literals)
- [ ] Promises, async/await
- [ ] Fetch API / AJAX
- [ ] Closures, hoisting, scope
- [ ] Prototypes e classes



### 1.5 TypeScript

- [ ] Tipos básicos e avançados
- [ ] Interfaces e type aliases
- [ ] Generics
- [ ] Utility types
- [ ] Type narrowing e narrowing patterns
- [ ] Declaration files (.d.ts)

---



## 2. Controle de Versão



### 2.1 Git

- [ ] Init, add, commit, push, pull
- [ ] Branching e merging
- [ ] Resolving conflicts
- [ ] Git flow / GitHub flow
- [ ] Rebase e cherry-pick
- [ ] .gitignore



### 2.2 GitHub

- [ ] Repositórios, forks, pull requests
- [ ] Code review
- [ ] GitHub Actions (CI/Básico)
- [ ] Issues e Projects

---



## 3. Framework Frontend (Escolher 1)



### 3.1 React (Recomendado)

- [ ] JSX e componentes funcionais
- [ ] Props e state
- [ ] Hooks (useState, useEffect, useContext, useRef, useMemo, useCallback)
- [ ] Custom hooks
- [ ] Context API
- [ ] React Router (client-side routing)
- [ ] Server Components (Next.js)
- [ ] Suspense e lazy loading
- [ ] Error boundaries



### 3.2 Alternativas

- [ ] Vue.js - Composition API, reatividade
- [ ] Svelte - Compiled framework
- [ ] Angular - Full framework (enterprise)

---



## 4. Metodologias CSS / UI Libraries



### 4.1 Tailwind CSS (Recomendado)

- [ ] Utility classes
- [ ] Responsividade
- [ ] Customization (tailwind.config)
- [ ] Dark mode



### 4.2 shadcn/ui

- [ ] Instalar e configurar MCP
- [ ] Componentes core (Button, Card, Input, Form)
- [ ] Theming com CSS variables
- [ ] Dark mode
- [ ] Compound components pattern
- [ ] Form integration (React Hook Form + Zod)
- [ ] Data tables (TanStack Table)



### 4.3 Outras abordagens

- [ ] CSS Modules
- [ ] Styled Components / Emotion
- [ ] CSS-in-JS

---



## 5. Gerenciamento de Estado



### 5.1 Estado Local

- [ ] React state (useState/useReducer)
- [ ] Component state patterns



### 5.2 Estado Global

- [ ] Context API + useReducer
- [ ] Zustand (leve, recomendado)
- [ ] Jotai / Recoil (atomico)
- [ ] Redux Toolkit (enterprise)



### 5.3 Server State

- [ ] TanStack Query (React Query)
- [ ] SWR
- [ ] Apollo Client (GraphQL)

---



## 6. Formulários & Validação



### 6.1 Form Libraries

- [ ] React Hook Form (recomendado)
- [ ] TanStack Form
- [ ] Formik (legado)



### 6.2 Validação

- [ ] Zod (schema-first, recomendado)
- [ ] Yup
- [ ] Joi

---



## 7. API & Data Fetching

- [ ] REST APIs (fetch, axios)
- [ ] GraphQL (Apollo, urql)
- [ ] WebSockets
- [ ] Server-Sent Events (SSE)
- [ ] OpenAPI / Swagger (documentação)

---



## 8. Roteamento



### 8.1 Client-Side

- [ ] React Router v6+
- [ ] TanStack Router



### 8.2 File-Based (SSR/SSG)

- [ ] Next.js (App Router)
- [ ] Remix
- [ ] Nuxt (Vue)
- [ ] SvelteKit

---



## 9. SSR / SSG / ISR

- [ ] Server-Side Rendering (SSR)
- [ ] Static Site Generation (SSG)
- [ ] Incremental Static Regeneration (ISR)
- [ ] Streaming SSR
- [ ] React Server Components
- [ ] Next.js App Router

---



## 10. Testes

> **Nota sobre Playwright**: Roda via Python 3.12 gerenciado por `uv`. Ver seção 17B para detalhes.



### 10.1 Unit Tests

- [ ] Vitest (recomendado 2026)
- [ ] Jest
- [ ] React Testing Library



### 10.2 Integration Tests

- [ ] Cypress
- [ ] Playwright



### 10.3 E2E Tests

- [ ] Playwright (recomendado) — executado via Python 3.12 com `uv`
- [ ] Cypress

---



## 11. Build Tools & Bundlers

- [ ] Vite (recomendado 2026)
- [ ] esbuild
- [ ] Turbopack
- [ ] Webpack (conhecimento)
- [ ] SWC (compilador)

---



## 12. Package Managers

- [x] npm / npx (recomendado)
- [ ] yarn
- [ ] pnpm

---



## 13. Deploy & Hospedagem



### 13.1 Plataformas

- [x] Render (recomendado)
- [ ] Vercel
- [ ] Netlify
- [ ] Cloudflare Pages
- [ ] AWS Amplify
- [ ] Docker (containerização)



### 13.2 CI/CD

- [ ] GitHub Actions
- [ ] GitLab CI
- [ ] CircleCI

---



## 14. Performance & Otimização



### 14.1 Core Web Vitals

- [ ] LCP (Largest Contentful Paint)
- [ ] FID (First Input Delay) / INP (Interaction to Next Paint)
- [ ] CLS (Cumulative Layout Shift)



### 14.2 Técnicas

- [ ] Lazy loading (imagens, componentes)
- [ ] Code splitting
- [ ] Image optimization (Next/Image)
- [ ] Font optimization
- [ ] Memoização (useMemo, useCallback, React.memo)
- [ ] Bundle analysis

---



## 15. Acessibilidade (a11y)

- [ ] WCAG guidelines
- [ ] Semântica HTML
- [ ] Keyboard navigation
- [ ] Screen readers
- [ ] Focus management
- [ ] Color contrast
- [ ] ARIA attributes

---



## 16. SEO

- [ ] Meta tags
- [ ] Structured data (JSON-LD)
- [ ] Sitemap
- [ ] Robots.txt
- [ ] Open Graph / Twitter Cards
- [ ] Server-side rendering para SEO

---



## 17. PWA (Progressive Web Apps)

- [ ] Service Workers
- [ ] Cache API
- [ ] Manifest.json
- [ ] Push Notifications
- [ ] Offline support

---



## 17B. Ferramentas Python (via uv)



### Gerenciamento de Ambiente

- [ ] `uv` como gerenciador de pacotes Python (substitui pip/pip-tools)
- [ ] Python 3.12 como versão padrão do projeto
- [ ] `uv venv` para criar ambientes virtuais
- [ ] `uv pip install` para instalar dependências
- [ ] `uv run` para executar scripts e comandos



### Playwright (E2E Testing)

- [ ] Playwright instalado via `uv pip install playwright`
- [ ] Browsers via `uv run playwright install`
- [ ] Scripts de teste em `tests/e2e/`
- [ ] Execução: `uv run pytest tests/e2e/`
- [ ] Integração com CI/CD via GitHub Actions



### graphify (Memória do Projeto)

- [ ] graphify instalado via `uv pip install graphify`
- [ ] Graph de conhecimento em `graphify-out/`
- [ ] Atualização: `graphify update D:\Projetos`
- [ ] Consulta: `graphify query "<pergunta>" --graph graphify-out/graph.json`
- [ ] Path: `graphify path "<A>" "<B>" --graph graphify-out/graph.json`
- [ ] Wiki: `graphify-out/wiki/index.md` como entry point
- [ ] Relatório: `graphify-out/GRAPH_REPORT.md` para god nodes e comunidades
- [ ] Após modificar código, sempre rodar `graphify update` para manter graph atualizado

---



## 18. Ferramentas & Dev Tools

- [ ] Browser DevTools (Chrome/Firefox)
- [ ] VS Code + extensões
- [ ] ESLint
- [ ] Prettier
- [ ] Husky + lint-staged
- [ ] Storybook (documentação de componentes)

---



## 19. Design System & Arquitetura

- [ ] Design tokens
- [ ] Component library pattern
- [ ] Storybook
- [ ] Figma (leitura de designs)
- [ ] Atomic Design methodology

---



## 20. Conceitos Avançados

- [ ] Micro Frontends
- [ ] Monorepos (Turborepo, Nx)
- [ ] Web Components
- [ ] WASM (WebAssembly)
- [ ] Web APIs (IntersectionObserver, ResizeObserver, etc.)
- [ ] Internationalization (i18n)

---



## Stack Recomendada para 2026


| Camada          | Tecnologia                                 |
| --------------- | ------------------------------------------ |
| Framework       | Next.js 16 (App Router)                    |
| Linguagem       | TypeScript                                 |
| UI Components   | shadcn/ui                                  |
| CSS             | Tailwind CSS v4                            |
| Forms           | React Hook Form + Zod                      |
| Data Fetching   | TanStack Query                             |
| State (global)  | Zustand                                    |
| Data Tables     | TanStack Table                             |
| Testing         | Vitest + Playwright (via Python 3.12 / uv) |
| Build           | Vite / Turbopack                           |
| Package Manager | npm / npx                                  |
| Deploy          | Render                                     |
| Linting         | ESLint + Prettier                          |
| Python Tooling  | uv (Python 3.12)                           |
| E2E Testing     | Playwright via`uv run`                     |
| Project Memory  | graphify via`uv` (graphify-out/)           |


---

## Fontes de pesquisa

- [roadmap.sh — Frontend](https://roadmap.sh/frontend) — estrutura principal do percurso.
- [Repositório oficial developer-roadmap — Frontend](https://github.com/kamranahmedse/developer-roadmap/tree/master/src/data/roadmaps/frontend) — tópicos e histórico da fonte.
- [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web) — padrões e APIs da plataforma Web.
- [React Documentation](https://react.dev/) — modelo de componentes e APIs oficiais.
- [W3C — Web Content Accessibility Guidelines](https://www.w3.org/WAI/standards-guidelines/wcag/) — critérios de acessibilidade.
- [Playwright Documentation](https://playwright.dev/docs/intro) — testes de interface e navegador.

---

*Última atualização: Julho 2026*
