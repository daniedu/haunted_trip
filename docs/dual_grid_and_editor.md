# Haunted Trip — Dual-Grid 24px + Editor Architecture

This doc explains the new code added for the half-tile dual-grid (Jess::codes / lexaloffle 152784) and the in-game level editor. Sizes are tuned for Chrono-Trigger style: `32px` characters on `24px` tiles.

References: `https://www.lexaloffle.com/bbs/?pid=152784`, Jess::codes `https://www.youtube.com/watch?v=jEWFSv3ivTg`, `assets/references/REFERENCES.md`.

---

## 1. Global Sizing (`world.odin:11-20`)

```odin
TILE_SIZE   :: 24          // logical tile
DUAL_OFFSET :: TILE_SIZE/2 // 12 — half tile shift for display grid
MAP_WIDTH   :: 16           // 16x16 chunk = 384x384 px
MAP_HEIGHT  :: 16
CHUNK_SIZE  :: 16           // for major grid lines
PLAYER_SIZE :: 32
Map :: [MAP_HEIGHT][MAP_WIDTH]TileType
```

All world math uses these. No more magic `32` literals. Changing `TILE_SIZE` auto-updates collision (`collision.odin:26`), drawing (`world.odin:115`, `dual.odin:43`), and grid (`grid.odin:16`).

Tile types (`world.odin:22-27`):

```odin
TileType :: enum u8 { Empty=0, Floor=1, Wall=2, Water=3 }
```

`TILE_DATABASE` (`world.odin:35-40`) holds `is_solid`, `color`, and `source_rec` (now `24x24`, not `32`). Add new terrains by extending both.

---

## 2. Dual-Grid Concept

You paint **logical grid** (`Map`) = cheap `Floor/Wall/Water`. The **display grid** is shifted `-DUAL_OFFSET` (`-12, -12`) so each display tile straddles `2x2` logical cells.

```
logical cells (24px)      display tile (24px) at -12 offset
+----+----+               +----+
|    |    |  -> overlap ->| TL TR |
+----+----+               | BL BR |
|    |    |               +----+
```

Four corners → `4-bit` mask → `0..15` → one of 16 autotiles.

Bit order in `world.odin:88-94` matches lexaloffle `grass_grid_to_row_binary_offset.png`:

```odin
b |= 1 if TL (x,y) is solid
b |= 2 if TR (x+1,y) is solid
b |= 4 if BL (x,y+1) is solid
b |= 8 if BR (x+1,y+1) is solid
// 0000 = floor interior, 1111 = full solid
```

Full set = `16` tiles. Reduced `6/7` sets (rotate/flip) are possible later; raylib has no `spr()` rotate so we ship full `16` first — same choice as noesisra.

Out-of-bounds helper `get_tile_safe()` (`world.odin:78`) returns `.Empty` so map edges auto-close.

---

## 3. File Breakdown

### `world.odin`
- Constants, `TileType`, `TileDef`, `TILE_DATABASE`, `DUAL_TILE_RECTS: [16]Rectangle` (`world.odin:45`) — single row atlas `384x24`. Each rect `{i*24,0,24,24}`.
- Predicates `is_tile_solid` / `is_wall` / `is_water` (`world.odin:64-75`) — pass to `get_dual_index` to autotile each layer separately.
- `get_dual_index(m,x,y,solid_proc)` (`world.odin:88`) — core of Jess system.
- `world_to_cell(pos)` (`world.odin:97`) — `floor(pos/TILE_SIZE)` handles negative `-12` correctly. `cell_to_world()` inverse.
- `draw_tile()` (`world.odin:107`) — legacy 1:1 logical draw, used when `show_dual_preview=false`.
- `make_default_map()` (`world.odin:130`) — bordered `Floor` + `Wall` frame + demo `Wall` blob at `(4,4)` + `Water` lake at `(6,6)`.

### `dual.odin`
Core autotile renderer. No game logic.

- `DUAL_DEBUG_COLORS[16]` (`dual.odin:12`) — distinct colors for each mask so autotile shape is visible without art.
- `draw_dual_map(m, tileset, use_assets)` (`dual.odin:34`):
  ```odin
  for y in -1..<MAP_HEIGHT { for x in -1..<MAP_WIDTH {
      idx := get_dual_index(m,x,y,is_wall)
      pos := {f32(x*TILE_SIZE+DUAL_OFFSET), f32(y*TILE_SIZE+DUAL_OFFSET)}
      // x=-1 => -12 correct Jess offset; x=15 => 372+24 covers edge
      if use_assets && IsTextureReady {
          if idx==0 do continue // keep floor
          src := DUAL_TILE_RECTS[idx]
          DrawTextureRec(tileset,src,pos,WHITE)
      } else {
          DrawRectangleV(pos,{TILE_SIZE,TILE_SIZE},DEBUG_COLORS[idx])
      }
  }}
  ```
  Note: display size = `(MAP+1)*TILE`. Textured path skips `0000` to avoid overdraw.

