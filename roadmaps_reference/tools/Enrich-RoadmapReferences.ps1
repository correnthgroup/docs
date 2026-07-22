param(
    [Parameter(Mandatory = $true)]
    [string]$OfficialRepository,

    [string]$RoadmapsRoot = (Split-Path -Parent $PSScriptRoot),

    [switch]$Force
)

$ErrorActionPreference = 'Stop'

function Get-FrontMatterValue {
    param([string]$Text, [string]$Key)
    $pattern = ('(?m)^{0}:\s*(?<value>[^\r\n]+)' -f [regex]::Escape($Key))
    $match = [regex]::Match($Text, $pattern)
    if ($match.Success) { return $match.Groups['value'].Value.Trim().Trim("'", '"') }
    return $null
}

function ConvertTo-PlainText {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $null }
    $clean = $Value -replace '<br\s*/?>', ' / '
    $clean = $clean -replace '<[^>]+>', ''
    $clean = $clean -replace '\*\*|__|`', ''
    $clean = $clean -replace '\s+', ' '
    return $clean.Trim(' ', '-', ':')
}

function Add-UniqueItem {
    param(
        [System.Collections.Generic.List[object]]$List,
        [System.Collections.Generic.HashSet[string]]$Seen,
        [string]$Label,
        [double]$Order = 999999
    )
    $plain = ConvertTo-PlainText $Label
    if ([string]::IsNullOrWhiteSpace($plain) -or $plain.Length -gt 120) { return }
    if ($plain -match '^(roadmap\.sh|vertical node|horizontal node|related roadmaps)$') { return }
    if ($Seen.Add($plain.ToLowerInvariant())) {
        $List.Add([pscustomobject]@{ Label = $plain; Order = $Order })
    }
}

function Get-TopicFocus {
    param([string]$Topic)
    $t = $Topic.ToLowerInvariant()
    switch -Regex ($t) {
        'security|secure|auth|identity|threat|vulnerab|crypt|red team' {
            return 'Aplicar controles de segurança, validar riscos e registrar evidências de proteção.'
        }
        'test|quality|qa|review|debug|observab|monitor|incident|reliab' {
            return 'Verificar comportamento, diagnosticar falhas e tornar a qualidade observável e repetível.'
        }
        'deploy|release|ci|cd|container|docker|kubernetes|cloud|aws|terraform|infrastructure|network' {
            return 'Automatizar entrega e operação com configuração reproduzível, telemetria e recuperação segura.'
        }
        'data|database|sql|postgres|mongo|redis|elastic|storage|warehouse|etl|analytics' {
            return 'Modelar, consultar e operar dados com integridade, desempenho e governança.'
        }
        'api|graphql|rest|http|webhook|integration|protocol' {
            return 'Definir contratos interoperáveis, versionados, testáveis e resistentes a falhas.'
        }
        'ai|agent|model|machine learning|ml|prompt|rag|embedding|llm' {
            return 'Construir e avaliar comportamento de IA com contexto, ferramentas, métricas e limites explícitos.'
        }
        'architecture|design|pattern|system|scal|distributed' {
            return 'Tomar decisões arquiteturais explícitas, comparar trade-offs e preservar evolutividade.'
        }
        'manage|lead|team|stakeholder|strategy|product|discovery|roadmap' {
            return 'Converter objetivos em decisões, alinhamento, execução mensurável e aprendizado contínuo.'
        }
        'performance|cache|concurr|async|thread|memory' {
            return 'Medir gargalos e escolher otimizações sustentadas por testes e perfis de execução.'
        }
        'syntax|type|variable|function|class|object|loop|condition|collection|algorithm|structure' {
            return 'Dominar os fundamentos e expressá-los em código legível, testável e fácil de depurar.'
        }
        'ui|ux|css|html|component|accessib|responsive|frontend' {
            return 'Entregar interfaces consistentes, acessíveis, responsivas e verificáveis.'
        }
        default {
            return "Compreender $Topic e demonstrar seu uso em um exercício ou entrega verificável."
        }
    }
}

