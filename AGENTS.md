# Fenris Partner Portal — Agent Instructions

## What this project is

A lightweight, secure partner portal served by a Cloudflare Worker at `client.gofenris.com`. Partners enter a short code to view a single rendered HTML page summarising their engagement with Fenris. No login, no framework, no database — the Worker fetches markdown files from a private GitHub repo and returns a complete HTML document.

## What to build

The Worker is implemented at `fenris-client-worker/src/index.ts`. The worker directory looks like:

```
fenris-client-worker/
├── wrangler.jsonc
├── package.json
└── src/
    └── index.ts
```

Follow `.llm/IMPLEMENTATION_PLAN.md` for the step-by-step setup (Wrangler, KV, secrets, deployment). Follow `.llm/DESIGN_REFERENCE.md` for all rendering and styling decisions.

## Files to read, in order

| File | What it covers |
| ---- | -------------- |
| `.llm/DESIGN_REFERENCE.md` | **Primary spec. Read this first and treat it as authoritative.** Content model, markdown conventions, frontmatter schema, rendering rules, style reference (colors, typography, CSS). |
| `.llm/IMPLEMENTATION_PLAN.md` | Step-by-step build instructions: Wrangler setup, KV schema, Worker logic phases, deployment, testing checklist. |
| `.llm/DESIGN_SPEC.md` | Human-readable design intent. Read for background and context. Where it conflicts with `DESIGN_REFERENCE.md`, the latter wins. |
| `.llm/fenris_client_pages_vision.md` | Architecture, security model, cost model. Read for background. Not a rendering spec. |

## Example clients (use these for validation)

Two complete example clients live in `.llm/example-client/`. The Worker must render both correctly before the implementation is considered complete.

| Client | Path | Pattern |
| ------ | ---- | ------- |
| Acme Corp | `.llm/example-client/acme/` | Retainer: phases + workstreams + updates |
| Banta NGO | `.llm/example-client/banta/` | Project portfolio: projects + deliverables |

These files are the canonical test cases. If the rendered output for either looks wrong, the implementation is wrong.

## Reference design

A design mockup screenshot is at `.llm/reference-design-image/ss_20260320_01.png`. Read it as a visual reference for layout, component styling, and overall aesthetic — not as a pixel-perfect spec.

The mockup uses illustrative content that does not match the example client files exactly (nav labels, section names, and data values will differ). What it does show reliably: the sticky nav bar structure, the Overview card layout, workstream card treatment with left accent border, the updates timeline, phase table row highlighting, deliverables table, and footer.

## Key constraints

- **No CSS framework.** Use vanilla CSS with an embedded `<style>` block in the Worker's HTML output. See the Style Reference in `DESIGN_REFERENCE.md`.
- **No JavaScript frameworks, no interactive JS.** The page is a static rendered document. Small, self-contained `<script>` blocks are permitted for progressive enhancement (e.g. a ~10-line `IntersectionObserver` for nav highlight on scroll). Any JS must degrade gracefully — the page must be fully readable with JS disabled.
- **No hardcoded section names.** Section nav labels must always be derived from the first `##` in each markdown file.
- **No H1 except from the first file.** Only `01-overview.md` contains an H1; it becomes the page title.
- **Render whatever files exist.** Do not assume a fixed set of section files. Sort by filename; the numeric prefix controls order.
- **Fenris wordmark is text, not an image.** Render "Fenris" in the nav as a styled `<a>` element linking to `https://gofenris.com`, using Manrope bold and `--color-primary`. No logo image file needed. Hidden on mobile.

## Logo and brand assets

Logo image files are in `assets/fenris-design-assets/` but are **not needed** — the nav uses a text wordmark. Brand colors and typography are fully specified in the Style Reference section of `DESIGN_REFERENCE.md`.
