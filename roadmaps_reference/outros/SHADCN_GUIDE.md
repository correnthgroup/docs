# shadcn/ui - Guia Completo de Componentes

> Guia de referência para todos os componentes shadcn/ui, incluindo variações, composição, interações e boas práticas.
>
> Baseado em: ui.shadcn.com/docs/components | Atualizado: Julho 2026

---

## Sumário

1. [Visão Geral](#visão-geral)
2. [Instalação & Setup](#instalação--setup)
3. [Componentes](#componentes)
4. [Padrões de Composição](#padrões-de-composição)
5. [Theming & Customização](#theming--customização)
6. [Dark Mode](#dark-mode)
7. [Integração com Formulários](#integração-com-formulários)
8. [Referências Externas](#referências-externas)

---

## Visão Geral

shadcn/ui **não é uma biblioteca npm tradicional**. Os componentes são copiados diretamente no seu projeto (`components/ui/`), dando total controle sobre o código.

### Princípios Fundamentais
- **Propriedade total**: você é dono do código, pode modificar qualquer linha
- **Baseado em Radix UI**: acessibilidade garantida via primitivas Radix
- **Styled com Tailwind CSS**: utilitários para fácil customização
- **TypeScript first**: tipagem completa
- **Zero dependências externas**: sem conflitos de versão

### CLI Essencial
```bash
# Inicializar no projeto
npx shadcn@latest init

# Adicionar componentes
npx shadcn@latest add button
npx shadcn@latest add card input form dialog table badge

# Adicionar todos
npx shadcn@latest add --all

# Buscar componente
npx shadcn@latest search <nome>

# Documentação de componente
npx shadcn@latest docs <componente>
```

---

## Instalação & Setup

### Pré-requisitos
- Next.js, Remix, Vite ou outro framework React
- Tailwind CSS configurado
- TypeScript (recomendado)

### Inicialização
```bash
npx shadcn@latest init
```

O CLI gera:
- `components.json` - configuração do shadcn
- `components/ui/` - diretório dos componentes
- `lib/utils.ts` - utilitário `cn()`
- CSS variables no `globals.css`

### components.json
```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "default",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.ts",
    "css": "app/globals.css",
    "baseColor": "slate",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils"
  }
}
```

### Utility cn()
```ts
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

---

## Componentes

### 1. Accordion

**O que é**: Conjunto empilhado de headings interativos que revelam conteúdo.

**Sub-componentes**: `Accordion`, `AccordionItem`, `AccordionTrigger`, `AccordionContent`

**Variações**:
| Prop | Tipo | Descrição |
|------|------|-----------|
| `type` | `"single" \| "multiple"` | Uma ou múltiplas seções abertas |
| `collapsible` | `boolean` | Permite fechar todos (type="single") |
| `defaultValue` | `string \| string[]` | Item(s) aberto(s) por padrão |
| `disabled` | `boolean` | Desabilitar item individual |

**Composição**:
```
Accordion
├── AccordionItem
│   ├── AccordionTrigger
│   └── AccordionContent
└── AccordionItem
    ├── AccordionTrigger
    └── AccordionContent
```

**Combina com**: Card (wrap), Separator, Typography

**Instalação**:
```bash
npx shadcn@latest add accordion
```

---

### 2. Alert

**O que é**: Notificação inline para mensagens de sucesso, erro ou informação.

**Variações**:
| Prop | Descrição |
|------|-----------|
| `variant="default"` | Estilo padrão |
| `variant="destructive"` | Erro/destruição |

**Combina com**: AlertDialog (confirmação), Icon (ícone contextual)

---

### 3. Alert Dialog

**O que é**: Modal de confirmação para ações destrutivas (diferente de Dialog comum).

**Sub-componentes**: `AlertDialog`, `AlertDialogTrigger`, `AlertDialogContent`, `AlertDialogHeader`, `AlertDialogTitle`, `AlertDialogDescription`, `AlertDialogFooter`, `AlertDialogAction`, `AlertDialogCancel`

**Quando usar**: Ao invés de Dialog quando a ação é destrutiva e precisa de confirmação explícita.

**Regra**: `DialogTitle` é obrigatório para acessibilidade.

**Combina com**: Button (ação/cancelamento), Form (formulário dentro)

---

### 4. Aspect Ratio

**O que é**: Mantém proporção de dimensões (16:9, 4:3, etc.).

**Combina com**: Card (imagem), Avatar, Badge

---

### 5. Avatar

**O que é**: Exibe imagem de perfil com fallback.

**Sub-componentes**: `Avatar`, `AvatarImage`, `AvatarFallback`

**Regra obrigatória**: Sempre incluir `AvatarFallback` para quando a imagem falhar.

**Combina com**: Button (menu de usuário), Card (perfil), DropdownMenu (ações)

---

### 6. Badge

**O que é**: Label curto para status, tags ou categorias.

**Variações**:
| Prop | Descrição |
|------|-----------|
| `variant="default"` | Preenchido |
| `variant="secondary"` | Secundário |
| `variant="destructive"` | Erro/destruição |
| `variant="outline"` | Apenas borda |

**Combina com**: Card (status), Table (coluna de status), Button (label)

---

### 7. Breadcrumb

**O que é**: Navegação hierárquica mostrando o caminho atual.

**Sub-componentes**: `Breadcrumb`, `BreadcrumbList`, `BreadcrumbItem`, `BreadcrumbLink`, `BreadcrumbPage`, `BreadcrumbSeparator`, `BreadcrumbEllipsis`

**Combina com**: NavigationMenu, Separator

---

### 8. Button

**O que é**: Elemento de ação principal.

**Variações**:
| Prop | Valores | Descrição |
|------|---------|-----------|
| `variant` | `default`, `outline`, `ghost`, `destructive`, `secondary`, `link` | Aparência |
| `size` | `xs`, `sm`, `default`, `lg`, `icon`, `icon-xs`, `icon-sm`, `icon-lg` | Tamanho |
| `asChild` | `boolean` | Renderiza como child (Slot pattern) |

**Estados**:
- **Loading**: Use `<Spinner data-icon="inline-start" />` + `disabled` (não existe `isPending`/`isLoading` no Button)
- **Disabled**: `disabled` prop nativa
- **Rounded**: `className="rounded-full"`

**Regra de ícones**: Ícones dentro de Button NÃO devem ter classes de tamanho (`size-4`). Use `data-icon="inline-start"` ou `data-icon="inline-end"`.

**Combina com**: ButtonGroup, Spinner, Icon, Link (via asChild), DropdownMenu (trigger)

**Instalação**:
```bash
npx shadcn@latest add button
```

---

### 9. Button Group

**O que é**: Grupo de Botões visualmente conectados.

**Combina com**: Button, DropdownMenu, Toggle

---

### 10. Calendar

**O que é**: Seletor de datas.

**Combina com**: DatePicker, Popover, Input, Form

**Instalação**:
```bash
npx shadcn@latest add calendar
```

---

### 11. Card

**O que é**: Container para agrupar conteúdo relacionado.

**Sub-componentes**: `Card`, `CardHeader`, `CardTitle`, `CardDescription`, `CardAction`, `CardContent`, `CardFooter`

**Variações**:
| Prop | Valores | Descrição |
|------|---------|-----------|
| `size` | `default`, `sm` | Tamanho (sm = mais compacto) |
| `--card-spacing` | CSS variable | Espaçamento customizável |

**Composição obrigatória**:
```
Card
├── CardHeader
│   ├── CardTitle
│   ├── CardDescription
│   └── CardAction (opcional)
├── CardContent
└── CardFooter (opcional)
```

**Regra**: NÃO jogue tudo dentro de CardContent. Use a estrutura completa para semântica correta.

**Combina com**: Button (ações), Badge (status), Avatar (perfil), Separator, Tabs (seções)

**Instalação**:
```bash
npx shadcn@latest add card
```

---

### 12. Carousel

**O que é**: Componente de slide/swipe para imagens ou conteúdo.

**Combina com**: Card, AspectRatio, Button (navegação), Badge (indicadores)

---

### 13. Chart

**O que é**: Wrapper para Recharts com theming integrado.

**Combina com**: Card, Tabs (diferentes visualizações), Select (filtros)

---

### 14. Checkbox

**O que é**: Input de seleção múltipla.

**Combina com**: Form (React Hook Form), Label, Field, Table (row selection), Group

---

### 15. Collapsible

**O que é**: Container que pode ser expandido/recolhido.

**Sub-componentes**: `Collapsible`, `CollapsibleTrigger`, `CollapsibleContent`

**Combina com**: Sidebar (grupos colapsáveis), Accordion, Button (trigger)

---

### 16. Combobox

**O que é**: Input com busca e sugestões (autocomplete).

**Combina com**: Popover, Command, Input, Form, Label

---

### 17. Command

**O que é**: Menu de comando para busca e ações rápidas (Cmd+K pattern).

**Sub-componentes**: `Command`, `CommandDialog`, `CommandInput`, `CommandList`, `CommandEmpty`, `CommandGroup`, `CommandItem`, `CommandSeparator`, `CommandShortcut`

**Composição**:
```
Command
├── CommandInput
└── CommandList
    ├── CommandEmpty
    ├── CommandGroup
    │   ├── CommandItem
    │   └── CommandItem
    ├── CommandSeparator
    └── CommandGroup
        ├── CommandItem
        └── CommandItem
```

**Combina com**: Dialog (CommandDialog), Input, Kbd (atalhos), Popover, Badge

**Instalação**:
```bash
npx shadcn@latest add command
```

---

### 18. Context Menu

**O que é**: Menu de contexto (clique direito).

**Combina com**: DropdownMenu (similar), Table (ações de linha)

---

### 19. Data Table

**O que é**: Tabela de dados avançada com TanStack Table.

**Funcionalidades**: Sorting, Filtering, Pagination, Row Selection, Column Visibility, Row Actions

**Combina com**: Table, Input (filtro), DropdownMenu (ações), Button, Pagination, Checkbox, Badge

**Instalação**:
```bash
npx shadcn@latest add table
npm install @tanstack/react-table
```

---

### 20. Date Picker

**O que é**: Seletor de data completo.

**Combina com**: Calendar, Popover, Input, Button, Select (hora/fuso)

---

### 21. Dialog

**O que é**: Modal overlay para tarefas focadas.

**Sub-componentes**: `Dialog`, `DialogTrigger`, `DialogContent`, `DialogHeader`, `DialogTitle`, `DialogDescription`, `DialogFooter`, `DialogClose`

**Composição obrigatória**:
```
Dialog
├── DialogTrigger
└── DialogContent
    ├── DialogHeader
    │   ├── DialogTitle
    │   └── DialogDescription
    ├── (conteúdo)
    └── DialogFooter
```

**Regra**: `DialogTitle` é obrigatório para acessibilidade. Use `className="sr-only"` se quiser esconder visualmente.

**Variante Sticky Footer**: Para ações sempre visíveis durante scroll.

**Combina com**: Form (formulário dentro), Button (trigger/ação), AlertDialog (confirmação), Sheet (alternativa mobile)

**Instalação**:
```bash
npx shadcn@latest add dialog
```

---

### 22. Drawer

**O que é**: Painel mobile-first que desliza de baixo.

**Combina com**: Sheet (alternativa desktop), Dialog, Form, Button

---

### 23. Dropdown Menu

**O que é**: Menu suspenso de ações.

**Sub-componentes**: `DropdownMenu`, `DropdownMenuTrigger`, `DropdownMenuContent`, `DropdownMenuItem`, `DropdownMenuCheckboxItem`, `DropdownMenuRadioItem`, `DropdownMenuLabel`, `DropdownMenuSeparator`, `DropdownMenuGroup`, `DropdownMenuPortal`, `DropdownMenuSub`, `DropdownMenuSubContent`, `DropdownMenuSubTrigger`

**Regra**: Items SEMPRE dentro de `DropdownMenuGroup`.

**Combina com**: Button (trigger), Table (row actions), Avatar (menu de usuário), Sidebar (ações)

---

### 24. Empty

**O que é**: Estado vazio quando não há dados.

**Sub-componentes**: `Empty`, `EmptyHeader`, `EmptyMedia`, `EmptyTitle`, `EmptyDescription`, `EmptyContent`

**Combina com**: Button (ação para criar), Icon, Card

---

### 25. Field

**O que é**: Wrapper para campos de formulário com label, descrição e erro.

**Sub-componentes**: `Field`, `FieldGroup`, `FieldLabel`, `FieldDescription`, `FieldError`

**Combina com**: Input, Select, Textarea, Checkbox, RadioGroup, Switch, Button

---

### 26. Hover Card

**O que é**: Card que aparece ao passar o mouse sobre um elemento.

**Combina com**: Avatar, Badge, Button, Typography

---

### 27. Input

**O que é**: Campo de entrada de texto.

**Variações**:
- Basic: `<Input />`
- With Field: `<Field><FieldLabel>Email</FieldLabel><Input /></Field>`
- Disabled: `disabled` prop + `data-disabled` no Field
- Invalid: `aria-invalid` + `data-invalid` no Field
- File: `type="file"`
- Inline: `orientation="horizontal"` no Field
- Grid: Fields lado a lado
- Required: `required` prop

**Combina com**: Field, Label, Button (ação inline), InputGroup, Form

**Instalação**:
```bash
npx shadcn@latest add input
```

---

### 28. Input Group

**O que é**: Input com ícones, texto ou botões internos.

**Combina com**: Input, Button, Field, Icon

---

### 29. Input OTP

**O que é**: Input para códigos OTP (One-Time Password).

**Combina com**: Form, Button, Label

---

### 30. Kbd

**O que é**: Exibe atalhos de teclado.

**Combina com**: Command (atalhos), Tooltip, Button (atalho)

---

### 31. Label

**O que é**: Label acessível para campos de formulário.

**Combina com**: Input, Select, Checkbox, Switch, RadioGroup, Field

---

### 32. Menubar

**O que é**: Barra de menus estilo desktop (File, Edit, View...).

**Combina com**: NavigationMenu, DropdownMenu (similar), Separator

---

### 33. Navigation Menu

**O que é**: Menu de navegação principal com mega menu support.

**Combina com**: Breadcrumb, Sidebar, Button, Card (mega menu content)

---

### 34. Pagination

**O que é**: Navegação entre páginas.

**Combina com**: Button, Select (page size), DataTable, Table

---

### 35. Popover

**O que é**: Contento flutuante que aparece ao clicar.

**Combina com**: Button (trigger), Calendar (date picker), Command (combobox), Form

---

### 36. Progress

**O que é**: Barra de progresso.

**Combina com**: Card (dashboard), Skeleton (loading), Spinner

---

### 37. Radio Group

**O que é**: Seleção exclusiva entre opções.

**Combina com**: Form, Label, Field, Button (group variant)

---

### 38. Resizable

**O que é**: Container com redimensionamento drag-to-resize.

**Combina com**: Sidebar, Card, Table, ScrollArea

---

### 39. Scroll Area

**O que é**: Área com scroll customizado.

**Combina com**: Command, DropdownMenu, Select, Sidebar, Resizable

---

### 40. Select

**O que é**: Dropdown de seleção.

**Sub-componentes**: `Select`, `SelectTrigger`, `SelectValue`, `SelectContent`, `SelectGroup`, `SelectLabel`, `SelectItem`, `SelectSeparator`

**Composição**:
```
Select
├── SelectTrigger
│   └── SelectValue
└── SelectContent
    ├── SelectGroup
    │   ├── SelectLabel
    │   ├── SelectItem
    │   └── SelectItem
    ├── SelectSeparator
    └── SelectGroup
        ├── SelectLabel
        ├── SelectItem
        └── SelectItem
```

**Variações**:
- Item aligned: `position="item-aligned"` (default)
- Popper: `position="popper"`

**Combina com**: Form, Label, Field, Button, DataTable (page size, filters)

---

### 41. Separator

**O que é**: Linha divisória horizontal ou vertical.

**Regra**: Use Separator ao invés de `<hr>` ou divs com borda customizada.

**Combina com**: Card, Dialog, DropdownMenu, Sidebar, Tabs, Accordion

---

### 42. Sheet

**O que é**: Painel lateral overlay (alternativa ao Dialog).

**Sub-componentes**: `Sheet`, `SheetTrigger`, `SheetContent`, `SheetHeader`, `SheetTitle`, `SheetDescription`, `SheetFooter`, `SheetClose`

**Variações**:
| Prop | Valores |
|------|---------|
| `side` | `top`, `right`, `bottom`, `left` |

**Quando usar Sheet vs Dialog vs Drawer**:
| Caso de uso | Componente |
|-------------|-----------|
| Tarefa focada com input | Dialog |
| Ação destrutiva | AlertDialog |
| Painel lateral com detalhes | Sheet |
| Mobile-first bottom panel | Drawer |

**Regra**: `SheetTitle` é obrigatório para acessibilidade.

**Combina com**: Form, Button, Input, Tabs, Sidebar

---

### 43. Sidebar

**O que é**: Sidebar colapsável e temática.

**Sub-componentes**: `SidebarProvider`, `Sidebar`, `SidebarHeader`, `SidebarContent`, `SidebarFooter`, `SidebarGroup`, `SidebarGroupLabel`, `SidebarGroupAction`, `SidebarGroupContent`, `SidebarMenu`, `SidebarMenuItem`, `SidebarMenuButton`, `SidebarMenuAction`, `SidebarMenuBadge`, `SidebarMenuSub`, `SidebarMenuSubItem`, `SidebarMenuSubButton`, `SidebarMenuSkeleton`, `SidebarTrigger`, `SidebarRail`, `SidebarInset`

**Variações**:
| Prop | Valores |
|------|---------|
| `side` | `left`, `right` |
| `variant` | `sidebar`, `floating`, `inset` |
| `collapsible` | `offcanvas`, `icon`, `none` |

**Hook**: `useSidebar()` - `state`, `open`, `setOpen`, `openMobile`, `setOpenMobile`, `isMobile`, `toggleSidebar`

**Combina com**: Collapsible (grupos), DropdownMenu (ações), Avatar (usuário), Separator, Badge (counts), NavigationMenu

**Instalação**:
```bash
npx shadcn@latest add sidebar
```

---

### 44. Skeleton

**O que é**: Placeholder de loading.

**Regra**: Use Skeleton ao invés de construir markup customizado para loading states.

**Combina com**: Card, Table, Avatar, Sidebar (SidebarMenuSkeleton)

---

### 45. Slider

**O que é**: Input de range (0-100).

**Combina com**: Form, Label, Field, Tooltip (valor)

---

### 46. Sonner (Toast)

**O que é**: Notificações toast. shadcn/ui agora usa Sonner por padrão.

**Uso**:
```tsx
import { toast } from "sonner"

toast("Operação realizada com sucesso")
toast.error("Algo deu errado")
toast.success("Dados salvos")
```

**Regra**: Use Sonner (toast) ao invés de construir toasts customizados.

**Combina com**: Dialog (confirmação), Form (feedback), Button (trigger)

---

### 47. Spinner

**O que é**: Indicador de carregamento circular.

**Uso em Button**:
```tsx
<Button disabled>
  <Spinner data-icon="inline-start" />
  Carregando
</Button>
```

**Regra**: Button NÃO tem `isPending`/`isLoading`. Componha com Spinner + disabled.

**Combina com**: Button, Card (loading state), Progress

---

### 48. Switch

**O que é**: Toggle on/off.

**Combina com**: Form, Label, Field, Card (settings)

---

### 49. Table

**O que é**: Tabela responsiva.

**Sub-componentes**: `Table`, `TableHeader`, `TableBody`, `TableFooter`, `TableRow`, `TableHead`, `TableCell`, `TableCaption`

**Composição**:
```
Table
├── TableCaption
├── TableHeader
│   └── TableRow
│       ├── TableHead
│       └── TableHead
├── TableBody
│   ├── TableRow
│   │   ├── TableCell
│   │   └── TableCell
│   └── TableRow
│       ├── TableCell
│       └── TableCell
└── TableFooter
```

**Combina com**: DropdownMenu (row actions), Badge (status), Button, Pagination, Checkbox (row selection), Data Table (avançado)

**Instalação**:
```bash
npx shadcn@latest add table
```

---

### 50. Tabs

**O que é**: Seções de conteúdo que mostram um por vez.

**Sub-componentes**: `Tabs`, `TabsList`, `TabsTrigger`, `TabsContent`

**Variações**:
| Prop | Valores | Descrição |
|------|---------|-----------|
| `variant` | `default`, `line` | Aparência do TabsList |
| `orientation` | `horizontal`, `vertical` | Direção |

**Regra**: `TabsTrigger` SEMPRE dentro de `TabsList`.

**Combina com**: Card, Form (formulários por aba), DataTable, Table, Separator, Icon

**Instalação**:
```bash
npx shadcn@latest add tabs
```

---

### 51. Textarea

**O que é**: Campo de texto multi-linha.

**Combina com**: Form, Label, Field, Button

---

### 52. Toast

**O que é**: Notificações (legado, usar Sonner).

**Combina com**: Sonner (recomendado)

---

### 53. Toggle

**O que é**: Botão toggle (on/off).

**Combina com**: ToggleGroup, Button, Toolbar

---

### 54. Toggle Group

**O que é**: Grupo de toggles para seleção de opções.

**Variações**:
| Prop | Descrição |
|------|-----------|
| `type` | `"single"` ou `"multiple"` |
| `variant` | `"default"`, `"outline"` |
| `size` | `"default"`, `"sm"`, `"lg"` |

**Regra**: Para 2-7 opções, use ToggleGroup ao invés de mapear Button components.

**Combina com**: Button (individual), Toggle, Tooltip, Form

---

### 55. Tooltip

**O que é**: Dica que aparece ao hover.

**Combina com**: Button, IconButton, Icon, Kbd, Avatar, Sidebar (menu items colapsados)

---

### 56. Typography

**O que é**: Componentes de texto estilizado.

**Combina com**: Card, Separator, Heading, Link

---

### 57. Marker

**O que é**: Marcador/destaque visual (novo).

---

### 58. Message / Message Scroller

**O que é**: Componentes para exibição de mensagens/chat (novos).

---

### 59. Bubble

**O que é**: Balão de mensagem estilo chat (novo).

---

## Padrões de Composição

### Regras Críticas

1. **Items sempre dentro do Group**:
   - `SelectItem` → `SelectGroup`
   - `DropdownMenuItem` → `DropdownMenuGroup`
   - `CommandItem` → `CommandGroup`
   - `MenubarItem` → `MenubarGroup`

2. **Callouts usam Alert** (não divs customizadas)

3. **Empty states usam Empty** (não markup customizado)

4. **Toasts usam Sonner** (não componentes customizados)

5. **Dialog/Sheet/Drawer sempre têm Title** (obrigatório para a11y)

6. **Card usa estrutura completa**: CardHeader > CardTitle > CardContent > CardFooter

7. **Button não tem isLoading**: Componha com Spinner + disabled

8. **TabsTrigger sempre dentro de TabsList**

9. **Avatar sempre tem AvatarFallback**

10. **Use Separator** ao invés de `<hr>` ou divs com borda

11. **Use Skeleton** para loading placeholders

12. **Use Badge** ao invés de spans customizados

### Choosing Overlay Components

| Caso de uso | Componente |
|-------------|-----------|
| Tarefa focada com input | `Dialog` |
| Ação destrutiva (confirmar delete) | `AlertDialog` |
| Painel lateral com detalhes/filtros | `Sheet` |
| Painel mobile-first | `Drawer` |
| Info rápida no hover | `HoverCard` |
| Conteúdo contextual pequeno no click | `Popover` |
| Command palette | `Command` inside `Dialog` |

### asChild Pattern

Muitos componentes suportam `asChild` para renderizar como o child ao invés de wrapper:

```tsx
<Button asChild>
  <Link href="/login">Login</Link>
</Button>
```

Útil para: links como botões, ícones como triggers, qualquer elemento que precise de semântica HTML diferente.

### Compound Components Pattern

shadcn usa compound components extensivamente. Cada componente exporta sub-componentes:

```tsx
// ✅ Correto
<Card>
  <CardHeader>
    <CardTitle>Título</CardTitle>
  </CardHeader>
  <CardContent>...</CardContent>
</Card>

// ❌ Incorreto
<Card title="Título" content={...} />
```

### Context Pattern (evitar prop drilling)

Para componentes compostos complexos, use Context para compartilhar estado:

```tsx
const DialogContext = React.createContext(null)

function Dialog({ children }) {
  const [open, setOpen] = useState(false)
  return (
    <DialogContext.Provider value={{ open, setOpen }}>
      {children}
    </DialogContext.Provider>
  )
}

function DialogTrigger() {
  const { setOpen } = useContext(DialogContext)
  return <button onClick={() => setOpen(true)}>Abrir</button>
}
```

---

## Theming & Customização

### CSS Variables

shadcn usa CSS variables para theming. Todas as cores ficam no `globals.css`:

```css
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --muted: 210 40% 96.1%;
    --accent: 210 40% 96.1%;
    --destructive: 0 84.2% 60.2%;
    --border: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    /* ... */
  }
}
```

Mude `--primary` para a cor da sua marca e todos os componentes que a usam atualizam automaticamente.

### class-variance-authority (CVA)

Componentes usam CVA para variantes tipadas:

```tsx
const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md text-sm font-medium",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground",
        destructive: "bg-destructive text-destructive-foreground",
        outline: "border border-input bg-background",
        secondary: "bg-secondary text-secondary-foreground",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)
```

Para adicionar uma nova variante, edite o `cva` no arquivo do componente.

---

## Dark Mode

shadcn suporta dark mode via CSS variables:

```tsx
// Toggle com next-themes
import { ThemeProvider } from "next-themes"

<ThemeProvider attribute="class" defaultTheme="system" enableSystem>
  {children}
</ThemeProvider>
```

```tsx
// Toggle button
import { Moon, Sun } from "lucide-react"
import { Button } from "@/components/ui/button"
import { useTheme } from "next-themes"

export function ThemeToggle() {
  const { theme, setTheme } = useTheme()
  return (
    <Button variant="ghost" size="icon" onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
      <Sun className="h-5 w-5 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-5 w-5 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
    </Button>
  )
}
```

---

## Integração com Formulários

### Stack Recomendada
- **React Hook Form** - gerenciamento de estado do form
- **Zod** - validação schema-first
- **shadcn Form component** - wrappers acessíveis

### Instalação
```bash
npx shadcn@latest add form
pnpm add react-hook-form @hookform/resolvers zod
```

### Exemplo Completo
```tsx
"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { useForm } from "react-hook-form"
import * as z from "zod"

import { Button } from "@/components/ui/button"
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form"
import { Input } from "@/components/ui/input"

const formSchema = z.object({
  email: z.string().email("Email inválido"),
  password: z.string().min(8, "Mínimo 8 caracteres"),
})

export function LoginForm() {
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: { email: "", password: "" },
  })

  function onSubmit(values: z.infer<typeof formSchema>) {
    toast.success("Login realizado!")
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input placeholder="email@exemplo.com" {...field} />
              </FormControl>
              <FormDescription>Seu email de acesso.</FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit">Entrar</Button>
      </form>
    </Form>
  )
}
```

### Padrão: Dialog + Form
```tsx
// Dialog é container, Form é conteúdo - responsabilidades separadas
<Dialog open={open} onOpenChange={setOpen}>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Novo Item</DialogTitle>
      <DialogDescription>Preencha os dados abaixo.</DialogDescription>
    </DialogHeader>
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)}>
        {/* campos */}
        <Button type="submit">Salvar</Button>
      </form>
    </Form>
  </DialogContent>
</Dialog>
```

---

## Referências Externas

### Guias Recomendados

| Fonte | URL | Foco |
|-------|-----|------|
| shadcn/ui Docs | https://ui.shadcn.com/docs | Documentação oficial |
| shadcn/ui Composition Rules | https://github.com/shadcn-ui/ui/blob/HEAD/skills/shadcn/rules/composition.md | Regras de composição oficiais |
| The Ultimate shadcn/ui Handbook (2026) | https://shadcnspace.com/blog/shadcn-ui-handbook | Arquitetura, padrões, production |
| Complete Guide (DesignRevision) | https://designrevision.com/blog/shadcn-ui-guide | Instalação, theming, forms, data tables |
| shadcn/ui + Next.js 15 (StackNotice) | https://stacknotice.com/blog/shadcn-ui-nextjs-complete-guide-2026 | Forms com Zod, data tables, toasts |
| shadcn/ui Cheat Sheet (CodedThemes) | https://blog.codedthemes.com/shadcn-ui-cheat-sheet/ | CLI commands, componentes, patterns |
| Deep Dive: Theming & Custom Variants | https://dev.to/whoffagents/shadcnui-deep-dive-theming-custom-variants | Customização avançada |
| Vercel Academy: Core Concepts | https://vercel.com/academy/shadcn-ui/core-concepts | CVA, asChild, composition |
| Composition Patterns (BetterLink) | https://eastondev.com/blog/en/posts/dev/20260401-shadcn-composition-patterns/ | Dialog+Form, Context pattern |
| shadcn/ui Composition (LLM Best Practices) | https://llmbestpractices.com/frontend/shadcn-composition | asChild, Slot, variant extension |
| Component Composition Rules (DeepWiki) | https://deepwiki.com/shadcn-ui/ui/9.1-component-composition-rules | Regras obrigatórias de nesting |
| LogRocket Adoption Guide | https://blog.logrocket.com/shadcn-ui-adoption-guide/ | Análise comparativa, pros/cons |
| Jishu Labs Guide 2026 | https://jishulabs.com/blog/shadcn-ui-component-library-guide-2026 | Comparação com MUI/Chakra |
| Vercel Academy: Compound Components | https://vercel.com/academy/shadcn-ui/compound-components-and-advanced-composition | Padrões avançados |

### Cheat Sheet Rápido de Componentes

| Necessidade | Componente |
|-------------|-----------|
| Botão/Ação | `Button` com variante apropriada |
| Inputs de formulário | `Input`, `Select`, `Combobox`, `Switch`, `Checkbox`, `RadioGroup`, `Textarea`, `InputOTP`, `Slider` |
| Toggle 2-5 opções | `ToggleGroup` + `ToggleGroupItem` |
| Exibição de dados | `Table`, `Card`, `Badge`, `Avatar` |
| Navegação | `Sidebar`, `NavigationMenu`, `Breadcrumb`, `Tabs`, `Pagination` |
| Overlays | `Dialog` (modal), `Sheet` (side panel), `Drawer` (bottom), `AlertDialog` (confirmação) |
| Feedback | `Sonner` (toast), `Alert`, `Progress`, `Skeleton`, `Spinner` |
| Command palette | `Command` inside `Dialog` |
| Charts | `Chart` (Recharts wrapper) |
| Layout | `Card`, `Separator`, `Resizable`, `ScrollArea`, `Accordion`, `Collapsible` |
| Empty states | `Empty` |
| Menus | `DropdownMenu`, `ContextMenu`, `Menubar` |
| Tooltips/info | `Tooltip`, `HoverCard`, `Popover` |

### Dicas de Produção (2026)

1. **Use Existing Components First** - Verifique `npx shadcn@latest search` antes de criar UI customizada
2. **Compose, Don't Reinvent** - Settings page = Tabs + Card + form controls. Dashboard = Sidebar + Card + Chart + Table
3. **Use Built-in Variants** - `variant="outline"`, `size="sm"`, etc. antes de styles customizados
4. **Items inside Groups** - `SelectItem` → `SelectGroup`, `DropdownMenuItem` → `DropdownMenuGroup`
5. **Read Component Source** - Os arquivos em `components/ui/` são editáveis; leia antes de modificar
6. **Review After Adding** - Sempre verifique sub-componentes, imports e composição após adicionar
7. **Dark Mode** - shadcn suporta via CSS variables; use `next-themes` para toggle
8. **Monorepo** - shadcn funciona em monorepos com Turborepo/Nx

---

*Guia atualizado: Julho 2026 | Fonte: ui.shadcn.com + comunidade*
