package main

import "core:math"
import rl "vendor:raylib"

GameState :: enum {
	Play,
	Edit,
}

// ---- Global sizing constants ----
TILE_SIZE     :: 24
DUAL_OFFSET   :: TILE_SIZE / 2 // 12
MAP_WIDTH     :: 16
MAP_HEIGHT    :: 16
CHUNK_SIZE    :: 16 // tiles per chunk (384px)

PLAYER_SIZE   :: 32

Map :: [MAP_HEIGHT][MAP_WIDTH]TileType

TileType :: enum u8 {
	Empty = 0,
	Floor = 1,
	Wall  = 2,
	Water = 3,
}

TileDef :: struct {
	is_solid:   bool,
	color:      rl.Color,
	source_rec: rl.Rectangle,
}

TILE_DATABASE := [TileType]TileDef {
	.Empty = {is_solid = false, color = rl.BLANK,               source_rec = {0, 0, 0, 0}},
	.Floor = {is_solid = false, color = rl.LIGHTGRAY,           source_rec = {0, 0, 24, 24}},
	.Wall  = {is_solid = true,  color = rl.DARKGRAY,            source_rec = {24, 0, 24, 24}},
	.Water = {is_solid = true,  color = {  64, 120, 255, 255 }, source_rec = {48, 0, 24, 24}},
}

// 16 dual-tile source rects for a single row atlas 384x24.
// Index = bitmask 0000..1111 (TL=1, TR=2, BL=4, BR=8).
// Layout matches lexaloffle 152784 grass_grid_to_row_binary_offset.png
DUAL_TILE_RECTS := [16]rl.Rectangle{
	{  0*24, 0, 24, 24 }, // 0000 empty / floor interior
	{  1*24, 0, 24, 24 }, // 0001
	{  2*24, 0, 24, 24 }, // 0010
	{  3*24, 0, 24, 24 }, // 0011
	{  4*24, 0, 24, 24 }, // 0100
	{  5*24, 0, 24, 24 }, // 0101
	{  6*24, 0, 24, 24 }, // 0110
	{  7*24, 0, 24, 24 }, // 0111
	{  8*24, 0, 24, 24 }, // 1000
	{  9*24, 0, 24, 24 }, // 1001
	{ 10*24, 0, 24, 24 }, // 1010
	{ 11*24, 0, 24, 24 }, // 1011
	{ 12*24, 0, 24, 24 }, // 1100
	{ 13*24, 0, 24, 24 }, // 1101
	{ 14*24, 0, 24, 24 }, // 1110
	{ 15*24, 0, 24, 24 }, // 1111 full solid
}

// Simple predicate helpers for dual sampling
is_tile_solid :: proc(t: TileType) -> bool {
	return TILE_DATABASE[t].is_solid
}

is_wall :: proc(t: TileType) -> bool {
	return t == .Wall
}

is_water :: proc(t: TileType) -> bool {
	return t == .Water
}

// Safe map accessor: out-of-bounds => Empty
get_tile_safe :: proc(m: Map, x, y: int) -> TileType {
	if x < 0 || x >= MAP_WIDTH || y < 0 || y >= MAP_HEIGHT {
		return .Empty
	}
	return m[y][x]
}

// Dual-grid 4-bit index. Checks 2x2 logical cells around display tile (x,y).
// x,y are display coordinates (-1 .. MAP_WIDTH) referencing logical origin.
// solid_proc lets us autotile Wall vs Water separately.
get_dual_index :: proc(m: Map, x, y: int, solid_proc: proc(TileType) -> bool) -> u8 {
	b: u8 = 0
	if solid_proc(get_tile_safe(m, x,     y))     { b |= 1 } // TL
	if solid_proc(get_tile_safe(m, x + 1, y))     { b |= 2 } // TR
	if solid_proc(get_tile_safe(m, x,     y + 1)) { b |= 4 } // BL
	if solid_proc(get_tile_safe(m, x + 1, y + 1)) { b |= 8 } // BR
	return b
}

world_to_cell :: proc(pos: rl.Vector2) -> [2]int {
	// floor division to handle negative world coords (dual offset -12)
	return {int(math.floor(pos.x / f32(TILE_SIZE))), int(math.floor(pos.y / f32(TILE_SIZE)))}
}

cell_to_world :: proc(x, y: int) -> rl.Vector2 {
	return {f32(x * TILE_SIZE), f32(y * TILE_SIZE)}
}

// Legacy 1:1 logical tile draw (used for editor debug / fallback)
draw_tile :: proc(
	tile_type: TileType,
	x, y: int,
	use_assets: bool,
	tileset: rl.Texture2D,
) {
	if tile_type == .Empty do return
	def := TILE_DATABASE[tile_type]
	pos := rl.Vector2{f32(x * TILE_SIZE), f32(y * TILE_SIZE)}

	if use_assets && def.source_rec.width != 0 && def.source_rec.height != 0 {
		rl.DrawTextureRec(tileset, def.source_rec, pos, rl.WHITE)
	} else {
		if tile_type == .Floor {
			rl.DrawRectangle(i32(pos.x), i32(pos.y), TILE_SIZE, TILE_SIZE, def.color)
		} else {
			rl.DrawRectangle(i32(pos.x), i32(pos.y), TILE_SIZE, TILE_SIZE, def.color)
			rl.DrawRectangleLines(i32(pos.x), i32(pos.y), TILE_SIZE, TILE_SIZE, rl.BLACK)
		}
	}
}

// Creates a default bordered map for quick testing
make_default_map :: proc() -> Map {
	m: Map
	for y in 0..<MAP_HEIGHT {
		for x in 0..<MAP_WIDTH {
			if x == 0 || y == 0 || x == MAP_WIDTH-1 || y == MAP_HEIGHT-1 {
				m[y][x] = .Wall
			} else {
				m[y][x] = .Floor
			}
		}
	}
	// small lake / interior walls to showcase dual grid
	if MAP_WIDTH >= 8 && MAP_HEIGHT >= 8 {
		m[4][4] = .Wall
		m[4][5] = .Wall
		m[5][4] = .Wall
		m[6][6] = .Water
		m[6][7] = .Water
		m[7][6] = .Water
		m[7][7] = .Water
	}
	return m
}
