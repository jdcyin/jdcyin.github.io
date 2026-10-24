# CLAUDE.md

Personal website for Jason D.C. Yin (jasonyin.com). Jekyll 3 site on the Hydejack theme, deployed by GitHub Pages from `master` of `jdcyin/jdcyin.github.io` (`netlify.toml` is unused).

## Working rules

- **File/folder changes are fine.** Go ahead and edit, add, rename, or delete content files and folders without asking first.
- **Design changes must be flagged.** Anything that changes how the site looks (fonts, colors, layout, spacing, new page structures) — say so explicitly before or as you make it.
- **Always show a local preview before pushing.** Never commit/push a design change until it has been built locally and Jason has seen it. Push only when asked.

## Site structure

| Sidebar tab | Source | Notes |
|---|---|---|
| Home | `index.md` (layout `page`) | Intro text; sidebar stays visible (no full-screen cover) |
| Academia | `academia.md` + `_academia/*.md` / `*.html` | "Research projects" tile grid, then a Presentations list from `_data/academia_presentations.yml` |
| The Economist | `theeconomist.md` + `_theeconomist/*.md` | Tile grid of publications, then a "Presentations & moderations" list from `_data/theeconomist_presentations.yml` |
| AlriteAlready! | `alritealready.md` + `_projects/*.md` | Page titled ALRITE ALREADY!: link to alritealready.com, then one tile per site (BeenAlready, SeenAlready, SpreadAlready) |

- Sidebar menu is defined in `_config.yml` under `menu:`.
- ReadAlready (`readalready/`, `_posts/`, `_featured_*`) is **off the sidebar** but stays in the repo as the general blog; it will be moved onto another feature later. Don't delete it.
- The page lives at `/alrite-already/` (with a hyphen) because `jasonyin.com/alritealready/` is taken by the separate `jdcyin/alritealready` GitHub Pages repo, which redirects to alritealready.com. Don't name a page path after any of your other repos (beenalready, seenalready, spreadalready, alritealready). `/projects/` (old "Personal Projects" URL) redirects to `/alrite-already/`.

### Adding a tile (Academia or The Economist)

Create `_academia/<slug>.md` or `_theeconomist/<client>_<slug>.md`:

```yaml
---
layout: project
title: 'Title'
caption: One-line subtitle shown on the tile
description: >
  Optional longer description
date: 05 Mar 2025          # tiles are sorted newest first
image: /assets/img/<collection>/<slug>.jpg   # 16:9
links:
  - title: LINK
    url: https://...
sitemap: false
---
Body text shown on the project page.
```

### Adding a presentation (Academia or The Economist)

Add an entry to `_data/academia_presentations.yml` or `_data/theeconomist_presentations.yml` (newest first; a page hides the section while its list is empty): `title`, plus any of `date`, `event`, `hosts`, `location`, `role`, `url`, `description`; missing fields are just left out. With a `description`, the title becomes clickable and opens a popup (`#_talkDialog` in `_includes/my-body.html`, script in `assets/js/site-extras.js`) showing the title and description. Keep `description` to one short sentence (Jason prefers brief); the original agenda text can go in `description_full`, which is kept for reference and not shown. Wrap descriptions in double quotes and escape any inner `"`. Layout: title | location on top, date · event · with hosts | role underneath. The heading has an All / Moderator / Speaker filter driven by `role` (panellist, speaker and presenter count as Speaker).

## Typography / styling

- Font: **JetBrains Mono** everywhere (body, headings, code), matching the footer text on pablogguz.github.io. **Self-hosted** in `assets/fonts/` with `@font-face` in `_includes/my-head.html` (no Google Fonts), so it never falls back to another font. Earlier tries: Inter (original), Newsreader serif.
- Sidebar is **static** (`no_drawer: true`, no menu button). On narrow screens it becomes a compact header above the content (CSS in `_sass/my-inline.scss`). Sidebar width is 18rem (`sidebar_width` in `_data/variables.yml`) and stays fixed on wide screens. On phones it is a thin banner pinned to the top while scrolling (fixed, 5.25rem tall; `#_main` is padded to match): full-height photo on the left, name with email/LinkedIn icons beside it (left-aligned, vertically centered), the three links stacked on the right (pablogguz.github.io style).
- Footer copyright: `copyright` in `_config.yml` uses a `%YEAR%` token that `_includes/body/footer.html` replaces with the build year, so it updates on every deploy.
- Sidebar social icons: email (opens a centered popup with a Copy button; markup in `_includes/my-body.html`) and LinkedIn (new tab), set under `author1.social` in `_data/authors.yml`.
- No sidebar tagline (`tagline` is commented out in `_config.yml`; `_includes/body/sidebar-sticky.html` no longer falls back to the site description).
- Sidebar background is art deco, not a photo (`accent_image: none`): gold `assets/img/deco-fret.svg` (Shanghai deco key-fret lattice) on deep jade, with one stationary glow behind the portrait that slowly brightens and dims. A script in `assets/js/site-extras.js` also lights individual 回 tiles (`assets/img/deco-fret-light.svg`) one at a time in random order, so every tile gets a turn per round. The tile styles (`.deco-light`) must stay in the inlined `_sass/my-inline.scss`: in the async stylesheet the tiles start visible and all flash on at page load. The script re-measures on `load`. The pattern sits at `background-position: 0 0` so the lights line up; keep the two in sync. Defined in `_sass/my-inline.scss`; static for reduced-motion users.
- Section headings on the tile pages (`.layout-projects h2`: Publications, Presentations & moderations, Research projects) are bold gold (`#e6cf95`) with a short gold rule underneath. The theme's `#` heading permalinks are hidden (`.permalink`).
- Popups (`<dialog>`) need `dialog:not([open]) { display: none !important; }` (in `my-inline.scss`): the theme's reboot CSS forces `dialog { display: block }`, which drew closed popups below the footer as a thin gold line.
- Palette: deep jade `#0b2a33` / `#051217`, gold `#c9a961` (lines, borders), light gold `#e6cf95` (headings, highlights). Popups reuse `.email-dialog` styling.
- Page transitions: `duration` on `<hy-push-state>` in `_includes/body/index.html` (250ms) sets the tile-thumbnail fly-in and page fades. After landing, the theme fades the flown thumbnail out over a hard-coded `{duration:200}` (was 500) in `assets/js/push-state-hydejack-9.0.5.js` and its `LEGACY-` twin; it also waits for the new page's lead image to load, so large tile images make the hand-off slower. Tiles for `scrolly: true` pages skip the fly-in (`_includes/pro/project-card.html`).
- **Sass gotcha:** the site's old Sass compiler tries to evaluate `min()`, `max()` and `clamp()` and fails on mixed units (e.g. `vw` with `rem`), which breaks the whole build. Wrap such values in `unquote("...")`, or put them in a CSS custom property.
- Custom CSS overrides go in `_sass/my-inline.scss` (above-the-fold, inlined) and `_sass/my-style.scss`. Avoid editing theme files in `_sass/hydejack`, `_sass/pooleparty`, `_includes`, `_layouts` unless needed.
- `#jekyll-theme-hydejack/` is a vendored copy of the theme — reference only, not used in the build.

