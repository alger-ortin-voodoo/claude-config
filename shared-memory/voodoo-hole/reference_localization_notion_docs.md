---
name: reference-localization-notion-docs
description: Notion page URLs for the published Localization team docs (main TDD + 6 subpages); Notion is the source of truth (local drafts were removed).
metadata: 
  node_type: memory
  type: reference
  originSessionId: a3aa16b4-d96c-4db4-92de-5448d15e262c
---

The Localization Tech Doc in Notion was reimagined for the Unity Localization migration (2026-06-19). Main page rewritten in place + 6 child subpages.

- **Main — 🔤 Localization:** https://app.notion.com/p/112a0b481db48060ae45e7b97156ace0
- **How-to: Add or update a localization key:** https://app.notion.com/p/384a0b481db48145b77fce33becc3e93
- **How-to: Pull & commit localization tables:** https://app.notion.com/p/384a0b481db481a288a4fa86a0e42029
- **How-to: Add a new language:** https://app.notion.com/p/384a0b481db481cebc92e3c45ac88a35
- **Migration caveats:** https://app.notion.com/p/384a0b481db481acb13bf9d7a8d183c1
- **Under the hood — systems & tools:** https://app.notion.com/p/384a0b481db481c894edfd74a16f2fd3
- **Font replacement & memory:** https://app.notion.com/p/384a0b481db4817c9899eb11094ab7b7
- **Tech Assessment (pre-existing child, preserved):** https://app.notion.com/p/372a0b481db481d2bcd3c5b70b5d56b5

**Notion is the source of truth** — the local `.md` drafts were removed (2026-06-19); iterate **directly in the Notion pages** above (fetch/update via the URLs), no local markdown mirror. The only local file left is `Docs/UI/Systems/Localization/Notion/screenshot_checklist.html` — an interactive tracker for the screenshots still to be added (personal reference, never commit, like [[feedback_html_plan_exports]]).

Related: [[project_localization_system_agnostic]], [[reference_voodootune_cache_refresh]] (the `EnabledLanguages` / `LanguageSelectionEnabled` remote-config edits need Publish + Cache Production Data). Pseudo-localization was descoped (not implemented); the docs reflect that.
