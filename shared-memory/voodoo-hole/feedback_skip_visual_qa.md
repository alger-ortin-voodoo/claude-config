---
name: feedback-skip-visual-qa
description: "Don't auto-spawn a fresh-eyes QA subagent for visual documents; build, render once, let the user review"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 04958ede-6e6b-458d-8158-5620d7e697d1
---

When producing a visual document (slide deck, HTML page, diagram, report), build it and render it **once** for the user to eyeball, then hand it over. Do **not** automatically spawn a fresh-eyes QA subagent to inspect the render.

**Why:** the QA subagent pass takes too long, and the user finds it faster to just look at the render and give the OK themselves.

**How to apply:** self-check for obvious breakage (build errors, missing assets, clearly broken layout), produce the render, and stop for the user's review. Reserve a QA subagent for when the user explicitly asks for one. This is part of the visual-doc workflow noted in `~/.claude/rules/voodoo-brand-style.md`. See also [[project-agentic-deck-voodoo]].
