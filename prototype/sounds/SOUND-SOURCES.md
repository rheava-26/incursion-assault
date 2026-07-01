# Incursion Assault — Sound sourcing (research)

Properly-licensed sound libraries for the game. **Avoid copyrighted SFX.** Verify each item's
license before shipping. (Researched 2026-06-27.)

## #1 recommendation — Sonniss GDC Game Audio Bundle (via Internet Archive)
- **Page:** https://archive.org/details/SonnissGameAudioGDC · **Listing:** https://archive.org/download/SonnissGameAudioGDC
- **License:** Sonniss royalty-free — **no attribution**, unlimited commercial use. (Not CC0, but
  functionally equivalent for shipping a game.) One restriction: **no AI/ML training** use.
- **Size:** 160–200+ GB across years (mirrored, open, no login). Grab one year bundle
  (e.g. 2023 ≈ 44 GB, 2024 ≈ 27.5 GB) for weapons/explosions/impacts/ambience/UI in one shot.
- **Direct download:** Yes — archive.org ZIPs, no login, curl/wget-friendly.
- **Gap:** naval-specific SFX (cannon splash, hull creak, bells) are thin — supplement below.

## Best of the rest
| Source | License | Attribution | Commercial | Best for | Direct DL |
|---|---|---|---|---|---|
| **Kenney.nl audio** (kenney.nl/assets/category:Audio) | CC0 | none | yes | UI, impacts, foley, menu/build sounds | excellent (ZIPs) |
| **OpenGameArt CC0** — incl. [Free Firearm Sound Library](https://opengameart.org/content/the-free-firearm-sound-library) | CC0 (verify per item) | none | yes | rifles/MGs/multiple calibers, bangs | good |
| **Pixabay** (pixabay.com/sound-effects) | Pixabay License | none | yes | cannon/explosion/navy search hits | manual, per-file |
| **Freesound** (CC0 filter) — qubodup military pack, CGEffex explosions | CC0 (filter!) | none | yes | naval gaps: cannon, ship, ocean, ricochet, splash | needs free account |

## AVOID
- **BBC Sound Effects archive** — RemArc license is **non-commercial only**. Great naval recordings,
  but commercial use needs a paid license. Don't use unless the game is entirely free/non-commercial.

## Acquisition plan
1. Sonniss 2023/2024 bundle (archive.org) → weapons, explosions, impacts, ambience, UI.
2. Kenney *Impact Sounds* + *UI Audio* + *Interface Sounds* (CC0) → build/place/menu layer.
3. Free Freesound account → CC0 search `cannon`, `ship`, `ocean`, `ricochet`, `splash` for naval gaps.
4. OpenGameArt *Free Firearm Sound Library* → WW1/WW2-era rifles & MGs.

**This is where the next batch of game sounds (cannons, explosions, naval ambience, UI) comes from.**
For the prototype's embedded-audio pipeline: pick short clips, drop them in, re-run the base64 embed.