## Local preview

Ruby lives at `C:\Ruby33-x64\bin` (not on PATH by default). Building directly inside Google Drive is very slow (~8 min), so mirror the source to a local folder first and build there:

```bash
export PATH=/c/Ruby33-x64/bin:$PATH
# from a local (non-Drive) copy of the repo:
bundle exec jekyll serve --livereload   # http://localhost:4000
```

Restarting the server: stopping the shell does **not** always kill Jekyll's `ruby.exe` children on Windows. Orphaned servers keep regenerating into the same `_site` with stale config and produce mixed-up pages. Before restarting, kill every `ruby.exe` running `jekyll serve` (and `_config.yml` changes always need a restart).

**Always check JavaScript in a production build.** GitHub Pages builds with `JEKYLL_ENV=production`, where the `compress` layout squeezes every page onto a few lines (and strips `</body>`). A `//` comment inside an inline `<script>` then comments out everything after it. Keep site JS in `assets/js/site-extras.js` (not inline). To preview exactly what goes live:

```bash
PAGES_REPO_NWO=jdcyin/jdcyin.github.io JEKYLL_ENV=production bundle exec jekyll serve
```

## Scrollytelling articles (Academia)

Two academic project pages are scroll-through articles (`scrolly: true` in front matter, written as `.html` so the markup passes through untouched; built on branch `scrolly-indonesia`, merged to master).

- **Indonesia fake news** (`_academia/indofakenews.html`): it turns `_academia/indofakenews.md` into `indofakenews.html` with `scrolly: true`: 11 text steps (background ? results ? discussion ? methods) beside a pinned visual panel, content from the open-access APC report (Neo, Yin & Au, 2021). Key gotcha it fixes: the theme sets `overflow: hidden` on `#_pushState`, which silently disables `position: sticky`; the branch overrides it with `overflow: clip`. Text is British spelling; the top link is the journal only; authors Neo & Yin.
- **T20 / BMJ UHC article** (`_academia/japant20.html`): scroll-through of Bloom et al., BMJ 2019;365:l2107 in seven chapters that alternate layouts: default (panel right), `scrolly--left`, and `scrolly--wide` (the chart fills a full-width panel and the text sits along the bottom as a full-width card spanning the panel, heading left and paragraph right; `site-extras.js` measures the tallest card per chapter and reserves exactly that room under the chart (`--card-room`), so cards never cover the chart; the source footnote sits top-left under the section label). On desktop, `site-extras.js` moves every card into one slot (`.scrolly-card-slot`) at the bottom of the pinned panel: the active card stands still while its chart draws, and on a step change the old card fades and glides up out while the next eases in after a short delay (time-based, not scroll-locked; Jason found sticky, scroll-locked docking confusing). Phones keep cards inline under the chart. The pinned panel is a size container (`container-type: size`), and the card (width, padding, fonts) and HTML charts are sized in container units (`cqh`/`cqw`), so chart and card scale together with the window; keep new elements inside wide panels in `cqh`/`cqw` (wrapped in `unquote()` for Sass), not `vw`/fixed rem. The paper's four figures are **redrawn as animated SVGs from the paper's numbers** (no copied images): steps carry `data-stage`, the active visual gets `stage-1..N` classes, and elements marked `s1..s6` (`.draw` paths, `.grow-x/.grow-y` bars, `.only-N`) build up as you scroll. Wide chapters are stretched across the area right of the sidebar by `widen()` in `site-extras.js`. The migration, doctor and nurse charts are true Sankey diagrams: corridor sizes in `_tools/t20/t20_flows.rb` were measured from the colour bands in the paper's figures and balanced to the printed totals (see the comment there). **Regenerate the page with `ruby _tools/t20/make_t20.rb _academia/japant20.html`**; don't hand-edit the SVG.