function Get-OfficialResources {
    param([string]$ContentDirectory)
    $results = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if (-not (Test-Path -LiteralPath $ContentDirectory)) { return $results }

    foreach ($file in Get-ChildItem -LiteralPath $ContentDirectory -File -Filter '*.md' | Sort-Object Name) {
        foreach ($line in Get-Content -LiteralPath $file.FullName) {
            if ($line -notmatch '@official@') { continue }
            $match = [regex]::Match($line, '\[(?<label>[^\]]+)\]\((?<url>https?://[^\s\)]+)\)')
            if (-not $match.Success) { continue }
            $label = ($match.Groups['label'].Value -replace '^@official@', '').Trim()
            $url = $match.Groups['url'].Value.Trim()
            if ($url -match '(youtube\.com|youtu\.be|medium\.com|dev\.to|udemy\.com|coursera\.org|freecodecamp\.org/news/)') { continue }
            if ($seen.Add($url)) {
                $results.Add([pscustomobject]@{ Label = (ConvertTo-PlainText $label); Url = $url })
            }
            if ($results.Count -ge 8) { return $results }
        }
    }
    return $results
}

function Get-RoadmapTopics {
    param([string]$RoadmapDirectory, [string]$Slug)
    $topics = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    $jsonCandidates = @(
        (Join-Path $RoadmapDirectory "$Slug.json"),
        (Join-Path $RoadmapDirectory "$Slug-beginner.json")
    ) | Where-Object { Test-Path -LiteralPath $_ }

    if ($jsonCandidates.Count -eq 0) {
        $jsonCandidates = @(Get-ChildItem -LiteralPath $RoadmapDirectory -File -Filter '*.json' |
            Where-Object { $_.Name -notmatch 'migration|mapping' } |
            Select-Object -ExpandProperty FullName -First 1)
    }

    foreach ($jsonPath in $jsonCandidates | Select-Object -First 1) {
        try {
            $data = Get-Content -Raw -LiteralPath $jsonPath | ConvertFrom-Json
            foreach ($node in $data.nodes) {
                if ($node.type -notin @('topic', 'label')) { continue }
                $order = if ($null -ne $node.position.y) { [double]$node.position.y } else { 999999 }
                Add-UniqueItem -List $topics -Seen $seen -Label ([string]$node.data.label) -Order $order
            }
        } catch {
            Write-Warning "Não foi possível ler ${jsonPath}: $($_.Exception.Message)"
        }
    }

    $contentDirectory = Join-Path $RoadmapDirectory 'content'
    if ($topics.Count -lt 10 -and (Test-Path -LiteralPath $contentDirectory)) {
        $order = 1000000
        foreach ($contentFile in Get-ChildItem -LiteralPath $contentDirectory -File -Filter '*.md' | Sort-Object Name) {
            $heading = Get-Content -LiteralPath $contentFile.FullName -TotalCount 8 |
                Where-Object { $_ -match '^#\s+(.+)$' } |
                Select-Object -First 1
            if ($heading -match '^#\s+(.+)$') {
                Add-UniqueItem -List $topics -Seen $seen -Label $Matches[1] -Order $order
                $order++
            }
            if ($topics.Count -ge 30) { break }
        }
    }

    return @($topics | Sort-Object Order, Label | Select-Object -First 30)
}

$officialRoadmapsRoot = Join-Path $OfficialRepository 'src\data\roadmaps'
if (-not (Test-Path -LiteralPath $officialRoadmapsRoot)) {
    throw "Repositório roadmap.sh inválido: $OfficialRepository"
}

$referenceFiles = Get-ChildItem -LiteralPath $RoadmapsRoot -Recurse -File -Filter 'ROADMAP_*.md' |
    Where-Object { $_.FullName -notmatch '\\graphif(y|yy)?-out\\' }

$updated = 0
$skipped = 0
$failed = [System.Collections.Generic.List[string]]::new()

