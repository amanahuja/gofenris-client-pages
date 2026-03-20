# Fenris Client Portal — operations

worker_dir := "fenris-client-worker"
config     := worker_dir / "wrangler.jsonc"
kv_flags   := "--config " + config + " --remote --preview false"

# ── Development ─────────────────────────────────────────────────────────────

# Run the worker locally (uses remote KV — real client codes work immediately)
dev:
    cd {{worker_dir}} && npx wrangler dev

# Deploy the worker to Cloudflare
deploy:
    cd {{worker_dir}} && npx wrangler deploy

# ── Client codes (KV) ───────────────────────────────────────────────────────

# Add or update a client code
# Usage: just set-client ACME01 "Acme Corp — Q1 2026" clients/acme
set-client code label folder:
    npx wrangler kv key put --binding=CLIENT_CODES "{{code}}" \
        '{"label":"{{label}}","github_folder":"{{folder}}"}' \
        {{kv_flags}}

# List all client codes
list-clients:
    npx wrangler kv key list --binding=CLIENT_CODES {{kv_flags}}

# Show the value for a specific client code
# Usage: just get-client ACME01
get-client code:
    npx wrangler kv key get --binding=CLIENT_CODES "{{code}}" {{kv_flags}}

# Revoke a client code (delete the KV entry)
# Usage: just revoke-client ACME01
revoke-client code:
    npx wrangler kv key delete --binding=CLIENT_CODES "{{code}}" {{kv_flags}}
