# Incursion Assault — v6 Roadmap & Handoff

*Living status doc for the m6 batch build-out. Written 2026-07-03 so any contributor (human or AI)
can continue exactly where the last session stopped. Work happens on branch
`claude/worldbuilding-game-systems-uydopa`; THE game is `prototype/m6.html` (see CLAUDE.md for
editing rules — especially the giant-line warnings).*

## Priority order (designer-set, supersedes older docs)
1. ✅ Editor feel & parts
2. ✅ Crew as moving, uncoordinated units
3. ✅ Airships / aircraft / ground units
4. ✅ Magic integration
5. ✅ Broader world map (Centak Islands) — ship movement, commands, terrain
6. ✅ (scaffold) Structures, excavation, harbors (harbors gate what/how big you can build)
7. ✅ (scaffold) Supply lines + X4-style reactive economy

## Done so far (each = one pushed commit)
- **U0** `583cf5b` — m5→m6 fork; **three.js r128 vendored inline** (offline, no CDN);
  `Incursion-Assault-Worldbuilding.md` canon doc (factions/magic/map).
- **U1** `cf494c8`+`a50a1d2` — undo/redo (Ctrl+Z/Y, snapshots); **arc outcroppings**
  (Ctrl-drag green edge dot; hull verts = `[x,z,bulge]`, tessellated via `expandHull()`;
  save key bumped to `incursion_ship_v3`); Control parts: Conning Tower, Armored Bridge,
  Flying Bridge, Fire Director (halves spread); hover/pointer-capture polish;
  `window.__IA` dev hook + `Editor.loadDesign(d)`.
- **U2** `4fc02fc` — crew rewrite: fixed m5 y/z arg swap; competence per crewman; gunners
  hold mounts (gun fires **only when manned**), drift off when unfocused; deck hands run
  ammo magazine→gun; orphaned guns re-manned; targets clamp to deck outline.
- **U3** `1221a87` — vehicle types (boat/airship/ground); Mana Engine, Lift Envelope,
  Storage Converter, Inertial Dampener, Track Assembly; airships fight at altitude
  (baseY=18) with lift-vs-mass readout + envelope forcefields (75% soak while a mana
  engine lives; all bags dead = crippled); carrier fighters (≤6) orbit + strafe;
  `inAABB` now honors part altitude; Hekani Skybarge preset.
- **U4** `938be09` — Adamantine/Depthsteel deck materials; Infusion Vats (explode on
  death), Necroforge Crypt (slow, never leaves post), Mindlink Pylon (ship-wide perfect
  coordination); Magiartillery (mana-fed, ignores magazines), Shield Barrier (35% soak),
  Blink Drive (12% dodge).

## U5 — Centak Islands world map — ✅ SHIPPED as designed below
Add a third module `World` IIFE next to Editor/Battle + `MODE==='world'`:
- Own scene/ortho camera; big sea; islands = hand-authored `Polygon2D`s evoking the sketch
  map (Canis NW, Serds NE, circled central isle, Toles S, SW cluster, eastern isle=Centura);
  extruded ShapeGeometry, faction-tinted banner/territory discs (Hekani, Centura, Kolden,
  Toles Compact, contested center).
- Player ship marker built from `Editor.getDesign()` (hull silhouette; airship floats
  higher); click sea → sail there (speed = thrust/(mass/1000)·profile mult).
- Faction AI ships patrol home waters; click one within range → engage: set Battle foe
  preset per faction (skybarge=Hekani, cruiser=Centura, glasscannon=Kolden), showMode
  ('battle'), `Battle.start(design)`; expose `Battle.setFoe(key)` + an `onEnd(victory)`
  hook so World removes beaten foes on return.
- HTML: `#modeWorld` button + `.worldonly` panels (wstatus + faction legend); extend
  `showMode`/`animate`/resize to route the third module.

## U6 — harbors — ✅ scaffold shipped (5 harbors, docking, tier caps hull area as soft warning via window.__DOCK; forts/excavation still open)
Harbor entities on island coasts; docking at a harbor gates max hull area & available part
categories by harbor tier (dry-dock rule); fort structures using the same part editor;
terrain excavation stub (flatten/carve island polys) can come last.

## U7 — economy — ✅ scaffold shipped (faction freighters haul crystals mine→Dragau Market, stocks tick, raiding pays; trading UI + production chains still open)
Resources (mana crystals, steel, fuel) at island mines; freighter AI ships haul between
harbors; factions accumulate/spend; player can trade or raid the freighters. X4-style:
everything physically shipped, no abstract tick.

## Conventions & testing (READ before editing)
- Match the dense single-file style; parts live in `PART_DEFS`+`SYS`+`makeRolePart`; designs
  round-trip `serialize`/`loadShip`/`getDesign` (getDesign also carries `hullRaw`).
- Soft warnings over hard blocks — total player agency.
- **Never read the giant lines** (~188 three.js, ~192–194 sounds); guard greps with
  `awk 'length($0)<300 && /pat/'`.
- Syntax gate: extract the last `<script>` block → `node --check`.
- E2E: headless Chromium + SwiftShader renders fine (Playwright,
  `/opt/pw-browsers/chromium-*/chrome-linux/chrome`, args `--use-gl=angle
  --use-angle=swiftshader --no-sandbox`): load `file://…/m6.html`, `__IA.Editor.loadDesign`
  a test design, assert `#r*` readouts + zero console/page errors, click `#modeBattle`,
  screenshot. Sample scripts lived in the session scratchpad (`e2e.mjs`, `u1test.mjs`,
  `u3test.mjs`) — trivial to recreate from this recipe.

## Known bugs / wanted polish
- Battle screenshot showed a large translucent disc after a magazine cook-off — likely an
  oversized smoke/explosion sphere; verify and cap its scale.
- Crew figures are small at battle zoom; consider outline/scale pass (Art Direction says
  bold outlines for readability).
- Kolden psisolid weapon + adamantine heat/overload mechanics are canon but unimplemented.
- Mast/hull-profile visual pass done via screenshots; designer eyeball still welcome.
- m5 saves: v2 key still readable; m6 writes v3.
