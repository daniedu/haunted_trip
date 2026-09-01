# haunted_trip

Chrono-Trigger style top-down with dual-grid autotiling (24px tiles, 32px chars) + in-game editor.

## Quick Start
```bash
odin run .               # or devenv up (watchexec)
# Play: WASD move, SPACE attack, TAB -> Edit
```

## Docs
- Architecture & dual-grid explanation: `docs/dual_grid_and_editor.md`
- References: `assets/references/REFERENCES.md` (lexaloffle 152784, Jess::codes)
- Git recovery after `.devenv` purge (other clones diverged): `docs/GIT_RECOVERY.md`

## Controls (Edit)
`LMB` paint `RMB` erase `MMB` pick | `1-4` `Floor/Wall/Water/Empty` `Q/E` cycle | `G` grids `H` chunk `P` preview | `S` save `L` load `C` clear `R` reset | `TAB` Play

## Assets
- Atlas row `384x24` = 16 tiles `0000..1111` at `assets/tiles/dual_row_24.png` (placeholder generated, replace with `oild_tiles.aseprite` export)
- Level JSON `assets/tiles/level_01.json` (16x16)
