---
name: feedback-multi-action-approval
description: "When one message offers multiple actions, a brief \"yes\" reply is ambiguous — execute one at a time, lower-risk first, and re-confirm irreversible ones"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8d7b11be-e252-4cd8-a87b-283b6b745a50
---

When a single message offers more than one action (e.g., "Here's a commit preview… also want me to update the Notion page?"), a brief affirmative ("yes please", "go ahead", "sure") is ambiguous about scope. Resolve toward the less risky action: run the reversible / lower-impact one immediately (file edit, Notion page update, clipboard copy), and re-confirm before executing irreversible or hard-to-undo actions (commits, pushes, deletes, branch switches with dirty trees).

**Why:** I once read "love it! yes please, update the notion page as well" as approval for both a commit preview AND a Notion edit. The user only meant the Notion edit — they wanted to test the change first and then commit it on a different branch. Undoing the commit with `git reset HEAD~1` was painless, but the principle holds: irreversible actions deserve their own dedicated approval, even when the user is friendly and the previous step was approved.

**How to apply:** When proposing N actions in one message and getting a generic affirmative, pick the safest action to run immediately and explicitly confirm the others before proceeding. If unsure: name the action in a one-line follow-up ("Updating Notion now — should I also run the commit?") rather than executing both in parallel. See also [[feedback-commit-timing]].
