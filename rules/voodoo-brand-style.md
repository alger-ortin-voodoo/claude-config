# Voodoo Visual Brand Style (detail)

> Read this before creating or restyling any **visual document** — slide decks, HTML pages/reports,
> diagrams/SVGs, charts, exported graphics. Apply it by default whenever output is something a person
> *looks at* (not plain code/markdown). Authoritative source: the company brand palette docs
> (main = blue/white/black; secondary = four accent ramps). **The brand is blue, not green** — a stray
> `#158158` in the old PPTX `theme1` is orphaned; ignore it.

## Font — Figtree
Use **Figtree** for everything (headings bold/semibold, body regular). It's a full text family.
- Installed system-wide locally; also a **Google Font** and available **natively in Google Slides**.
- HTML: link it — `https://fonts.googleapis.com/css2?family=Figtree:wght@400;600;700&display=swap`
  (base64-embed only when the doc must render fully offline).
- Decks (pptxgenjs / PowerPoint): `fontFace: "Figtree"` (bold via `bold:true`). Renders natively on
  Google Slides import.

## Main colors
- Voodoo Blue `#0055FF` (primary) · Soft Blue `#E9F3FF` (card/surface tint)
- Cosmos Black `#10131B` (ink / dark surfaces) · White `#FFFFFF`

## Neutral grey ramp (light→dark)
`#F6F7F9` `#ECEEF2` `#DBDEE5` `#B9BFCC` `#9AA1B1` `#7D8598` `#636B7F` `#4A5366` `#353C4C` `#212734` `#10131B` `#000000`

## Blue ramp
`#F4F9FF` `#E9F3FF` `#D2E5FF` `#9FC4FF` `#6AA0FF` `#347BFF` **`#0055FF`** `#004BE0` `#003EBB` `#003091` `#002163` `#001133`
→ text-on-white: `#003EBB`/`#003091` · bright-on-dark: `#6AA0FF`/`#347BFF`

## Secondary accent ramps (key shade in **bold**; darker steps = legible-on-white text)
- **Gold/Yellow**: `#FFFBE6` `#FFF6CD` `#FFED9A` `#FFE05E` `#FFD643` **`#FFCD37`** `#FFC231` `#FEB52E` `#FDA52D` `#FB922C` `#F67E2B` `#ED6B2A` — bright `#FFCD37` on dark; gold has no legible-on-white step (it darkens to orange), so use a darkened gold `~#C08400` for warm text on white.
- **Orange/Coral-red**: `#FFF8F4` `#FFF0E9` `#FFE0D3` `#FFBBA3` `#FF9874` `#FF7445` **`#FF5117`** `#EB3B00` `#D63600` `#C23000` `#AD2B00` `#992600` — text-on-white `#C23000`.
- **Teal/Mint**: `#F0FEFC` `#E0FDF8` `#C2FAF1` `#8EF4E3` `#5BEAD2` `#2BDDC0` **`#00CCAA`** `#00B799` `#009D83` `#007D68` `#00584A` `#00332B` — text-on-white `#007D68`.
- **Magenta/Pink**: `#FFF6FE` `#FFECFC` `#FFD8F9` `#FFAFEC` `#FC87DF` `#F961D3` **`#F53BC7`** `#E01EB0` `#CB059A` `#B60089` `#A10079` `#8C0069` — text-on-white `#B60089`.

## Layout conventions
- Title / section / closing surfaces = full Voodoo-Blue `#0055FF` background, white text, **white** "Voodoo" wordmark bottom-right.
- Content surfaces = white (or Cosmos-Black `#10131B` for dark theme), Figtree headings, blue accents, Soft-Blue `#E9F3FF` cards, **black** wordmark bottom-right.
- Wordmark PNGs (white + black, from the Master Slides deck): `G:\Voodoo\La meva unitat\Tech Docs\Claude Agents Showcase\assets\voodoo-logo-white.png` / `voodoo-logo-black.png`.
- Lead with one accent (blue) + neutrals; bring in mint/gold/coral/pink only to carry distinct roles, not for decoration.

## Workflow
- Build the doc, render it **once** for the user to eyeball, and hand it over. **Do not auto-spawn a
  fresh-eyes QA subagent** — the user prefers to review renders themselves (it's faster). Self-check
  for obvious breakage only.

First applied on the "Agentic Workflow" deck (see the `project-agentic-deck-voodoo` memory).
