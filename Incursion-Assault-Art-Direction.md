# Incursion Assault — Art Direction

*Companion to [Incursion-Assault-GDD.md](Incursion-Assault-GDD.md). Planning only.*
*Synthesized by Opus from a Haiku art pass + reconciliation. v0.1, 2026-06-27.*

---

## The decision: Roblox-tier clean low-poly + strong shading
**Three.js, true 3D, low-poly geometry. Smooth/simple materials, the look carried by
LIGHTING and basic custom SHADERS — not by heavy textures. Markings (ship names, hull
numbers, insignia) done as DECALS. Target quality = the designer's reference examples
(Roblox warship "SMS Acheron" + low-poly plane), 2026-06-27.**

### The quality bar, from the reference examples
- **Clean low-poly forms** — smooth hulls/fuselages, simple panels, no high-poly greebling.
- **Shading is the headliner.** The "nice" look in the refs comes from good lighting + soft
  shadows + simple shaders, NOT from detailed textures. Invest effort here.
- **Mostly flat/solid material colors** (white/gray hull, dark superstructure) with subtle
  gradient/AO shading. Minimal-to-no rivets, grain, or grime.
- **Decals for markings** — "SMS ACHERON", "126", anchor, roundels — as projected textures /
  decal planes, cheap and flexible.
- **Weapon visuals need not be super accurate** — recognizable and cool beats rivet-counting.
  The satisfaction comes from feel + FX + sound (see GDD §10), not geometric realism.

### How this lands between the two original proposals
- Opus rec: flat-shaded, no textures. Haiku rec: full hand-painted textures + Blender/Substance.
- **Final:** clean low-poly + **shading/lighting + basic shaders + decals**. Closer to Opus's cheap
  end, but with deliberate shader/lighting polish (and decals) to hit the Roblox quality the
  designer likes. Cheaper than the textured pipeline; the "nice" comes from light, not paint.

### Why low-poly 3D
1. **Camera payoff** — true 3D solves rotating-camera-no-front-art automatically.
2. **Cheap + fast** — simple geometry, solid materials, decals; no texture-painting marathon.
3. **Right tone** — matches the Roblox refs the designer approved.
4. **Headroom** — shader/texture fidelity is a dial you can turn up later, per asset.

### Basic shaders worth budgeting for (the "nice" lives here)
- Soft directional key light + ambient fill + soft/baked shadows (the core Roblox-ish feel).
- Gentle ambient occlusion / vertex shading so forms read with depth.
- Simple water shader (sea + sky layers), light fresnel/rim on hulls.
- Cheap emissive for magical/tech parts; muzzle-flash and impact FX shaders (tie into game feel).
- Decal projection system for markings.

### Why 3D at all (vs sprites/isometric/voxel/vector)
The rotating-pivot camera + "don't model a separate front" requirement is solved most cleanly by real 3D — rotate the view and depth is correct automatically. Sprites would need pre-rendered angle sets; vector would need re-sorting on rotation; voxel works but reads more "toy" than your "realistic but more" tone. (Full option comparison preserved in the appendix below.)

## Color & mood — worn high-fantasy machinery
Warm, lived-in, lightly steampunk; not grimdark, not cartoon.

| Role | Hex | Use |
|------|-----|-----|
| Hull wood | `#6B4423` | aged ship bodies |
| Weathered steel | `#8C8C8C` | guns, rivets, reinforcement |
| Burnished brass | `#D4A574` | trim, fittings, lights |
| Sky blue | `#A8D5FF` | atmosphere / sky layer |
| Magic magenta | `#FF6EC7` | magical/tech-magic glow accents |
| Danger red | `#FF4444` | damage, fire, warnings |
| Canvas/cream | `#C4A87A` | sails, rope, fabric |
| Crystal cyan | `#00FFFF` | conduits, magical light |
| Deep shadow | `#2A2A2A` | recesses, undersides |

Lighting: one **warm key light** (late-afternoon sun) with cool shadows; bake ambient occlusion into geometry/vertex colors so crevices read; subtle emissive on magical parts (cheap, no runtime cost).

## Production approach (right-sized for flat-shaded)
- **Tools:** Blender (free) for any hand-built geometry; much can also be generated procedurally in Three.js early on (matches your gray-box mockups). Export glTF (Draco-compressed).
- **Modularity:** model hull / deck / turret / sail / crew as separate pieces; instance turrets and reuse across ships. New ship variants reuse ~70% of existing pieces.
- **Performance:** 500–2000 polys/ship, flat materials, baked shadows; comfortably 60fps with dozens of ships on a 2018+ laptop. Flat shading is *cheaper* than the textured route.
- **Crew readability:** small units get bold outlines (post-process) + UI icon overlays so they stay legible at any zoom.

## Upgrade path (later, optional)
If/when you want more richness: add hand-painted albedo + normal maps per asset (Haiku's original Blender→Procreate→Substance pipeline). Nothing in the engine or data model needs to change — it's purely an asset swap.

---

## Appendix — full style options considered (from the Haiku pass)
1. **Flat-shaded / textured low-poly 3D** ✅ chosen (flat-shaded variant). Single asset reads from every angle; camera rotation free; cheapest path; fits the tone. Refs: Dinkum, low-poly WebGL games.
2. **Isometric sprite sheets** — proven (Cosmoteer) but needs pre-rendered angle sets for rotation = asset multiplication. Loses free camera.
3. **Voxel (MagicaVoxel→WebGL)** — gameplay maps nicely to chunks and it's fast to author, but reads "toy," fighting the "realistic but more" tone.
4. **Vector + procedural isometric** — cheapest to prototype, playful, but hard to hit the intended tone and needs re-sorting on rotation.
