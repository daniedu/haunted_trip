package main

import rl "vendor:raylib"

// Single-tileset dual-grid. Logical map is 16x16 @24px; display tiles are shifted
// by DUAL_OFFSET (-12) so each display tile straddles 4 logical cells.
// 4 corners -> 4-bit index -> 16 tiles ( Jess::codes / lexaloffle 152784 ).

DUAL_DEBUG_COLORS := [16]rl.Color {
	{  40,  40,  40, 255}, // 0000 empty
	{  80,  60,  40, 255}, // 0001
	{  60,  80,  40, 255}, // 0010
	{ 100,  80,  40, 255}, // 0011
	{  40,  80,  60, 255}, // 0100
	{  80, 100,  60, 255}, // 0101
	{  60,  60,  80, 255}, // 0110
	{ 120, 100,  60, 255}, // 0111
	{  40,  60,  80, 255}, // 1000
	{  80,  80, 100, 255}, // 1001
	{  60, 100,  80, 255}, // 1010
	{ 100, 100,  80, 255}, // 1011
	{  80,  40,  60, 255}, // 1100
	{ 120,  80,  60, 255}, // 1101
	{  80,  80,  60, 255}, // 1110
	{  60,  60,  60, 255}, // 1111 full
}

// Draw one tileset with autotiling. Every display tile draws - idx 0 is outer flat (e.g. grass),
// idx 15 is inner flat (e.g. dirt). No skip - empty areas show outer texture from same atlas.
draw_tileset :: proc(m: Map, set_id: int) {
	if set_id < 0 || set_id >= len(tileset_runtime) do return
	rt := tileset_runtime[set_id]
	for y in -1..<MAP_HEIGHT {
		for x in -1..<MAP_WIDTH {
			idx := get_dual_index_for_set(m, x, y, set_id)
			pos := rl.Vector2{f32(x * TILE_SIZE + DUAL_OFFSET), f32(y * TILE_SIZE + DUAL_OFFSET)}
			if rt.ready {
				src := tileset_get_rect_by_id(set_id, idx)
				rl.DrawTextureRec(rt.texture, src, pos, rl.WHITE)
			} else {
				// idx 0 now visible as outer flat (was transparent before)
				rl.DrawRectangleV(pos, {TILE_SIZE, TILE_SIZE}, DUAL_DEBUG_COLORS[idx])
				rl.DrawRectangleLinesEx({pos.x, pos.y, TILE_SIZE, TILE_SIZE}, 1, {0, 0, 0, 90})
			}
		}
	}
}
