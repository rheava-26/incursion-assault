# Incursion Assault

A high-fantasy, top-down 2.5D open-world **warship-building + combat game**. Singleplayer,
HTML/web, vanilla JS + **Three.js r128** (vendored inline as a classic script — no CDN, runs
fully offline and from `file://`). Playable on desktop and touch/mobile. Art
direction: Roblox-tier clean low-poly with strong shading. Design philosophy: **total player
agency** (Cosmoteer-style) — prefer soft warnings over hard blocks. Satisfying weapons + sound
design are the top "feel" priority.

## Where the game lives
- **`prototype/m5.html`** — THE current game: one self-contained file with an integrated
  **Build ⇄ Battle** experience. Design a warship in the editor, then fight a mirror of it (or a
  preset enemy) in a physics combat sim. Older `m0`–`m4` are throwaway history — ignore them.
- Design docs at repo root: `Incursion-Assault-GDD.md`, `-Tech-Plan.md`, `-Art-Direction.md`,
  `-Build-Spec.md`.

## Running / previewing it
Pure static HTML, no build step. **Open `prototype/m5.html` in a browser** (Chrome/Edge/Firefox) —
audio is base64-inlined so no server is needed. Optional local server: `prototype/serve.ps1`
(Windows PowerShell) serves it on `http://localhost:8777`.

> **Preview limit for coding agents:** the Three.js game needs a real browser/GPU to render, so in
> a headless/cloud sandbox you can edit and reason about the code but **cannot screenshot or visually
> verify** it. Verify logic by reading the DOM/readout values where possible; leave visual tuning for
> a real browser.

## Editing `m5.html` — read this first
- The file is **large (~6.8 MB)** because of two giant inlined `<script>` lines near the top:
  the gun-sound WAVs as base64 (`window.GUN_SOUNDS={...}`) and the vendored **Three.js r128**
  minified bundle. **Never read/print either megaline** — they will flood your context. Use grep
  to find line numbers, read narrow ranges, and edit unique strings.
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