- `draw_logical_floor(m,...)` (`dual.odin:77`) — draws floor underneath dual so `0000` has background. Must be called before `draw_dual_map` (`main.odin:140`). Wall cells get floor color too.

### `grid.odin`
Visualization only, no logic. All inside `BeginMode2D`.

- `draw_grids(show_logical, show_dual, show_chunk)` (`grid.odin:6`):
  - logical: every `TILE_SIZE` faint white `28` alpha + border `60` (`grid.odin:13-24`).
  - dual: every `TILE_SIZE+DUAL_OFFSET` blue `45` alpha, loop `-1..<MAP` (`grid.odin:28-41`).
  - chunk: every `CHUNK_SIZE*TILE_SIZE` = `384` yellow `70` + label (`grid.odin:44-54`).

Toggled via editor `G` (logical+dual) and `H` (chunk).

### `collision.odin`
Overwritten for `24px` logical grid. **Never** uses dual positions.

- `is_position_solid(pos,size,m)` (`collision.odin:7`) — builds `player_rect` inset `padding=2.0` (needed for `32px` char on `24px` grid to avoid snag), brute-checks all `256` tiles against `TILE_DATABASE[t].is_solid` via `CheckCollisionRecs`.
  ```odin
  tile_rect := {x*TILE_SIZE, y*TILE_SIZE, TILE_SIZE, TILE_SIZE}
  ```
- `update_player_collisions(player,m,dt)` (`collision.odin:39`) — axis-split: resolve `X` then `Y` using `already-resolved X`, zero velocity on hit. Called only in `Play`; Edit uses free cam.

### `level.odin`
Persistence, no raylib. Separated per your “not all in 1 file”.

- `LEVEL_PATH :: "assets/tiles/level_01.json"` (`level.odin:7`).
- `LevelData { version, width, height, tiles: [][]u8 }` (`level.odin:9`) — row-major `u8` TileTypes.
- `save_level(path,m)` (`level.odin:16`) — `tiles[MAP_HEIGHT]→json.marshal(pretty)` → `os.write_entire_file` → `1.7KB` file.
- `load_level(path, ^m)` (`level.odin:58`) — `os.read_entire_file_from_path` → `json.unmarshal` → crop/pad copy + clamp `v <= Water` else `Floor`. Prints size mismatch warning.

Auto-load at startup `main.odin:28`; editor `S/L` (`editor.odin:100-109`).

### `editor.odin`
In-game editor (no separate executable as requested).

- `EditorState` (`editor.odin:6`): `selected`, `hover_cell:[2]int`, `is_hover_valid`, `show_logical/show_dual/show_chunk/show_dual_preview`, `status_msg/timer`.
- `editor_init()` (`editor.odin:18`) defaults `Wall`, grids on, preview on.
- `editor_update(&s,&m,camera,dt)` (`editor.odin:36`):
  - Hover: `GetScreenToWorld2D(GetMousePosition(), camera)` → `world_to_cell` → `inside` check.
  - Paint: `LMB` hold → `m[cell]=selected`; `RMB` → `Floor` (erase); `MMB` → eyedrop `selected=m[cell]`.
  - Keys: `1-4` `Floor/Wall/Water/Empty`, `Q/E` or wheel cycle enum, `G` toggle logical+dual, `H` chunk, `P` preview, `S` save, `L` load, `C` clear to Floor, `R` reset `make_default_map()`. Status text via `editor_set_status` (`editor.odin:31`) 3s timer.
- `editor_draw_world_hover(s)` (`editor.odin:121`) — inside `BeginMode2D`: faint fill `30` + white 2px outline + coord label.
- `editor_draw_palette(s,m)` (`editor.odin:137`) — **outside** `BeginMode2D` screen-space: top bar `56px` black `180`, 4 swatches `32px` + yellow highlight for selected, right-side hints, bottom bar `22px` hover `Tile + DualIdx: get_dual_index(m,hover,is_wall)` + mode.

### `main.odin`
Thin orchestrator.

- `PIXEL_WINDOWS_HEIGHT=320` camera zoom `GetScreenHeight()/320` (`main.odin:119`).
- Init: `map_grid := make_default_map()` (`main.odin:25`), auto-load `level_01.json` (`main.odin:28`), tileset probe `dual_row_24.png` → `dual_row.png` → `oild_tiles.png` (`main.odin:37-55`) fallback debug colors.
- State: `GameState.Play/Edit` (`world.odin:6`), global `TAB` toggle (`main.odin:68`), `F1` recenter.
- Per-frame: `Play` → `process_player_inputs` (`input.odin:5`) + `update_player_collisions`; `Edit` → WASD free cam `200px/s` (`main.odin:93-97`) + `editor_update` with temp camera (`main.odin:104-109`).
- Camera: `Play` targets `player+PLAYER_SIZE/2`, `Edit` targets `free_cam_pos` (`main.odin:113-122`).
- Drawing ( `main.odin:125-183` ): `BeginDrawing` → `ClearBackground {18,18,22}` → `BeginMode2D(camera)`:
  1. map background `-20` pad,
  2. `draw_logical_floor`,
  3. `draw_dual_map` if preview or Play else raw `draw_tile` for walls,
  4. `draw_grids`,
  5. `editor_draw_world_hover` if Edit,
  6. player `32` green + white center dot + weapon red + origin yellow,
  7. `EndMode2D`
  8. HUD: `editor_draw_palette` if Edit else Play header + `mode_col` indicator + `DEBUG COLORS` warning if `!use_assets`.

