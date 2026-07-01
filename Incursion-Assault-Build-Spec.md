# Incursion Assault — Build Spec (boats-first basics)

*Companion to [GDD §11](Incursion-Assault-GDD.md) and the [Tech Plan](Incursion-Assault-Tech-Plan.md).*
*First-pass numbers — all values are for tuning, not final. v0.1, 2026-06-27.*

---

## 1. Structural load math

The primary build constraint (GDD §11). Computed **per deck**, aggregate (point-load and
vertical transfer are deferred — see §1.4). Capacity is a **baseline you can raise**, not a wall.

### 1.1 Per-deck formula
```
area_d              = polygon area of deck d's hull outline           (m²)
matCap              = floor material load capacity                    (kg/m²)   [table §3]
baseCapacity_d      = area_d × matCap                                 (kg)

supportFlat_d       = Σ support-column capacity affecting deck d      (kg)
equipMult_d         = product of equipment multipliers on deck d      (×, default 1.0)
equipFlat_d         = Σ flat equipment bonuses on deck d              (kg)

effectiveCapacity_d = (baseCapacity_d + supportFlat_d + equipFlat_d) × equipMult_d

load_d              = Σ part.massKg on deck d  + stored fuel/ammo weight   (kg)
loadRatio_d         = load_d / effectiveCapacity_d
```

### 1.2 Thresholds (warnings, never hard blocks — agency principle)
| loadRatio_d | State | Effect |
|---|---|---|
| ≤ 1.0 | **OK** (green) | none |
| 1.0–1.25 | **Overstressed** (yellow) | speed/handling penalty, visible sag, creaking SFX |
| > 1.25 | **Critical** (red) | progressive structural failure risk: under stress or when hit, the deck can buckle and parts break loose |

### 1.3 Raising capacity (per designer note — open-ended)
- **Support columns** — a structural part placed on a deck; adds `+columnCap` kg to the
  effective capacity within radius `r`. Stack them under heavy batteries. They cost resources,
  weigh `columnMass`, and take deck space. (First pass: +5,000 kg, r = 4 m, mass 300 kg.)
- **Special equipment** — flat or multiplier bonuses, e.g. *Reinforced Keel* (+30% all decks),
  *Bracing Kit* (+8,000 kg this deck). Open-ended on purpose — new items can keep raising the cap.

### 1.4 Deferred (not in boats-first basics)
- **Point load:** single heavy mount pressure = `part.mass / footprintArea` vs a material point
  limit, requiring a column *directly beneath*. (Aggregate-only for now.)
- **Vertical transfer:** upper-deck weight flowing down through supports. Boats are usually
  single main deck, so ignore for now (matters for warships/airships later).

### 1.5 Worked example
50 m² **oak** deck (200 kg/m²) → base 10,000 kg.
- 40mm Bofors mount = 500 kg → ~**20 mounts** before sag.
- Re-floor in **steel** (900 kg/m²) → 45,000 kg → ~**90 mounts**.
- Or add **6 support columns** (+30,000) on oak → 40,000 kg.
That tradeoff (weight ↔ strength ↔ cost ↔ space) is the heart of build viability.

---

## 1.6 Everything is a role-part (no zones) — revised 2026-06-27
**The abstract "zone" rule-region concept is dropped.** There are no zones, no zone-locks, no grid.
You place **specific, damageable parts for each role** directly on the deck; the only placement rule
is **inside the hull, no overlap**.

- Every part is a **discrete physical object** with a position, footprint, and **hitpoints** — all
  **targetable and destroyable**. Fuel tanks, magazines, engines, generators, crew berths, the
  bridge, guns, catapults, support columns.
- Fuel & ammo are **high-value targets** (AI prioritizes them per GDD §5/§9; they explode).
- "Smart layout" is **emergent, not enforced**: nothing stops you exposing the fuel — but it'll get
  shot and cook off, so you choose to bury it deep behind armor/structure.
- Selecting any part responds with its info (name, role, HP, mass, high-value flag).

## 2. Basic part list (boats-first)

System contributions are summed into the build budgets (GDD §11). `+power` supplies, `−power`
draws. Mass feeds structural load (§1).

| Part | Category | Mass (kg) | Power | Thrust | Fuel | Ammo | Crew | Notes |
|---|---|---:|---:|---:|---:|---:|---:|---|
| Steam Engine (S) | engine | 2500 | −20 | +40 | −5/min | – | 1 | core mover; draws fuel |
| Generator (S) | power | 1500 | +100 | – | −3/min | – | 1 | supplies ship power |
| Fuel Tank | fuel | 800† | – | – | +500 store | – | 0 | keep protected; explodes if hit |
| Magazine | ammo | 1200 | – | – | – | +400 store | 0 | dangerous exposed; feeds weapons |
| Crew Berth | crew | 600 | – | – | – | – | +6 cap | houses crew |
| Bridge / Helm | control | 1000 | −10 | – | – | – | 1 | required to steer |
| Support Column | structural | 300 | – | – | – | – | 0 | +5,000 kg deck cap (r=4 m) |
| Light MG | weapon | 150 | −2 | – | – | low draw | 1 | anti-personnel/air |
| 40mm Bofors | weapon | 500 | −5 | – | – | med draw | 2 | fast AA/light gun |
| Naval Gun (4") | weapon | 3000 | −15 | – | – | high draw | 3 | hard hitter; needs strong deck/columns |
| Aircraft Catapult | aircraft | 2500 | −40 | – | – | – | 2 | launches air wing; magical slow-field; big power surge |

† Fuel Tank mass rises with stored fuel.

**Minimum viable boat:** hull + 1 Bridge + 1 Steam Engine + 1 Generator + ≥1 Fuel Tank +
≥1 Crew Berth + (for any gun) ≥1 Magazine + the weapon(s) + enough deck strength to bear it all.

---

## 2.1 Weapon ballistics — use REAL historical data
Projectile weapons fire a simulated round and **damage = kinetic energy (½·m·v²)** at impact,
computed from real-world figures. Visual shell speed is scaled down so rounds are watchable; the
*energy* stays physically real. Fill this table from historical sources as weapons are added.

| Weapon | Caliber | Muzzle velocity | Shell mass | Muzzle energy (½mv²) | Rate of fire |
|---|---|---:|---:|---:|---:|
| 40mm Bofors L/60 | 40 mm | 850 m/s | 0.90 kg | ≈ 325 kJ | 120 rpm |
| Light MG (e.g. .303) | 7.7 mm | 744 m/s | 0.0113 kg | ≈ 3.1 kJ | 500 rpm |
| Naval gun (4" / QF Mk V) | 102 mm | 800 m/s | 14.1 kg | ≈ 4.5 MJ | 12 rpm |

*Figures are approximate historical values for tuning. Damage scales from impact energy, so a
round that has slowed/dropped over distance hits softer — physics, not flat numbers. Penetration
vs. armor (also energy-based) is a later layer.*

## 3. Deck / hull materials (first pass)

| Material | Load cap (kg/m²) | Density | HP | Cost | Feel |
|---|---:|---|---|---|---|
| Oak Planking | 200 | low (buoyant) | low | low | early boats, light & cheap |
| Iron Plate | 600 | high | medium | medium | sturdier warships |
| Steel Plate | 900 | highest | high | high | heavy batteries, armor |

*Fantasy/aetheric materials (lighter-than-iron but strong, magic-resistant, etc.) layer on later.*
