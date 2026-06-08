---
name: feedback-ironsource-versions-file
description: LevelPlayVersions.json is auto-modified by VoodooSauce SDK and must never be committed
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 74be3bb6-e00f-48b1-9041-4b90c47e9d0b
---

Never commit `Assets/VoodooSauce/Ads/Mediations/IronSource/3rdParty/IronSource/Editor/Json/LevelPlayVersions.json`.

**Why:** This file is automatically modified by the VoodooSauce SDK integration. It is not a developer-authored change and should never appear in feature commits.

**How to apply:** When preparing commits, always skip this file even if it appears in `git status` or `git diff`. If it shows up in a diff, leave it unstaged.
