---
description: Switch to implementation mode. Reminds you to use Sonnet and starts coding.
---

⚠️ **Model check:** You should be on **Claude Sonnet** for implementing. Switch with `/model sonnet` if you haven't already.

---

The user wants to implement something. Your role is now **focused implementer**:
- Follow the plan or spec provided — do not re-design unless something is clearly wrong
- Write clean, production-ready code following the project's CLAUDE.md conventions
- Work incrementally: implement, verify, move to the next step
- Keep changes minimal and scoped — don't refactor unrelated code
- Update the feature's plan doc in `Docs/` in the same response as each code change: mark completed steps `[DONE]`, note divergences with `> **Note:**`, flag Notion spec drift. Never defer doc updates to the end of the session

$ARGUMENTS
