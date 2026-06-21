---
name: ""
metadata: 
  node_type: memory
  originSessionId: 04958ede-6e6b-458d-8158-5620d7e697d1
---

The "Agentic Workflow" talk deck (10 slides, pptxgenjs, LAYOUT_WIDE 13.33×7.5), styled to the Voodoo brand. The branded version is now **the** presentation — the old violet/teal variant and the `-voodoo` suffixed files were retired (consolidated 2026-06-12).

- **Build script**: `%TEMP%\agentic-deck\build.js` (deps `pptxgenjs`+`sharp` in `%TEMP%\agentic-deck\node_modules`; run `node build.js` from that dir). Source-of-truth copy: `G:\Voodoo\La meva unitat\Tech Docs\agentic-deck-build.js`.
- **Assets** (`…\Claude Agents Showcase\assets\`): `workflow-diagram.svg`, `commit-preparer-usage-curve.svg` (brand-recolored), rasterized with sharp to `diagram.png`/`curve.png`; plus `voodoo-logo-white/black.png`.
- **Output**: `…\Claude Agents Showcase\agentic-workflow.pptx`.
- **Style**: follows `~/.claude/rules/voodoo-brand-style.md` — Figtree font, Voodoo Blue `#0055FF` + Soft Blue cards + Cosmos Black ink, accents mint/gold/coral/pink. Role→color map: blue = Opus review agents, mint = Sonnet/commit, pink = debug-investigator (off-loop), gold = /next-steps, coral = dropped/cut.
- Known non-issue: slide 7's embedded diagram has small sub-labels (its own internal title + padding); user reviewed and chose to leave it as-is.
