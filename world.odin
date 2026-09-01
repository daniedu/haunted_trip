package main

import "core:math"
import rl "vendor:raylib"

GameState :: enum {
	Play,
	Edit,
}

// ---- Global sizing constants ----
TILE_SIZE :: 24
DUAL_OFFSET :: TILE_SIZE / 2 // 12
MAP_WIDTH :: 16
MAP_HEIGHT :: 16
CHUNK_SIZE :: 16

PLAYER_SIZE :: 32

// Single-tileset model: each cell is either empty (-1) or belongs to one tileset.
// For now we only use "oild" (set_id 0). Dual-grid shows transition between
// member and empty using the 16-tile atlas.
TileCell :: struct {
	set_id: int,
}

Map :: [MAP_HEIGHT][MAP_WIDTH]TileCell
EmptyCell :: TileCell {
	set_id = -1,
}

// Cell helpers - single source via tileset validation
tileset_is_valid :: proc(id: int) -> bool {return id >= 0 && id < len(TILESET_DECLS)}
cell_is_empty :: proc(c: TileCell) -> bool {return !tileset_is_valid(c.set_id)}
cell_is_solid :: proc(c: TileCell) -> bool {
	if cell_is_empty(c) do return false
	return TILESET_DECLS[c.set_id].is_solid
}
cell_is_slower :: proc(c: TileCell) -> bool {
	if cell_is_empty(c) do return false
	return TILESET_DECLS[c.set_id].is_slower
}
cell_color :: proc(c: TileCell) -> rl.Color {
	if cell_is_empty(c) do return rl.BLANK
	return TILESET_DECLS[c.set_id].color
}
cell_is_of_set :: proc(c: TileCell, set_id: int) -> bool {
	return !cell_is_empty(c) && c.set_id == set_id
}

get_cell_safe :: proc(m: Map, x, y: int) -> TileCell {
	if x < 0 || x >= MAP_WIDTH || y < 0 || y >= MAP_HEIGHT {
		return EmptyCell
	}
	return m[y][x]
}

// Single mask: 4 corners -> 4-bit index. Member = set_id present, empty = not.
get_dual_index_for_set :: proc(m: Map, x, y: int, set_id: int) -> u8 {
	b: u8 = 0
	if cell_is_of_set(get_cell_safe(m, x, y), set_id) {b |= 1}
	if cell_is_of_set(get_cell_safe(m, x + 1, y), set_id) {b |= 2}
	if cell_is_of_set(get_cell_safe(m, x, y + 1), set_id) {b |= 4}
	if cell_is_of_set(get_cell_safe(m, x + 1, y + 1), set_id) {b |= 8}
	return b
}

world_to_cell :: proc(pos: rl.Vector2) -> [2]int {
	return {int(math.floor(pos.x / f32(TILE_SIZE))), int(math.floor(pos.y / f32(TILE_SIZE)))}
}

cell_to_world :: proc(x, y: int) -> rl.Vector2 {
	return {f32(x * TILE_SIZE), f32(y * TILE_SIZE)}
}

make_cell :: proc(set_id: int) -> TileCell {
	if set_id < 0 do return EmptyCell
	return TileCell{set_id = set_id}
}
find_tileset_by_name :: proc(name: string) -> int {
	for decl, i in TILESET_DECLS {
		if decl.name == name do return i
	}
	return -1
}

make_default_map :: proc() -> Map {
	m: Map
	oild_id := find_tileset_by_name("oild")
	if oild_id < 0 do oild_id = 0
	for y in 0 ..< MAP_HEIGHT {
		for x in 0 ..< MAP_WIDTH {
			m[y][x] = TileCell {
				set_id = oild_id,
			}
		}
	}
	// 2x2 outer pocket shows autotile ring
	if MAP_WIDTH >= 8 && MAP_HEIGHT >= 8 {
		m[6][6] = EmptyCell
		m[6][7] = EmptyCell
		m[7][6] = EmptyCell
		m[7][7] = EmptyCell
	}
	return m
}
