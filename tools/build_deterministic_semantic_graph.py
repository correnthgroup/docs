"""Build a complete, auditable semantic index when remote LLM extraction is unavailable.

The output follows Graphify's node-link JSON contract. Relations come from document
structure, explicit Markdown links, controlled concepts, and TF-IDF similarity. Every
inferred edge carries its method and score; source documents remain the truth.
"""

from __future__ import annotations

import hashlib
import html
import json
import math
import re
import sys
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlparse

import networkx as nx
from networkx.algorithms.community import greedy_modularity_communities


EXCLUDED_PARTS = {
    ".git",
    ".graphify-quarantine",
    "graphify-out",
    "graphiy-out",
    "node_modules",
    ".next",
}

STOPWORDS = {
    "a", "ao", "aos", "as", "com", "como", "da", "das", "de", "do", "dos",
    "e", "em", "entre", "essa", "esse", "esta", "este", "foi", "mais", "na",
    "nas", "no", "nos", "o", "os", "ou", "para", "por", "que", "se", "sem",
    "ser", "sua", "suas", "um", "uma", "the", "and", "for", "from", "into",
    "of", "on", "or", "to", "with", "is", "are", "be", "this", "that", "using",
    "roadmap", "reference", "referencia", "fonte", "fontes", "pesquisa", "oficial",
    "https", "http", "www", "com", "org", "md",
}

CONCEPTS = {
    "Correnth UI": ["@correnth/ui", "correnth-ui", "shadcn", "tailwind"],
    "Shared Context Memory": ["shared context memory", "context memory", "context pack", "memoria compartilhada"],
    "Graphify": ["graphify", "graph.json", "semantic graph", "grafo semantico"],
    "Paperclip Operations": ["paperclip", "zero humans", "hitl"],
    "Supabase Platform": ["supabase", "postgresql", "pgvector", "rls"],
    "Correnth Ecosystem": ["redrose", "redrise", "findfee", "adgency", "gauss", "grupo correnth"],
    "AI Agents": ["ai agents", "agentes de ia", "agentic", "llm", "mcp"],
    "Product Governance": ["prd vigente", "direcao operacional", "contratos publicos", "migrations", "codigo/testes"],
    "Quality Engineering": ["playwright", "vitest", "quality assurance", "qa", "testes automatizados"],
    "Application Architecture": ["next.js", "react", "typescript", "react flow", "tanstack table"],
}


def slug(value: str) -> str:
    value = value.lower().replace("\\", "/")
    value = re.sub(r"[^a-z0-9áàâãéèêíïóôõöúçñ/_-]+", "-", value)
    return re.sub(r"-+", "-", value).strip("-/")


def plain(value: str) -> str:
    value = re.sub(r"<[^>]+>", "", value)
    value = re.sub(r"\[([^\]]+)\]\([^\)]+\)", r"\1", value)
    value = re.sub(r"[*_`>#]", "", value)
    return re.sub(r"\s+", " ", value).strip()


def tokenize(text: str) -> list[str]:
    text = text.lower()
    text = re.sub(r"https?://\S+", " ", text)
    words = re.findall(r"[a-záàâãéèêíïóôõöúçñ][a-z0-9áàâãéèêíïóôõöúçñ+.#/-]{2,}", text)
    return [w.strip("./-") for w in words if w.strip("./-") not in STOPWORDS]


def add_edge(edges: list[dict], seen: set[tuple[str, str]], source: str, target: str,
             relation: str, **attrs: object) -> None:
    if not source or not target or source == target:
        return
    # graph.json declares a simple graph, so one unordered node pair may have only
    # one edge. Keeping relation in this key would make payload links disagree with
    # NetworkX/report counts when two extraction methods discover the same pair.
    key = (min(source, target), max(source, target))
    if key in seen:
        return
    seen.add(key)
    edge = {"source": source, "target": target, "relation": relation, **attrs}
    edges.append(edge)


