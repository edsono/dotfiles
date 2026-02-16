---
name: web-urls-state
description: URL and navigation state rules for web apps in this repo. Use when designing routes, links, filters, pagination, or view flows tied to URL state.
---

# URL and Navigation State

## URL Structure
- Path encodes resource and hierarchy.
- Query encodes options (e.g., filters, sorting, pagination).
- Fragment encodes local in-page navigation.
- Defaults must be omitted from the URL; the UI assumes defaults.
- Never place sensitive data in URLs (PII, tokens, large blobs, JSON/base64).

## Slug Stability
- Slugs must be stable, readable, and unique.
- Do not change slugs after publication.

## Django Links and Redirects
- Use `{% url %}` for internal links (avoid hardcoded paths).
- Prefer `RedirectView` with `pattern_name` or `reverse()`.

## View Error Handling
- Do not catch generic exceptions just to relog them.
