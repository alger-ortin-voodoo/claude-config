---
name: Feedback: README / Markdown Doc Style
description: User preferences for README layout and image handling established during UITable documentation
type: feedback
---

Size images individually based on their content type — don't apply a uniform width. Reference sizes from UITable docs:
- Narrow panel / tree view (hierarchy): ~250px
- Inspector panel: ~500px
- Full-width preview / scene shot: ~300px

**Why:** A uniform 720px made all images look oversized; native proportions per image type read better.

**How to apply:** Use `<img src="..." width="X" />` with a width suited to the content, not a blanket cap.

---

Omit `---` horizontal dividers between sections when using H2/H3 headings. GitHub and VS Code render a visual rule below H1 and H2 automatically, so explicit dividers are redundant noise.

**Why:** User removed them explicitly — headers already provide enough visual separation.

**How to apply:** Skip `---` in README files unless genuinely needed (e.g. after a preamble before the first heading).

---

Place section screenshots at the **end** of their section, after the descriptive text and tables. Not at the top or inline mid-paragraph.

**Why:** User moved them there — text introduces the concept, screenshot confirms it visually.
