# Incursion Assault — Design Doc

> A high-fantasy, top-down 2.5D **open-world exploration** game built around
> deep **warship-building**. Build ships, airships, ground vehicles, aircraft,
> and fortifications out of editable frames; crew them with chaotic
> semi-autonomous units; explore and fight across a layered world with sky islands.

*Status: early concept capture (v0.2). This is a living doc — nothing here is locked.*

**Decided so far:**
- **Platform:** HTML / web (Canvas or WebGL + JS/TS in the browser).
- **Mode:** Singleplayer.
- **Genre lean:** Open-world *exploration* first; building & combat serve exploration.
- **Approach:** Plan fully before building.

**Planning docs:**
- [Incursion-Assault-Tech-Plan.md](Incursion-Assault-Tech-Plan.md) — framework architecture (renderer, zone editor, simulation, world).
- [Incursion-Assault-Art-Direction.md](Incursion-Assault-Art-Direction.md) — art style decision, palette, production approach.

**Inspirations:** Navy Simulator, Zeppelin Wars / Airship Assault (Roblox),
Cosmoteer, WARNO, and assorted fantasy universes.

---

## 1. The pitch (one line)
Cosmoteer's deep ship-building meets Zeppelin Wars' gloriously unreliable crew,
in a fantasy world you can build anywhere across stacked sky-and-sea maps.

## 2. Design pillars
1. **Build anything, anywhere** — one editor for ships, airships, ground vehicles,
   aircraft, forts. Fantasy era → WW1/WW2 → modern → beyond.
2. **Free placement, role-parts, no grid** — build by placing specific, damageable parts for each
   role (engine, fuel, magazine, gun…) freely on the deck — no grid AND no abstract "zone" rule-regions.
   The only placement rule is "inside the hull, no overlap." (Revised 2026-06-27: the earlier
   zone-rule-region concept is dropped — see §3.)
3. **Crew with character** — units are semi-autonomous, inconsistent, and fun to
   watch. Take direct control of any one of them at will.
4. **Total player agency** — a full "make whatever you want" sandbox (Cosmoteer-style).
   Avoid artificial restrictions on what/where/how the player builds and plays.
5. **Feel & sound are first-class** — satisfying weapons and strong sound design are a
   top priority, not polish-later. The game must *feel* good to play (see §10).
6. **Framework first** — the priority is a flexible system others can build on,
   not a fixed campaign.

## 3. The build system  ← the signature mechanic
- **NO GRID. NO ZONES. Just parts.** Place specific, damageable role-parts freely on the deck.
  The only placement rule is **inside the hull, no overlap** — reshape the hull (drag the deck
  lines) to make room, then drop parts wherever you like. *(Revised 2026-06-27: the abstract
  zone-rule-region layer is removed; what was a "Magazine zone" is now just a Magazine **part**.)*
- **2.5D top-down editor** with stacked **layers of depth**. Camera rotates around
  a fixed pivot (tilt down 90°, swing to the side, etc.) for depth perception —
  side view gives readability *without* having to model a separate front.
- **Editable hull "frames"/templates** — start from a base hull, spend resources to
  reshape it (e.g. pull the bow forward for more deck space). Fantasy shapes too.
- **A specific part for every role** — fuel, power, engines, magazines, crew, weapons, the tech
  you're fielding. **Everything is a damageable part** with hitpoints.
  - No placement rules force smart layouts; consequences do. Expose your fuel and it gets shot and
    explodes — so you *choose* to bury it deep. Emergent, not enforced.
- **Materials** matter (different properties per material — TBD, see open questions).
- **Catapults & magic logistics** — magical **slow-fields** on hangar decks allow
  rapid deceleration; **materialization compartments** let you field air wings that
  don't physically fit on the deck right now.
- **Weapons prioritize FEEL over geometric accuracy** — they don't need to be
  rivet-accurate; they need to look cool and, above all, feel *satisfying* to fire
  (punchy FX + sound + feedback — see §10). Real-world systems "but more," plus fantasy.
