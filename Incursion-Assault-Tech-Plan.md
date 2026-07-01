# Incursion Assault — Technical Framework Plan

*Companion to [Incursion-Assault-GDD.md](Incursion-Assault-GDD.md). Planning only — no code until the plan is signed off.*
*Synthesized by Opus from a Sonnet architecture pass + reconciliation. v0.1, 2026-06-27.*

---

## Locked decisions (coordinator rulings)
- **Renderer: Three.js**, WebGL, with a near-**orthographic camera**. (Reconciled from Sonnet=Three.js, Haiku=Babylon/Three. Three.js is lighter and fits a 2.5D top-down editor better.)
- **The 2.5D is TRUE 3D**, not faked 2D layers. Decks are real horizontal planes at fixed heights; the camera orbits a pivot. This is what makes "rotate the camera, never draw a front" work. *Both agents independently reached this.*
- **Zone editor is Milestone 1.** Nothing heavy (ECS, AI workers, world streaming) gets built until the zone editor feels good. If the editor isn't fun, nothing else matters.
- **Language: TypeScript** (catch geometry-math bugs at compile time; the polygon code is where bugs will hide).
- **Build tool: Vite.**

---

## 1. The 2.5D / layered-deck model
- **Y is vertical** (deck-stacking axis); X/Z is the horizontal plane.
- Each **deck** is a horizontal plane at a fixed height: deck 0 at Y=0, deck 1 at Y=2, etc. (`DECK_HEIGHT_STEP`).
- **Camera** is defined by `{ target, radius, polarAngle, azimuthAngle }` and computed each frame on a spherical arc. `polarAngle=0` = straight top-down; `~55°` = the signature 2.5D tilt; `90°` = full side view. Tilt is a one-line per-frame change — no scene rebuild.
- **Editing uses raycasting:** the cursor ray intersects the active deck's plane to get an exact world-space point. No grid.
- **Occlusion while editing:** decks above the one you're editing hide or render as outlines; on tilt, all decks show.

## 2. Ship data model (the shapes that matter)
TypeScript-style, abbreviated (full interfaces to live in `/src/types`):
- `Material` — density, HP/m², armor, buoyancy mod, magic resist, cost, **load capacity per m²**
  (deck strength — how much part weight a deck of this material can bear; the primary build constraint).
- `Polygon2D` — ordered `[x,z]` vertices. The atom of everything.
- `Zone` — a `Polygon2D` on a deck + which part categories it allows/forbids + optional material lock + label ("magazine", "hangar"…).
- `Deck` — index, height, `zones[]`, and its own `hullOutline: Polygon2D`.
- `PartDefinition` — category, tech period, `footprintPolygon`, mass, valid/preferred zone categories, stats.
- `PlacedPart` — definition ref, deck, exact `[x,z]` position, rotation, material, HP, assigned crew.
- `HullTemplate` — vehicle type, ordered decks, editable `controlPoints` (bow/stern/beam handles), base mass/buoyancy.
- `PartDefinition` stats also carry **system contributions**: `powerDraw`/`powerSupply`,
  `thrust`, `fuelStorage`/`fuelDraw`, `ammoStorage`, `crewRequired` — so budgets are summable.
- `VehicleBuild` — the live editable ship: decks, parts, plus **derived budgets** (per GDD §11):
  mass, center-of-mass, buoyancy/lift margin, **power balance**, **thrust-to-weight**,
  **fuel endurance**, **ammo per weapon**, and **structural load per deck** (sum of part weights
  on a deck vs. that deck's material load capacity). Plus validation errors/warnings.

**Soft constraints vs. hard errors (agency principle).** The budgets above generate
`severity: "warning"` only — an overweight, under-gunned, no-ammo build is *legal* and placeable.
Only physical impossibilities (part outside hull, parts overlapping, zone-lock violation) are
`severity: "error"` that block placement. The editor surfaces budgets as live HUD readouts +
color warnings, never as a hard "no".

## 3. The zone editor — the signature mechanic (most important section)
**A zone is a simple (possibly concave) non-self-intersecting polygon** in deck-local space. The deck's `hullOutline` is also a polygon; **zones must stay inside it.** That containment invariant is the primary validity rule.

**The bottom-deck → upper-layer coupling (your core idea):** each deck's `hullOutline` is both the ceiling-footprint of the space below and the floor of the space above. Expand the bow on deck 0 and you create floor area on deck 1 — "move the lines on the bottom to make room on top."

**What you drag:**
1. **Hull outline edges / control points** — reshape the hull. The **"Reshape Hull" button/mode
   moves the outline across ALL decks at once** (proportionally). This is the default, because
   decks normally share a footprint. Costs resources to expand. *(Designer decision, 2026-06-27.)*
2. **Independent deck editing (carrier/flight decks)** — a **separate** mode lets specific decks be
   shaped independently of the all-decks reshape, for flight/carrier decks that don't follow the
   hull profile below them.
3. **Zone boundary edges/vertices** — partition interior space into rooms.

**Vehicle scope (basics first):** **boats first** — they're the simplest (often single-deck, no
support pillars, no flight deck). **Multi-deck** (warships) comes next; the all-decks reshape +
independent-deck editing above cover it. **Airships** are inherently multi-deck and additionally
need **support-pillar** structural rules (parts that must connect decks) — explicitly deferred.

**Drag loop:** pick an edge → translate it along its normal → every step run `isPolygonValid()` (no self-intersection, area ≥ minimum, inside parent) → red highlight + snap-back if invalid → commit + re-validate on release.

