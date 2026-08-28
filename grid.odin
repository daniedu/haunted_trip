package main

import rl "vendor:raylib"

// Double grid visualization: logical 24px + dual offset 12px + chunk 384px.
draw_grids :: proc(show_logical: bool, show_dual: bool, show_chunk: bool) {
	if !show_logical && !show_dual && !show_chunk do return

	map_px_w := MAP_WIDTH * TILE_SIZE
	map_px_h := MAP_HEIGHT * TILE_SIZE

	// Logical grid: every TILE_SIZE (24) - faint gray
	if show_logical {
		col := rl.Color{255, 255, 255, 28}
		for x in 0..=MAP_WIDTH {
			px := i32(x * TILE_SIZE)
			rl.DrawLine(px, 0, px, i32(map_px_h), col)
		}
		for y in 0..=MAP_HEIGHT {
			py := i32(y * TILE_SIZE)
			rl.DrawLine(0, py, i32(map_px_w), py, col)
		}
		// Map border stronger
		rl.DrawRectangleLinesEx({0, 0, f32(map_px_w), f32(map_px_h)}, 2, {255, 255, 255, 60})
	}

	// Dual offset grid: shifted +12, dashed imitation (every other segment alpha)
	if show_dual {
		col := rl.Color{120, 200, 255, 45}
		// vertical
		for x in -1..<MAP_WIDTH {
			px := i32(x * TILE_SIZE + DUAL_OFFSET)
			if px < 0 || px > i32(map_px_w) do continue
			rl.DrawLine(px, 0, px, i32(map_px_h), col)
		}
		for y in -1..<MAP_HEIGHT {
			py := i32(y * TILE_SIZE + DUAL_OFFSET)
			if py < 0 || py > i32(map_px_h) do continue
			rl.DrawLine(0, py, i32(map_px_w), py, col)
		}
	}

	// Chunk / 16-tile grid: every CHUNK_SIZE * TILE_SIZE (384)
	if show_chunk {
		col := rl.Color{255, 255, 0, 70}
		step := CHUNK_SIZE * TILE_SIZE
		for x := 0; x <= map_px_w; x += step {
			rl.DrawLine(i32(x), 0, i32(x), i32(map_px_h), col)
		}
		for y := 0; y <= map_px_h; y += step {
			rl.DrawLine(0, i32(y), i32(map_px_w), i32(y), col)
		}
		rl.DrawText("CHUNK 16x16 (384px)", 4, 4, 10, col)
	}
}