- **The `+` button** adds parts to whatever you're currently making.

## 4. Crew
- **Independent & self-sufficient.** They follow general orders but run their own
  priority lists: defend the vessel, man guns as needed, fire automatically.
- **You can possess any single unit** — take manual control to aim a gun, fly an
  aircraft, fire for a trooper, etc.
- **Deliberately inconsistent quality** (Zeppelin Wars energy). Untrained crews are
  *not* well coordinated, but still function semi-effectively. Special tech or
  deliberate training improves them.
- Crew **auto-sort** into weapon types / roles / tasks.
- **Crew death:** intentionally deferred. Leaning toward *not* having permadeath be
  central — it's seen as cutting against the spirit of the game. (Open question.)
- Small-arms layer: rifles, shotguns, SMGs, LMGs, grenade launchers, rockets, flak,
  flare guns — availability scales with crew type & tech period. They don't
  discriminate much.

## 5. Combat & AI
- **Line-of-sight targeting** — AI shoots what's in front of it, but prioritizes
  **high-value targets**: fuel, ammo, exposed superstructure, perceived weak points, crew.
- **Player fire-control orders** — tell units to hold fire or focus specific targets
  (they may occasionally ignore you and pepper a target anyway — by design).
- **Semi-independent parts/units** — set things to operate automatically.
- **"Beloved spam"** — let the player dump as many airships as they please.

## 6. World & map
- **Open world**, build wherever you want.
- **Layered maps** — several stacked layers, move **up and down** between them;
  **sky islands**. Trade/logistics flow across layers (X4 Foundations style).
- **Independent factions** and an **area-occupation** system.
- Fight AI ships across the map.

## 7. Tech & progression
- **Upgrade systems + fantasy tech:** robotic crew, clones, magical weapon systems,
  autoloaders, autoships — "basically everything you can think of."
- Tech period of a build influences available parts, weapons, and crew behavior.

---

## 8. Open questions / decisions to make
- **Engine/platform?** (Roblox like the inspirations, or standalone — Godot/Unity?)
  This shapes *everything* below.
- **Zone system rules:** how exactly do zone boundaries behave? Min/max sizes?
  Can zones overlap across layers? What stops degenerate/cheese layouts?
- **Materials:** what axes vary? (weight, HP, cost, heat/magic resistance, buoyancy…)
- **Resource/economy model:** what do you spend to reshape hulls & build? Where does
  it come from? Is there a campaign economy or sandbox-infinite?
- **Crew death** — final call: none, knockout/revive, or soft attrition?
- ~~**Scope of "build anything":** pick one vehicle to prove the framework?~~ ✅ RESOLVED:
  **boats first** (simplest — often single-deck, no support pillars, no flight deck). Then
  multi-deck warships, then airships (need support pillars), then ground/air/forts.
- ~~**Deck reshaping rule:**~~ ✅ RESOLVED: a **"reshape hull" button edits all decks at once**
  (proportional); **carrier/flight decks** get a **separate independent editing** mode.
- **Single-player only, or multiplayer/PvP?** (The inspirations are multiplayer.)
- **Win/lose & session shape:** persistent world? Match-based battles? Both?

## 9. Suggested build order (framework-first)
You said the **framework is the #1 priority** — agreed. A sane path:

1. **Prototype the zone editor** on ONE vehicle type (a ship). Drag bottom-deck
   boundary lines → place top-layer parts. Prove the core feel. *Nothing else.*
2. **Add the 2.5D camera** (top-down + rotate-to-side). Confirm depth reads well.
3. **Parts + required-systems pass** — fuel/crew/weapon parts, zone-locking rules.
4. **One crew member that works** — spawns, picks a role, mans a gun, auto-fires;
   then make it possessable.
