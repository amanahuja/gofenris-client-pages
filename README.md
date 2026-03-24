# Fenris Partner Portal

A lightweight, secure portal that gives Fenris partners a single rendered page summarising their engagement. Partners enter a short code to access their page — no login, no account required.

The portal is served by a Cloudflare Worker. It validates the partner code against a KV store, fetches markdown content files from a private GitHub repository, and returns a fully rendered HTML page. Content updates are made by editing markdown files and pushing to GitHub — no redeployment needed.
