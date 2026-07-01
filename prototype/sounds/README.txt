INCURSION ASSAULT — sound drop-in folder
========================================

The prototype (m3.html) automatically uses real sound files if they're here.
If a file is missing, it falls back to the built-in synth. No code changes needed.

ALREADY HERE (downloaded — CC0 / public domain, no attribution required):
  black-powder.wav  -> black-powder firearm shot  (default gun sound)
  22-magnum.wav     -> .22 magnum pistol shot
  unknown-gun.wav   -> unidentified firearm shot
  Source: OpenGameArt.org "Gunshots" pack, released CC0 (NO RIGHTS RESERVED).
  Swap between them live with the "gun" dropdown in m3.html. Not satisfying? Replace with
  your own recording (any of the names below) and it auto-loads.

EXPECTED FILES (exact names):
  gun.ogg        -> gun/cannon firing  (short, punchy; ~0.3-1.0s)
  impact.ogg     -> shell hitting metal (short metallic clang)
  explosion.ogg  -> fuel/ammo cook-off  (big boom, ~0.6-1.5s)

Format: .ogg preferred (smallest, plays everywhere). .wav or .mp3 also work if you
rename the loader entries — but .ogg is the safe default for the browser.
Keep them SHORT and mono if possible; the game plays many overlapping shots.

WHERE TO GET PROPERLY-LICENSED HISTORICAL WEAPON SOUNDS
(use CC0 / public-domain / royalty-free; check each file's license before shipping):

  1. Freesound.org  — huge library; filter by license = "Creative Commons 0".
     Search: "cannon", "musket", "naval gun", "40mm", "field gun". (Free account to download.)
  2. Pixabay.com/sound-effects — royalty-free, no attribution required. Search "cannon", "gunshot".
  3. BBC Sound Effects (sound-effects.bbcrewind.co.uk) — thousands of recordings, free for
     personal/educational use (read their licence for anything public).
  4. Sonniss "GDC Game Audio Bundle" — large royalty-free packs aimed at game devs.
  5. The Recordist / gamesounds.xyz — curated free/royalty-free game SFX.

ATTRIBUTION: if a sound is CC-BY (not CC0), note the author + link here so credit ships
with the game. Example line:
  gun.ogg — "Cannon Shot" by <author>, CC-BY 4.0, <url>

WHY I (the assistant) DIDN'T AUTO-DOWNLOAD THESE:
  - Public-domain sources I can reach (Wikimedia) don't have clean, vettable weapon recordings.
  - I can't *hear* audio to judge quality, and I won't wire in copyrighted SFX.
  So: you pick recordings you can actually listen to and have rights to, drop them here, done.
  (If you paste a specific properly-licensed URL, I can fetch and wire that one for you.)
