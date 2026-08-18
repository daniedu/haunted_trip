package main
import rl "vendor:raylib"

GameState :: enum {
	Play,
	Edit,
}

TileType :: enum {
	Empty = 0,
	Floor,
	Wall,
	Water,
}

TileDef :: struct {
	is_solid:   bool,
	color:      rl.Color,
	source_rec: rl.Rectangle,
}

TILE_DATABASE := [TileType]TileDef {
	.Empty = {is_solid = false, color = rl.BLANK},
	.Floor = {is_solid = false, color = rl.LIGHTGRAY, source_rec = {0, 0, 32, 32}},
	.Wall = {is_solid = true, color = rl.DARKGRAY, source_rec = {32, 0, 32, 32}},
	.Water = {is_solid = true, color = rl.BLUE, source_rec = {64, 0, 32, 32}},
}


draw_tile :: proc(
	tile_type: TileType,
	x, y: int,
	tile_size: int,
	use_assets: bool,
	tileset: rl.Texture2D,
) {
	if tile_type == .Empty do return

	// Retrieve properties using a clean switch statement
	is_solid: bool
	color: rl.Color
	source_rec: rl.Rectangle

	switch tile_type {
	case .Empty:
		return
	case .Floor:
		is_solid = false
		color = rl.LIGHTGRAY
		source_rec = {0, 0, 32, 32}
	case .Wall:
		is_solid = true
		color = rl.DARKGRAY
		source_rec = {32, 0, 32, 32}
	case .Water:
		is_solid = true
		color = rl.BLUE
		source_rec = {64, 0, 32, 32}
	}

	pos := rl.Vector2{f32(x * tile_size), f32(y * tile_size)}

	if use_assets {
		rl.DrawTextureRec(tileset, source_rec, pos, rl.WHITE)
	} else {
		rl.DrawRectangle(i32(pos.x), i32(pos.y), i32(tile_size), i32(tile_size), color)
		rl.DrawRectangleLines(i32(pos.x), i32(pos.y), i32(tile_size), i32(tile_size), rl.BLACK)
	}
}
