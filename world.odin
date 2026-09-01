package main

import "core:math"
import rl "vendor:raylib"

GameState :: enum {
	Play,
	Edit,
}

TILE_SIZE   :: 24
DUAL_OFFSET :: TILE_SIZE / 2 // 12 — visual grid is offset so tiles look nice
MAP_WIDTH   :: 16
MAP_HEIGHT  :: 16
VISUAL_W    :: MAP_WIDTH + 1  // 17
VISUAL_H    :: MAP_HEIGHT + 1 // 17
CHUNK_SIZE  :: 16

PLAYER_SIZE :: 32

// Visual tiles: double-grid offset 17x17, you place variant 0..15 directly.
// This is what you see — nice offset.
EMPTY_TILE :: -1

TileCell :: struct {
	set_id:  int, // -1 = empty, 0..len(TILESET_DECLS)-1
	variant: u8,  // 0..15 (outer 0000 → inner 1111) — like PNG
}

VisualMap :: [VISUAL_H][VISUAL_W]TileCell
EmptyCell :: TileCell{set_id = EMPTY_TILE, variant = 0}

// Collision: separate 16x16 manual grid — you paint solid where you want block.
CollisionMap :: [MAP_HEIGHT][MAP_WIDTH]bool

tileset_is_valid :: proc(id: int) -> bool {return id >= 0 && id < len(TILESET_DECLS)}
cell_is_empty  :: proc(c: TileCell) -> bool {return !tileset_is_valid(c.set_id)}

get_visual_safe :: proc(m: VisualMap, x, y: int) -> TileCell {
	if x < 0 || x >= VISUAL_W || y < 0 || y >= VISUAL_H do return EmptyCell
	return m[y][x]
}

get_collision_safe :: proc(m: CollisionMap, x, y: int) -> bool {
	if x < 0 || x >= MAP_WIDTH || y < 0 || y >= MAP_HEIGHT do return false
	return m[y][x]
}

world_to_cell :: proc(pos: rl.Vector2) -> [2]int {
	return {int(math.floor(pos.x / f32(TILE_SIZE))), int(math.floor(pos.y / f32(TILE_SIZE)))}
}

world_to_visual :: proc(pos: rl.Vector2) -> [2]int {
	// visual grid is offset by DUAL_OFFSET
	return {int(math.floor((pos.x - DUAL_OFFSET) / f32(TILE_SIZE))), int(math.floor((pos.y - DUAL_OFFSET) / f32(TILE_SIZE)))}
}

cell_to_world :: proc(x, y: int) -> rl.Vector2 {
	return {f32(x * TILE_SIZE), f32(y * TILE_SIZE)}
}

make_cell :: proc(set_id: int, variant: u8 = 15) -> TileCell {
	if !tileset_is_valid(set_id) do return EmptyCell
	return TileCell{set_id = set_id, variant = variant % 16}
}

make_default_visual :: proc() -> VisualMap {
	m: VisualMap
	// start empty (void) — you paint what you want
	return m
}

make_default_collision :: proc() -> CollisionMap {
	m: CollisionMap
	// small demo wall at 6,6 2x2
	if MAP_WIDTH >= 8 && MAP_HEIGHT >= 8 {
		m[6][6] = true
		m[6][7] = true
		m[7][6] = true
		m[7][7] = true
	}
	return m
}

// Kept for compat — old Map was 16x16 TileCell, now Visual is 17x17
Map :: VisualMap
make_default_map :: proc() -> VisualMap { return make_default_visual() }
