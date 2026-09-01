package main

import rl "vendor:raylib"

// Manual double-grid: world 16x16 logical + visual 17x17 offset tiles you place directly.
// No auto-tiling — you pick variant 0 outer, 15 inner, edges 1..14.

DUAL_DEBUG_COLORS := [16]rl.Color{
	{40, 40, 40, 255}, // 0 outer
	{80, 60, 40, 255},
	{60, 80, 40, 255},
	{100, 80, 40, 255},
	{40, 80, 60, 255},
	{80, 100, 60, 255},
	{60, 60, 80, 255},
	{120, 100, 60, 255},
	{40, 60, 80, 255},
	{80, 80, 100, 255},
	{60, 100, 80, 255},
	{100, 100, 80, 255},
	{80, 40, 60, 255},
	{120, 80, 60, 255},
	{80, 80, 60, 255},
	{60, 60, 60, 255}, // 15 inner
}

// Visual map is 17x17 at DUAL_OFFSET — nice offset looks.
draw_tilesets :: proc(m: VisualMap) {
	for y in 0..<VISUAL_H {
		for x in 0..<VISUAL_W {
			cell := m[y][x]
			if cell_is_empty(cell) do continue
			if cell.set_id < 0 || cell.set_id >= len(tileset_runtime) do continue
			rt := tileset_runtime[cell.set_id]
			pos := rl.Vector2{f32(x * TILE_SIZE + DUAL_OFFSET), f32(y * TILE_SIZE + DUAL_OFFSET)}
			if rt.ready {
				src := tileset_get_rect_by_id(cell.set_id, cell.variant)
				rl.DrawTextureRec(rt.texture, src, pos, rl.WHITE)
			} else {
				rl.DrawRectangleV(pos, {TILE_SIZE, TILE_SIZE}, DUAL_DEBUG_COLORS[cell.variant % 16])
				rl.DrawRectangleLinesEx({pos.x, pos.y, TILE_SIZE, TILE_SIZE}, 1, {0, 0, 0, 90})
			}
		}
	}
}

// Compat
draw_tileset :: proc(m: VisualMap, set_id: int) { draw_tilesets(m) }