5. **Two ships shoot at each other** — LOS targeting + high-value-target priority.
6. **Scale up** — more parts, more crew, materials, hull reshaping.
7. **World layer** — a single map you can build on, then stacking/sky islands.

Everything in §4–§7 hangs off steps 1–2 working well. If the zone editor feels
good, you have a game. If it doesn't, nothing else matters yet.

---

## 10. Game feel & sound  ← top-priority pillar
Satisfying *feel* is a stated must-have, ranked alongside the build system. The game can
have great systems and still fail if firing a gun isn't fun. Treat this as core, not polish.

**Weapon juice (per shot):** muzzle flash + smoke, light screen/camera shake scaled to caliber,
recoil/kick animation on the mount, tracers/projectile arcs, impact FX (sparks, splinters,
water splash, fire), hit-confirmation feedback. Bigger guns = bigger, slower, heavier feedback.

**Sound design (explicit top priority):**
- Layered weapon audio — distinct firing crack + mechanical action + tail/echo; variation per
  shot so spam doesn't get machine-gun-repetitive; distance/falloff and reverb by environment.
- Impact, destruction, crew chatter, ambient ship/engine/sea/wind beds, UI clicks for the editor.
- Web stack: **Web Audio API**, likely via **Howler.js**, with a small audio-bus/mixer
  (master / SFX / ambient / UI), positional audio tied to the camera, and pooling so many
  simultaneous sounds don't pop. (See Tech Plan for where this sits.)

**General feel:** responsive editor (snappy drag, instant valid/invalid feedback), readable
combat, weighty destruction. Feedback density scales with the action's importance.

*This pillar is referenced from §2.5, §3 (weapons), and the build-order milestones (add juice
+ sound the moment weapons fire, i.e. around M6 — not at the end).*

## 11. Ship systems & build viability — *soft constraints, not rules*
**Philosophy:** you can build *anything*; it just has to actually **work**. There are almost no
artificial bans (preserves the agency pillar §2.4). Instead, a build is gated by **physical &
logistical budgets** — get them wrong and the ship underperforms or is useless, but it's still a
legal build. A giant boat with 900× 40mm Bofors, one fuel tank, and a baby engine is *allowed* —
it just won't move, won't power its guns, and has no ammo. The lesson comes from playing it, not a
popup.

**The interlocking budgets:**
- **Structural load / deck material strength — THE primary constraint.** Heavy mounts (big guns,
  armor) need decks *rated* to bear them. Weak decks can't host heavy weapons; stronger materials
  bear more load but cost more and weigh more. This weight→strength→cost loop is the main thing
  shaping builds.
- **Power** — engines/generators supply it; weapons, systems, and utilities draw it. Under-powered
  ⇒ systems brown out / won't operate.
- **Propulsion vs. weight** — thrust ÷ total mass = speed & handling. Tiny engine + huge hull =
  crawls or can't move.
- **Fuel** — tanks give range/endurance; too few ⇒ stranded.
- **Ammo capacity** — magazines feed weapons; 900 guns need 900 guns' worth of magazines + supply,
  or they fall silent fast. No ammo ⇒ guns are dead weight.
- **Weight & buoyancy/lift** — boats float by displacement, airships by lift. Overweight boat rides
  low / capsizes / sinks; overweight airship won't climb.
- **Crew** — enough hands to actually man the guns (ties to §4).

**Editor feedback (not enforcement):** live readouts — power balance, weight vs. buoyancy margin,
fuel range, ammo per weapon, and **structural load per deck** — with color warnings. Placement is
still allowed; these are *warnings*, not blocks. Only true impossibilities (part outside the hull,
parts overlapping) are hard errors.

*Scope note: for the boats-first basics, the must-haves are weight/buoyancy, structural load,
engine/thrust, fuel, ammo, and power. Magic/exotic systems layer on later.*

---
*Captured from the Canva concept deck + notes, 2026-06-27.*