**Placing parts (free, no grid):** ghost the part's footprint at the raycast point → check (a) fully inside one zone, (b) zone allows the category, (c) no overlap with existing parts, (d) optional required adjacency → green/yellow/red feedback → click to place at exact float coords. Zone-locked parts (e.g. ammo only in "magazine") are enforced here and re-checked whenever a zone is reshaped.

**The math that must be bulletproof:** point-in-polygon (Sutherland-Hodgman), polygon overlap (SAT for convex footprints), self-intersection test, area. All of it lives in ONE file (`polygonUtils.ts`) and gets a full unit-test suite *before* the editor is called done. **This is the #1 technical risk** — a subtle float bug here breaks the whole game feel.

## 4. Simulation (deferred until after the editor)
- **Lightweight custom ECS** (~200 lines), not a framework. Entity = integer id; components = plain data; systems = functions over component masks.
- **Fixed timestep at 20 ticks/s**, decoupled from 60fps render; interpolate rendered positions.
- **Crew** = state machine (`IDLE→MOVE→MAN_WEAPON→FIRING→…`) with a `competenceRating` driving aim jitter, order-response delay, and "ignores you sometimes" — that's how the *lovable-idiot crew* feel is implemented. Possession = disable the state machine, route player input to that one entity.
- **Line-of-sight** is the expensive part: refresh every ~250ms (staggered), use simplified convex hulls for LOS (exact polygons only for the editor), and push batch LOS + pathfinding to a **Web Worker**. This is what makes "beloved spam" (lots of units) viable in a browser.
- **Budget:** ~500 crew + ~50 ships target on a mid laptop; 8ms render / 4ms sim / 4ms misc per frame.

## 4b. Audio & game-feel (first-class, per GDD §10)
Sound and juice are a stated top pillar, so the engine reserves a real slot for them — not a
bolt-on. Plan:
- **Web Audio API**, wrapped by **Howler.js** for sprite/pooling ergonomics.
- A small **audio bus/mixer**: master → {SFX, ambient, UI} sub-buses with independent volume.
- **Positional audio** tied to the camera pivot; distance falloff + light environmental reverb.
- **Sound pooling / voice limiting** so "beloved spam" firing dozens of guns doesn't clip or pop;
  round-robin sample variation per weapon to avoid the machine-gun-repeat effect.
- **Juice layer** lives in rendering/FX: muzzle-flash + impact particle systems, camera-shake
  module (scaled by weapon caliber), recoil tweens — all triggered off the same weapon-fire event
  the audio listens to (one `WEAPON_FIRED` event → FX + sound + shake).
- **Where in the schedule:** wire the first satisfying shot (FX + sound + shake) at **M6**, when
  weapons first fire — not deferred to the end. Build a tiny test harness to tune "feel" early.
- New module: `/src/audio` (mixer, sound registry, positional emitter) + an FX/shake helper in
  `/src/rendering`.

## 5. World (deferred further)
- **Layered maps** (sea/surface/sky to start) as separate XZ planes; sky islands are statically-placed terrain chunks flagged `sky`.
- **Chunk streaming** (128×128 units, load radius ~3) async from IndexedDB/JSON.
- **Save/load via IndexedDB** (NOT localStorage — polygon data for many ships blows past 5MB). Autosave on idle, never blocking the loop.

## 6. Module layout (target)
`/src` → `core` (ecs, sim loop, eventBus) · `rendering` (renderer, camera, deck/part/world renderers, shaders) · `editor` (**zoneEditor, polygonUtils**, dragOperation, placementValidator, hullEditor) · `simulation/systems` (crewAI, weapon, los, movement, damage + aiWorker) · `data` (materials, parts, hulls, techTree) · `world` (worldManager, chunkManager) · `save` · `ui` · `types`.

The files everything depends on, build first: `types/index.ts`, **`editor/polygonUtils.ts`**, `editor/zoneEditor.ts`, `rendering/renderer.ts`, `core/ecs.ts`.

## 7. Milestone order (smallest-first, each runnable in a browser)
- **M0 — Blank canvas:** Three.js + ortho camera, one gray deck, cursor dot via raycast. Proves the coordinate system.
- **M1 — Zone editor core:** one deck, draggable hull-outline edges, zone polygons, splitting zones, full validity. *No parts, no tilt.* **This is the milestone that proves the game exists.**
- **M2 — Camera tilt:** add polar-angle control + animation; confirm decks read at 45° and 90°.
- **M3 — Part placement:** 3 hard-coded parts, palette, containment/overlap checks, zone-lock, green/red feedback.
- **M4 — Multi-deck + hull handles:** second deck; bow/stern control points reshape all decks; confirm readability when tilted.
- **M5 — ECS + one crew unit:** spawn, pick a role, man a weapon, be possessable.
- **M6 — Two ships, LOS combat:** auto-fire, damage, parts destroyed. First full game loop.
- **M7 — World layer + streaming + save:** small map, movement, chunk load/unload, IndexedDB round-trip.

## 8. Top technical risks
1. **Polygon math correctness** (HIGH) — TDD `polygonUtils.ts` before M1 ships.
2. **LOS at scale** (HIGH) — prove the Web Worker approach at M6 before promising big unit counts.
3. **Tilted multi-deck readability** (MED) — playtest at M2; may need to dim upper decks.
4. **Hull-outline propagation rule across decks** — ✅ RESOLVED (2026-06-27): default is an
   all-decks-at-once proportional reshape button; carrier/flight decks get a separate independent
   editing mode. Boats (single-deck) ship first, so this complexity is deferred to the multi-deck milestone anyway.
5. **IndexedDB autosave spikes** (LOW-MED) — idle-callback autosave, benchmark at M7.