foreach ($file in $referenceFiles) {
    $current = Get-Content -Raw -LiteralPath $file.FullName
    $isPointer = $current -match 'This file is a local reference to the official roadmap'
    $isGenerated = $current -match 'Este documento torna os principais tópicos consultáveis localmente'
    if (-not $Force -and -not $isPointer -and -not $isGenerated) {
        $skipped++
        continue
    }

    $sourceMatch = [regex]::Match($current, 'https://roadmap\.sh/(?<slug>[a-z0-9-]+)')
    if (-not $sourceMatch.Success) {
        $failed.Add("$($file.FullName): URL oficial não encontrada")
        continue
    }

    $slug = $sourceMatch.Groups['slug'].Value
    $roadmapDirectory = Join-Path $officialRoadmapsRoot $slug
    if (-not (Test-Path -LiteralPath $roadmapDirectory)) {
        $failed.Add("$($file.FullName): diretório oficial '$slug' não encontrado")
        continue
    }

    $metaPath = Join-Path $roadmapDirectory "$slug.md"
    if (-not (Test-Path -LiteralPath $metaPath)) {
        $metaPath = Get-ChildItem -LiteralPath $roadmapDirectory -File -Filter '*.md' |
            Where-Object { $_.Name -notmatch '^faq' } |
            Select-Object -ExpandProperty FullName -First 1
    }
    $meta = if ($metaPath) { Get-Content -Raw -LiteralPath $metaPath } else { '' }
    $title = Get-FrontMatterValue -Text $meta -Key 'title'
    if (-not $title) { $title = ($file.BaseName -replace '^ROADMAP_', '' -replace '_', ' ').ToLowerInvariant() }
    $description = Get-FrontMatterValue -Text $meta -Key 'description'
    if (-not $description) { $description = "Referência operacional para desenvolver competência em $title." }

    $category = if ($file.Directory.Name -eq 'Role-based Roadmaps') { 'Role-based' } else { 'Skill-based' }
    $officialUrl = "https://roadmap.sh/$slug"
    $pdfUrl = Get-FrontMatterValue -Text $meta -Key 'pdfUrl'
    if ($pdfUrl -and $pdfUrl.StartsWith('/')) { $pdfUrl = "https://roadmap.sh$pdfUrl" }
    $topics = Get-RoadmapTopics -RoadmapDirectory $roadmapDirectory -Slug $slug
    $resources = Get-OfficialResources -ContentDirectory (Join-Path $roadmapDirectory 'content')

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("# $title — roadmap de referência")
    $lines.Add('')
    $lines.Add("> Fonte oficial principal: [$officialUrl]($officialUrl)")
    $lines.Add('>')
    $lines.Add("> Categoria: $category")
    $lines.Add('>')
    $lines.Add('> Revisão local: 15 de julho de 2026')
    $lines.Add('')
    $lines.Add('---')
    $lines.Add('')
    $lines.Add('## Objetivo')
    $lines.Add('')
    $lines.Add("Desenvolver competência prática em **$title**, dos fundamentos à integração, qualidade e operação.")
    $lines.Add('')
    $lines.Add("Descrição oficial: _$(($description.Trim()) -replace '_', '\_')_")
    $lines.Add('')
    $lines.Add('Este documento torna os principais tópicos consultáveis localmente. A fonte interativa continua sendo usada para acompanhar alterações, relações visuais e novos recursos.')
    $lines.Add('')
    $lines.Add('## Mapa dos tópicos principais')
    $lines.Add('')

    if ($topics.Count -eq 0) {
        $lines.Add('- Fundamentos e vocabulário do domínio.')
        $lines.Add('- Prática orientada a projetos e diagnóstico de falhas.')
        $lines.Add('- Qualidade, segurança, operação e evolução da solução.')
        $lines.Add('')
        $lines.Add('> [DECIDIR] A fonte oficial não expôs tópicos estruturados no repositório consultado; revisar manualmente a página interativa na próxima manutenção.')
    } else {
        foreach ($topic in $topics) {
            $focus = Get-TopicFocus -Topic $topic.Label
            $lines.Add("- **$($topic.Label):** $focus")
        }
    }

    $lines.Add('')
    $lines.Add('## Progressão prática recomendada')
    $lines.Add('')
    $lines.Add('1. **Fundamentos:** dominar o vocabulário, o modelo mental e as ferramentas mínimas do domínio.')
    $lines.Add('2. **Aplicação guiada:** reproduzir exemplos pequenos, documentando entradas, saídas e falhas encontradas.')
    $lines.Add('3. **Integração:** combinar os tópicos principais em uma entrega que dialogue com sistemas, dados ou usuários reais.')
    $lines.Add('4. **Qualidade:** acrescentar testes, segurança, observabilidade, documentação e critérios de manutenção proporcionais ao risco.')
    $lines.Add('5. **Operação e evolução:** medir resultados, revisar trade-offs e registrar decisões que afetem contratos públicos ou arquitetura.')
    $lines.Add('')
    $lines.Add('## Evidências de competência')
    $lines.Add('')
    if ($category -eq 'Role-based') {
        $lines.Add('- Um estudo de caso que conecte objetivos, decisões, implementação e resultados mensuráveis.')
        $lines.Add('- Um projeto integrador com critérios de aceite, riscos, observabilidade e retrospectiva.')
        $lines.Add('- Artefatos adequados ao papel: plano, arquitetura, runbook, dashboard, relatório ou documentação operacional.')
    } else {
        $lines.Add('- Um laboratório mínimo que demonstre os fundamentos sem depender de abstrações desnecessárias.')
        $lines.Add('- Uma integração real ou projeto pequeno com testes automatizados e procedimento reproduzível.')
        $lines.Add('- Um registro de depuração contendo hipótese, evidência, correção e teste de regressão.')
    }
    $lines.Add('')
    $lines.Add('## Decisões sensíveis')
    $lines.Add('')
    $lines.Add('- [DECIDIR] Qual profundidade é necessária para o produto ou função atual; o roadmap não deve ser tratado como checklist universal.')
    $lines.Add('- [DECIDIR] Qual ferramenta concreta será adotada quando existirem alternativas equivalentes; priorizar maturidade, documentação, interoperabilidade e facilidade de depuração.')
    $lines.Add('- [DECIDIR] Quais tópicos exigem prova de conceito antes de entrarem no padrão Correnth.')
    $lines.Add('')
    $lines.Add('## Fontes de pesquisa')
    $lines.Add('')
    $lines.Add("- [roadmap.sh — $title]($officialUrl) — estrutura principal e atualização contínua.")
    if ($pdfUrl) { $lines.Add("- [roadmap.sh — versão PDF]($pdfUrl) — visualização estática do percurso oficial.") }
    $lines.Add('- [Repositório oficial developer-roadmap](https://github.com/kamranahmedse/developer-roadmap) — tópicos, conteúdos e histórico de manutenção da fonte.')
    foreach ($resource in $resources | Select-Object -First 6) {
        $label = if ($resource.Label) { $resource.Label } else { ([uri]$resource.Url).Host }
        $lines.Add("- [$label]($($resource.Url)) — documentação ou referência primária indicada no conteúdo oficial.")
    }
    $lines.Add('')
    $lines.Add('## Manutenção')
    $lines.Add('')
    $lines.Add('- Confirmar periodicamente a data de modificação e os tópicos no roadmap oficial.')
    $lines.Add('- Atualizar este resumo quando a fonte alterar fundamentos, sequência ou recomendações centrais.')
    $lines.Add('- Preservar as fontes por tópico e substituir links descontinuados por documentação primária equivalente.')
    $lines.Add('- Registrar escolhas tecnológicas sensíveis como `[DECIDIR]` até existir decisão canônica.')
    $lines.Add('')

    Set-Content -LiteralPath $file.FullName -Value ($lines -join "`r`n") -Encoding utf8
    $updated++
}

[pscustomobject]@{
    Total = $referenceFiles.Count
    Updated = $updated
    SkippedSubstantive = $skipped
    Failed = $failed.Count
    Failures = @($failed)
} | ConvertTo-Json -Depth 4
