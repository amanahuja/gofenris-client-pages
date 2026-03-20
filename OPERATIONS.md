# Fenris Client Portal — Operations Reference

## Development & deployment

```bash
just dev       # run worker locally at localhost:8787 (uses live KV — real codes work)
just deploy    # deploy to Cloudflare
```

---

## Managing client codes

Client codes are stored in Cloudflare KV (`CLIENT_CODES` namespace). Each entry maps a short code to a GitHub folder path.

KV value format:
```json
{ "label": "Acme Corp — Q1 2026", "github_folder": "clients/acme" }
```

### Add a new client

**Step 1 — Create the content folder in `gofenris/fenris-clients`:**

```
clients/
  <slug>/
    01-overview.md      ← required; contains YAML frontmatter + H1 + ## Overview
    02-<section>.md     ← optional; one ## heading per file, numeric prefix controls order
    ...
```

Frontmatter schema for `01-overview.md`:
```yaml
---
type: Retainer
timeline: Jan 2026 – Present
funder_chain: Funder → Client → Fenris
summary: One sentence describing the engagement.
team:
  - name: Name
    role: Role
---

# Client Name — Engagement Title

## Overview

Narrative paragraph.
```

**Step 2 — Add the KV entry:**

```bash
just set-client ACME01 "Acme Corp — Q1 2026" clients/acme
```

**Step 3 — Share the code with the client.**

---

### Edit a client code (change label or folder)

Re-run `set-client` with the same code — it overwrites the existing entry:

```bash
just set-client ACME01 "Acme Corp — Q2 2026" clients/acme
```

To edit via the Cloudflare dashboard: Workers & Pages → KV → `CLIENT_CODES` namespace → edit the key.

---

### Revoke a client code

```bash
just revoke-client ACME01
```

Access is blocked immediately. Optionally archive or delete `clients/acme/` in the content repo.

---

### List all active codes

```bash
just list-clients
```

### Inspect a specific code

```bash
just get-client ACME01
```

---

## Updating client content

Edit markdown files in `gofenris/fenris-clients` and push. Changes are live immediately — no Worker redeployment needed.

```bash
# In your local clone of gofenris/fenris-clients:
git add . && git commit -m "Update Acme Q2 content" && git push
```

---

## Raw wrangler commands (without just)

If `just` isn't available, all operations use this pattern:

```bash
npx wrangler kv key put --binding=CLIENT_CODES "<CODE>" \
  '{"label":"...","github_folder":"clients/<slug>"}' \
  --config fenris-client-worker/wrangler.jsonc --remote --preview false

npx wrangler kv key delete --binding=CLIENT_CODES "<CODE>" \
  --config fenris-client-worker/wrangler.jsonc --remote --preview false

npx wrangler kv key list --binding=CLIENT_CODES \
  --config fenris-client-worker/wrangler.jsonc --remote --preview false
```

> `--remote --preview false` is required because the KV namespace has both a production `id` and a `preview_id` configured.
