# CLAUDE.md

Personal website for Jason D.C. Yin (jasonyin.com). Jekyll 3 site on the Hydejack theme, deployed via Netlify (`netlify.toml`) from `master`.

## Working rules

- **File/folder changes are fine.** Go ahead and edit, add, rename, or delete content files and folders without asking first.
- **Design changes must be flagged.** Anything that changes how the site looks (fonts, colors, layout, spacing, new page structures) — say so explicitly before or as you make it.
- **Always show a local preview before pushing.** Never commit/push a design change until it has been built locally and Jason has seen it. Push only when asked.

## Site structure

| Sidebar tab | Source | Notes |
|---|---|---|
| Home | `index.md` (layout `page`) | Intro text; sidebar stays visible (no full-screen cover) |
| Academia | `academia.md` + `_academia/*.md` | "Research projects" tile grid, then a Presentations list from `_data/academia_presentations.yml` |
| The Economist | `theeconomist.md` + `_theeconomist/*.md` | Tile grid of publications, then a "Presentations & moderations" list from `_data/theeconomist_presentations.yml` |
| AlriteAlready! | `alritealready.md` + `_projects/*.md` | Page titled ALRITE ALREADY!: link to alritealready.com, then one tile per site (BeenAlready, SeenAlready, SpreadAlready) |

- Sidebar menu is defined in `_config.yml` under `menu:`.
- ReadAlready (`readalready/`, `_posts/`, `_featured_*`) is being migrated away; it is **off the sidebar** but files remain until migration is done.
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

Add an entry to `_data/academia_presentations.yml` or `_data/theeconomist_presentations.yml` (newest first; a page hides the section while its list is empty): `title`, plus any of `date`, `event`, `hosts`, `location`, `role`, `url`; missing fields are just left out. Layout: title | location on top, date · event · with hosts | role underneath. The heading has an All / Moderator / Speaker filter driven by `role` (panellist, speaker and presenter count as Speaker).

## Typography / styling

- Font: **JetBrains Mono** everywhere (body, headings, code), matching the footer text on pablogguz.github.io. **Self-hosted** in `assets/fonts/` with `@font-face` in `_includes/my-head.html` (no Google Fonts), so it never falls back to another font. Earlier tries: Inter (original), Newsreader serif.
- Sidebar is **static** (`no_drawer: true`, no menu button). On narrow screens it becomes a compact header above the content (CSS in `_sass/my-inline.scss`). Sidebar name is 2px bigger than the nav links.
- Footer copyright: `copyright` in `_config.yml` uses a `%YEAR%` token that `_includes/body/footer.html` replaces with the build year, so it updates on every deploy.
- Sidebar social icons: email (opens a centered popup with a Copy button, `_includes/my-body.html`) and LinkedIn (new tab), set under `author1.social` in `_data/authors.yml`.
- No sidebar tagline (`tagline` is commented out in `_config.yml`; `_includes/body/sidebar-sticky.html` no longer falls back to the site description).
- Sidebar background is art deco, not a photo (`accent_image: none`): gold `assets/img/deco-fret.svg` (Shanghai deco key-fret lattice) on deep jade, with one stationary glow behind the portrait that slowly brightens and dims. A script in `_includes/my-body.html` also lights individual 回 tiles (`assets/img/deco-fret-light.svg`) one at a time in random order, so every tile gets a turn per round. The pattern sits at `background-position: 0 0` so the lights line up; keep the two in sync. Defined in `_sass/my-inline.scss`; static for reduced-motion users.
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
