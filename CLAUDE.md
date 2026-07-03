# Incursion Assault

A high-fantasy, top-down 2.5D open-world **warship-building + combat game**. Singleplayer,
HTML/web, vanilla JS + **Three.js r128** (vendored inline — no CDN, runs fully offline and from
`file://`). **Playable on desktop and touch/mobile.** Art
direction: Roblox-tier clean low-poly with strong shading. Design philosophy: **total player
agency** (Cosmoteer-style) — prefer soft warnings over hard blocks. Satisfying weapons + sound
design are the top "feel" priority.

## Where the game lives
- **`prototype/m6.html`** — THE current game: one self-contained file with an integrated
  **Build ⇄ World ⇄ Battle** experience + a themed **main menu** (`#menu`). Design a warship or
  skyship in the editor, sail it across the Centak Islands (World), and fight faction ships or a
  preset foe in a physics combat sim. Fully **touch/mobile-ready** (unified two-finger pinch-zoom
  via the outer-scope `IA_TOUCH` manager + each module's `zoomBy`; on-screen `#touchbar`;
  responsive CSS). Older `m0`–`m5` are throwaway history — ignore them.
- **Deployment:** root `index.html` redirects to `prototype/m6.html`; `.github/workflows/pages.yml`
  publishes the site to **GitHub Pages** on every push to `main` (live at
  `https://rheava-26.github.io/incursion-assault/`). Repo must stay **public** for Pages (free tier).
- Design docs at repo root: `Incursion-Assault-GDD.md`, `-Tech-Plan.md`, `-Art-Direction.md`,
  `-Build-Spec.md`, and **`Incursion-Assault-Worldbuilding.md`** (setting/factions/magic canon —
  supersedes the GDD where they conflict).

## Running / previewing it
Pure static HTML, no build step. **Open `prototype/m6.html` in a browser** (Chrome/Edge/Firefox) —
audio is base64-inlined so no server is needed. Optional local server: `prototype/serve.ps1`
(Windows PowerShell) serves it on `http://localhost:8777`.

> **Previewing in a headless sandbox:** the game renders fine under headless Chromium with
> SwiftShader (`--use-gl=angle --use-angle=swiftshader`) via Playwright — screenshots and visual
> verification DO work. Load `file://…/prototype/m6.html`, wait ~2s, screenshot; also assert no
> console/page errors and read the `#r*` readout DOM for logic checks. (three.js is vendored
> inline, so no network is needed.)

## Editing `m6.html` — read this first
- The file is **large (~6.6 MB)**: three.js r128 is vendored inline (runs fully offline) and the
  gun-sound WAVs are base64 in a `<script>window.GUN_SOUNDS={...}</script>` block (one giant line
  **per sound**). **Never read/print any of the giant lines** (three.js ~line 188; sounds ~192–194)
  — they will flood your context. Guard greps with a line-length filter (e.g.
  `awk 'length($0)<300 && /pattern/'`), read narrow ranges, and edit unique strings.
- One big IIFE. Order: constants (`PART_DEFS`, `DEFMAP`, `SYS`, `MAT`, world physics, `HULL_PROFILES`)
  → shared model/geometry helpers (`makeRolePart`, `makeHull`, `makeBulwark`, `makeWater`) →
  **`Editor`** IIFE → **`Battle`** IIFE → controller. Top-level `MODE` var; each module owns its own
  `THREE.Scene` + `OrthographicCamera`; one shared renderer; `animate()` renders the active module.

## What's built so far
- **Editor:** free-form hull as a top-down polygon — drag orange nodes, drag green edge dots to add a
  node, shift-click to delete. Parts placed freely (center-over-deck, soft overlap; may overhang as
  sponsons). **Multi-level decks** (＋deck / ▲▼) with per-deck collision + a stability/top-heavy metric.
  **Deck materials** (Oak/Iron/Steel: load capacity vs. weight). **Deck-carrying structural parts**
  (Deck Platform, Superstructure — `deckTop`/`lvls`, span decks, build on their roof). **Hull
  cross-section profiles** (flat / V / round / catamaran via `makeHull`) + **footprint presets**.
  **Symmetry mode**. **Masts** (Tower/Tripod/Cage/Pagoda). **Category-filtered parts palette**.
- **Battle:** builds the design + a foe; real per-weapon ballistics (½mv² energy from muzzle
  velocity/shell mass/rpm). **This world is ~0.85 g with a thick atmosphere → floaty, decelerating
  shells** (see `WORLD`, `GRAVITY`, `AIR_DRAG`). **Crew figures** man stations, have HP, and their
  casualties slow the ship's gunfire. Wrecks, effects, Web Audio gun sounds.

## Conventions
- Match the surrounding code style (dense, compact, single-file). Parts are defined once in
  `PART_DEFS` and modeled once in `makeRolePart` (base-at-y=0, centered on x/z) so editor + battle
  share them. Ship designs round-trip through `serialize`/`loadShip`/`getDesign`.
- Keep constraints **soft** (warnings/readout colors), not hard blocks, per the agency philosophy.

## Roadmap (open)
Superstructure arrangement presets (single/center/twin-island, forecastle-flush); terrain/island
generation; build-size limits; water textures + ship bobbing; engine/propeller variety; hull
aero/hydrodynamic drag + ship movement in battle; deeper crew (pathing, manning specific stations).
The hull cross-section shapes and the 4 masts were built without a live preview and still want a
visual tuning pass (proportions, keel depth, catamaran tunnel).