### `player.odin`, `input.odin`, `weapons.odin`
Unchanged logic except `world.odin:18` `PLAYER_SIZE` now global. `input.odin:5` WASD+normalize+attack timer, `weapons.odin:27` `get_weapon_rect` uses `player_size 32` (matches `PLAYER_SIZE`).

---

## 4. Rendering Pipeline in One Frame

```
BeginDrawing → Clear
  BeginMode2D(camera)
    DrawRectangle(-20)                // outer bg
    draw_logical_floor()              // Floor/Water + Wall-under-floor
    draw_dual_map() or raw walls      // 17x17 shifted autotiles (or 16x16 raw)
    draw_grids()                      // logical/dark + dual blue + chunk yellow
    editor_draw_world_hover() if Edit
    DrawRectangleV(player,32) + weapon
    DrawCircle(origin)
  EndMode2D
  if Edit: editor_draw_palette(top+bottom bars)
  else: Play HUD
  DrawText(mode [TAB] + debug hint)
EndDrawing
```

Collision and editor logic use **logical** `Map` only; dual is pure visual.

---

## 5. Art Pipeline (16 tiles by 24px)

Export `assets/tiles/oild_tiles.aseprite` → PNG row `384x24` ( `16*24` ) ordered `0000..1111` left→right as `DUAL_TILE_RECTS` expects (`world.odin:45`). Placeholder `assets/tiles/dual_row_24.png` (`286B`) is generated from `DUAL_DEBUG_COLORS` — replace when real art ready. If no texture, code falls back to colors (`main.odin:210`).

Second row per terrain later: `y=24` for Water etc. Reduced `7`-tile flip set needs `DrawTexturePro` with negative `source_rec.width` — deferred.

---

## 6. Level File Example (`assets/tiles/level_01.json`)

```json
{
  "version": 1,
  "width": 16,
  "height": 16,
  "tiles": [
    [2,2,2,...], // 2=Wall 1=Floor 3=Water 0=Empty
    [2,1,1,...],
    ...
  ]
}
```

Edit via editor or by hand; `load_level` crops/pads if compiled `MAP` size changes.

---

## 7. Controls

| Mode | Key | Action |
|------|-----|--------|
| Global | `TAB` | Play ↔ Edit |
| Play | `WASD`/Arrows | Move (60→90 speed) |
| Play | `SPACE` | Attack (weapon rect red) |
| Play/Edit | `F1` | Recenter camera on player |
| Edit | `WASD` | Pan free cam `200` |
| Edit | `LMB` hold | Paint `selected` |
| Edit | `RMB` | Erase → `Floor` |
| Edit | `MMB` | Eyedrop |
| Edit | `1` `2` `3` `4` | `Floor` `Wall` `Water` `Empty` |
| Edit | `Q`/`E` / wheel | Cycle tiles |
| Edit | `G` | Toggle logical+dual grids |
| Edit | `H` | Toggle chunk 384 grid |
| Edit | `P` | Toggle dual preview |
| Edit | `S` | Save `level_01.json` |
| Edit | `L` | Load `level_01.json` |
| Edit | `C` | Clear to `Floor` |
| Edit | `R` | Reset default map |

Hover bar shows `Hover x,y | Tile | Selected | DualIdx` (`editor.odin:193`).

---

## 8. Build & Verify

```bash
odin check .                    # type check
odin build . -out:/tmp/haunted_trip_check # -> 614KB binary
# run
odin run .
# or via devenv
watchexec -e odin --no-default-ignore --restart -- odin run .
```

No `xvfb` needed for check/build. If window fails headless, `check` still validates.

---

## 9. Future — Decorations etc.

As you noted later: add second autotile pass for `Water` (`get_dual_index(...,is_water)` on top of walls) with transparent tiles per noesisra, plus decoration layer `decor: [MAP_HEIGHT][MAP_WIDTH]DecorType` drawn after dual but before player, without affecting `collision.odin`. Editor palette expands to `decor` swatches, separate `LEVEL_PATH_Decor` or same JSON with extra field.

File split stays: `decor.odin` for defs/draw, `editor.odin` adds `selected_decor`, `level.odin` marshals extra array.

---

## 10. Git Tree

```
d2c7848 feat: dual-grid 24px + editor + level I/O (separated files)
00683c9 baseline: set tile_size 16 before dual-grid migration
```

Separated files per request: `dual.odin` / `grid.odin` / `level.odin` / `editor.odin` / `world.odin` / `collision.odin` / `main.odin`.