def main(root_arg: str) -> int:
    root = Path(root_arg).resolve()
    out = root / "graphify-out"
    out.mkdir(parents=True, exist_ok=True)

    files = sorted(
        p for p in root.rglob("*.md")
        if not any(part in EXCLUDED_PARTS for part in p.relative_to(root).parts)
    )
    if not files:
        raise SystemExit("No Markdown files found")

    nodes: dict[str, dict] = {}
    edges: list[dict] = []
    edge_seen: set[tuple[str, str]] = set()
    doc_ids: dict[Path, str] = {}
    doc_texts: dict[str, str] = {}
    doc_terms: dict[str, Counter[str]] = {}
    link_queue: list[tuple[str, Path, str, int]] = []
    manifest: dict[str, dict] = {}

    for path in files:
        rel = path.relative_to(root).as_posix()
        raw = path.read_text(encoding="utf-8-sig", errors="replace")
        lines = raw.splitlines()
        first_heading = next((plain(m.group(2)) for line in lines if (m := re.match(r"^(#{1,3})\s+(.+)$", line))), path.stem)
        doc_id = f"doc:{slug(rel)}"
        doc_ids[path.resolve()] = doc_id
        doc_texts[doc_id] = raw
        doc_terms[doc_id] = Counter(tokenize(raw))
        stat = path.stat()
        manifest[rel] = {
            "size": stat.st_size,
            "mtime_ns": stat.st_mtime_ns,
            "sha256": hashlib.sha256(raw.encode("utf-8")).hexdigest(),
        }
        nodes[doc_id] = {
            "id": doc_id,
            "label": first_heading,
            "file_type": "document",
            "node_kind": "document",
            "source_file": rel,
            "source_location": "L1",
            "_origin": "deterministic-semantic",
            "word_count": len(tokenize(raw)),
        }

        heading_stack: list[tuple[int, str]] = []
        used_heading_ids: Counter[str] = Counter()
        for line_no, line in enumerate(lines, start=1):
            heading = re.match(r"^(#{1,3})\s+(.+?)\s*$", line)
            if heading:
                level = len(heading.group(1))
                label = plain(heading.group(2))
                if not label:
                    continue
                base = f"section:{slug(rel)}:{slug(label)}"
                used_heading_ids[base] += 1
                section_id = base if used_heading_ids[base] == 1 else f"{base}-{used_heading_ids[base]}"
                nodes[section_id] = {
                    "id": section_id,
                    "label": label,
                    "file_type": "document-section",
                    "node_kind": "section",
                    "heading_level": level,
                    "source_file": rel,
                    "source_location": f"L{line_no}",
                    "_origin": "extracted-structure",
                }
                add_edge(edges, edge_seen, doc_id, section_id, "contains",
                         confidence="EXTRACTED", confidence_score=1.0, weight=1.0,
                         source_file=rel, source_location=f"L{line_no}")
                while heading_stack and heading_stack[-1][0] >= level:
                    heading_stack.pop()
                if heading_stack:
                    add_edge(edges, edge_seen, heading_stack[-1][1], section_id, "precedes_or_contains",
                             confidence="EXTRACTED", confidence_score=1.0, weight=1.0,
                             source_file=rel, source_location=f"L{line_no}")
                heading_stack.append((level, section_id))

            for match in re.finditer(r"\[[^\]]+\]\(([^\)]+\.md(?:#[^\s\)]*)?)\)", line, flags=re.I):
                link_queue.append((doc_id, path, match.group(1), line_no))

        for concept, phrases in CONCEPTS.items():
            lowered = raw.lower()
            hits = sum(lowered.count(phrase.lower()) for phrase in phrases)
            if not hits:
                continue
            concept_id = f"concept:{slug(concept)}"
            nodes.setdefault(concept_id, {
                "id": concept_id,
                "label": concept,
                "file_type": "concept",
                "node_kind": "concept",
                "source_file": rel,
                "source_location": "derived from controlled vocabulary",
                "_origin": "deterministic-semantic",
            })
            add_edge(edges, edge_seen, doc_id, concept_id, "mentions_concept",
                     confidence="INFERRED", confidence_score=min(0.99, 0.65 + 0.04 * hits),
                     weight=min(5.0, 1.0 + math.log1p(hits)), method="controlled-vocabulary",
                     source_file=rel, source_location="document")

    for source_id, source_path, target_raw, line_no in link_queue:
        target_part = target_raw.split("#", 1)[0]
        target_path = (source_path.parent / target_part).resolve()
        target_id = doc_ids.get(target_path)
        if target_id:
            add_edge(edges, edge_seen, source_id, target_id, "references",
                     confidence="EXTRACTED", confidence_score=1.0, weight=2.0,
                     source_file=source_path.relative_to(root).as_posix(), source_location=f"L{line_no}")

    # TF-IDF semantic similarity between whole documents. Only top three neighbors
    # over the threshold are kept, avoiding a dense and misleading similarity mesh.
    document_frequency: Counter[str] = Counter()
    for terms in doc_terms.values():
        document_frequency.update(terms.keys())
    document_count = len(doc_terms)
    vectors: dict[str, dict[str, float]] = {}
    norms: dict[str, float] = {}
    for doc_id, terms in doc_terms.items():
        total = max(1, sum(terms.values()))
        vector = {
            term: (count / total) * (math.log((document_count + 1) / (document_frequency[term] + 1)) + 1)
            for term, count in terms.items() if document_frequency[term] <= document_count * 0.8
        }
        vectors[doc_id] = vector
        norms[doc_id] = math.sqrt(sum(value * value for value in vector.values())) or 1.0

    doc_list = list(doc_terms)
    candidates: dict[str, list[tuple[float, str]]] = defaultdict(list)
    for index, left in enumerate(doc_list):
        left_vector = vectors[left]
        for right in doc_list[index + 1:]:
            right_vector = vectors[right]
            small, large = (left_vector, right_vector) if len(left_vector) < len(right_vector) else (right_vector, left_vector)
            dot = sum(value * large.get(term, 0.0) for term, value in small.items())
            score = dot / (norms[left] * norms[right])
            if score >= 0.16:
                candidates[left].append((score, right))
                candidates[right].append((score, left))
    for left, ranked in candidates.items():
        for score, right in sorted(ranked, reverse=True)[:3]:
            add_edge(edges, edge_seen, left, right, "semantic_similarity",
                     confidence="INFERRED", confidence_score=round(score, 4),
                     weight=round(1.0 + score * 4.0, 4), method="tf-idf-cosine",
                     source_file=nodes[left]["source_file"], source_location="document-level")

    graph = nx.Graph()
    for node_id, attrs in nodes.items():
        graph.add_node(node_id, **attrs)
    for edge in edges:
        graph.add_edge(edge["source"], edge["target"], **{k: v for k, v in edge.items() if k not in {"source", "target"}})

    communities = list(greedy_modularity_communities(graph, weight="weight")) if graph.number_of_edges() else [set(graph.nodes)]
    community_names: dict[int, str] = {}
    for community_id, members in enumerate(communities):
        labels = [nodes[node]["label"] for node in members if nodes[node].get("node_kind") in {"document", "concept"}]
        name = " / ".join(labels[:2]) if labels else f"Community {community_id}"
        community_names[community_id] = name[:80]
        for node_id in members:
            nodes[node_id]["community"] = community_id
            nodes[node_id]["community_name"] = community_names[community_id]

    links = []
    for edge in edges:
        links.append(edge)
    graph_payload = {
        "directed": False,
        "multigraph": False,
        "graph": {
            "root": str(root),
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "extraction_mode": "deterministic-semantic-fallback",
            "source_of_truth": "original files",
        },
        "nodes": list(nodes.values()),
        "links": links,
        "hyperedges": [],
    }
    (out / "graph.json").write_text(json.dumps(graph_payload, ensure_ascii=False, indent=2), encoding="utf-8")
    (out / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    (out / ".graphify_root").write_text(str(root), encoding="utf-8")

    degrees = sorted(graph.degree(weight="weight"), key=lambda item: item[1], reverse=True)
    relation_counts = Counter(edge["relation"] for edge in edges)
    report = [
        "# Graphify — deterministic semantic audit report",
        "",
        f"> Generated: {datetime.now(timezone.utc).isoformat()}",
        "> Mode: deterministic semantic fallback (Markdown structure + links + controlled concepts + TF-IDF).",
        "> The graph is a discovery index; original files are the source of truth.",
        "",
        "## Corpus and integrity",
        "",
        f"- Source Markdown files: **{len(files)}**",
        f"- Nodes: **{graph.number_of_nodes()}**",
        f"- Edges: **{graph.number_of_edges()}**",
        f"- Communities: **{len(communities)}**",
        f"- Self-loops: **{nx.number_of_selfloops(graph)}**",
        f"- Connected components: **{nx.number_connected_components(graph)}**",
        f"- Manifest entries: **{len(manifest)}**",
        "",
        "## Relation coverage",
        "",
    ]
    report.extend(f"- `{relation}`: {count}" for relation, count in sorted(relation_counts.items()))
    report.extend(["", "## God Nodes", ""])
    for node_id, score in degrees[:12]:
        report.append(f"- **{nodes[node_id]['label']}** — weighted degree {score:.2f}; `{node_id}`")
    report.extend(["", "## Communities", ""])
    for community_id, members in enumerate(communities):
        report.append(f"- **{community_names[community_id]}** — {len(members)} nodes")
    report.extend([
        "",
        "## Surprising Connections",
        "",
        "- Semantic similarity edges connect documents only when TF-IDF cosine similarity is at least 0.16; each document keeps at most three strongest neighbors.",
        "- Controlled concept nodes expose cross-domain bridges such as UI, shared context memory, Graphify, Supabase, Paperclip operations and the Correnth ecosystem.",
        "- Explicit Markdown references remain distinguishable from inferred semantic relations through `confidence` and `method` metadata.",
        "",
        "## Suggested Questions",
        "",
        "- Which roadmaps share the strongest semantic relationship with the Correnth stack decision?",
        "- Which documents define Shared Context Memory and how do they connect to Graphify?",
        "- Which product documents mention Paperclip operations and HITL governance?",
        "- Which roadmap topics bridge application architecture, quality engineering and Supabase?",
        "",
        "## Limitations",
        "",
        "- This fallback does not claim LLM-extracted causality or intent.",
        "- `semantic_similarity` is lexical TF-IDF similarity and is explicitly marked `INFERRED`.",
        "- Re-run the central semantic wrapper when provider capacity is available; do not merge partial remote extractions into this graph.",
        "",
    ])
    (out / "GRAPH_REPORT.md").write_text("\n".join(report), encoding="utf-8")

    # Lightweight standalone visualization; nodes are searchable and all raw data
    # remains in graph.json for Graphify query/path/explain tooling.
    html_payload = html.escape(json.dumps({
        "nodes": graph.number_of_nodes(), "edges": graph.number_of_edges(),
        "communities": len(communities), "relations": relation_counts,
    }, ensure_ascii=False, indent=2))
    html_doc = f"""<!doctype html><html><head><meta charset='utf-8'><title>Correnth semantic graph</title>
<style>body{{font:16px system-ui;max-width:960px;margin:48px auto;padding:0 24px;background:#0b1020;color:#e8ecf4}}pre{{background:#151c31;padding:20px;border-radius:12px;overflow:auto}}a{{color:#8ab4ff}}</style></head>
<body><h1>Correnth semantic graph</h1><p>Auditable deterministic fallback. Query the canonical <code>graph.json</code> with Graphify.</p><pre>{html_payload}</pre><p><a href='graph.json'>Open graph.json</a> · <a href='GRAPH_REPORT.md'>Open report</a></p></body></html>"""
    (out / "graph.html").write_text(html_doc, encoding="utf-8")

    print(json.dumps({
        "files": len(files), "nodes": graph.number_of_nodes(), "edges": graph.number_of_edges(),
        "communities": len(communities), "manifest": len(manifest),
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: build_deterministic_semantic_graph.py <root>")
    raise SystemExit(main(sys.argv[1]))
