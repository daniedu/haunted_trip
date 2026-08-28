package main

import rl "vendor:raylib"

// Core dual-grid rendering.
// Logical map is 16x16 @24px; display tiles are shifted -DUAL_OFFSET (-12) so
// each display tile straddles 4 logical cells.
// Jess::codes / lexaloffle 152784: 4 corners -> 4-bit index -> 16-tile row.

// Fallback debug colors for 16 dual variants when no texture is loaded.
// Distinctish palette so you can verify the mask is correct without art.
DUAL_DEBUG_COLORS := [16]rl.Color {
	{  40,  40,  40, 255}, // 0000 empty / floor
	{  80,  60,  40, 255}, // 0001
	{  60,  80,  40, 255}, // 0010
	{ 100,  80,  40, 255}, // 0011
	{  40,  80,  60, 255}, // 0100
	{  80, 100,  60, 255}, // 0101 inner corner
	{  60,  60,  80, 255}, // 0110
	{ 120, 100,  60, 255}, // 0111
	{  40,  60,  80, 255}, // 1000
	{  80,  80, 100, 255}, // 1001
	{  60, 100,  80, 255}, // 1010
	{ 100, 100,  80, 255}, // 1011
	{  80,  40,  60, 255}, // 1100
	{ 120,  80,  60, 255}, // 1101
	{  80,  80,  60, 255}, // 1110
	{  60,  60,  60, 255}, // 1111 full solid
}

// Draw the dual-grid map offset by DUAL_OFFSET.
// If use_assets is true and tileset is valid, draws from row atlas.
// Otherwise draws colored debug rects so autotiling is visible without assets.
draw_dual_map :: proc(m: Map, tileset: rl.Texture2D, use_assets: bool) {
	// Loop covers -1 .. MAP_HEIGHT inclusive so edges at world origin get handled.
	// Display size = (MAP_WIDTH+1) x (MAP_HEIGHT+1) @24px offset -12.
	for y in -1..<MAP_HEIGHT {
		for x in -1..<MAP_WIDTH {
			idx := get_dual_index(m, x, y, is_wall)

			// Skip drawing empty background tile in fallback? We draw floor color for 0000.
			// For textured path we can skip 0000 to keep floor underneath.
			pos := rl.Vector2{f32(x * TILE_SIZE + DUAL_OFFSET), f32(y * TILE_SIZE + DUAL_OFFSET)}
			// Alternative formulation matching Jess: (x*TILE_SIZE - DUAL_OFFSET)
			// Both equivalent if we loop -1 offset. Use DUAL_OFFSET positive for clarity on edges.

			// Correct Jess formulation: display pos = logical cell pos - DUAL_OFFSET
			// Since we loop -1 start, we add DUAL_OFFSET. Simpler: recompute as:
			// pos = {(f32(x)*TILE_SIZE + f32(DUAL_OFFSET)), same for y}
			// Verify: x=-1 => -24+12=-12 correctly starts half tile before origin.

			if use_assets && rl.IsTextureReady(tileset) {
				if idx == 0 {
					// don't overdraw floor; floor is drawn separately or as background
					continue
				}
				src := DUAL_TILE_RECTS[idx]
				rl.DrawTextureRec(tileset, src, pos, rl.WHITE)
			} else {
				// Debug: draw all 16 variants as colored tiles with outline and index label
				// Use subtle variations to see autotile shape.
				color := DUAL_DEBUG_COLORS[idx]
				// For idx 0 draw slightly darker floor so grid still visible
				if idx == 0 {
					color = { 30, 30, 30, 255 }
				}
				rl.DrawRectangleV(pos, {TILE_SIZE, TILE_SIZE}, color)
				// Thin outline for tile boundaries
				rl.DrawRectangleLinesEx({pos.x, pos.y, TILE_SIZE, TILE_SIZE}, 1, {0, 0, 0, 90})
			}
		}
	}
}

// Draw logical floor underneath dual layer so 0000 tiles have background.
// Call before draw_dual_map when use_assets=false or when you want floor visible.
draw_logical_floor :: proc(m: Map, tileset: rl.Texture2D, use_assets: bool) {
	for y in 0..<MAP_HEIGHT {
		for x in 0..<MAP_WIDTH {
			tile := m[y][x]
			if tile == .Empty do continue
			// Floor and water get their own color; Wall floor is underlying floor
			if tile == .Floor || tile == .Water || tile == .Wall {
				def := TILE_DATABASE[tile]
				pos := rl.Vector2{f32(x * TILE_SIZE), f32(y * TILE_SIZE)}
				if tile == .Wall {
					// Wall cells still have floor background
					floor_def := TILE_DATABASE[.Floor]
					if use_assets && rl.IsTextureReady(tileset) {
						// use wall's source_rec for floor? fallback to color for now
						rl.DrawRectangleV(pos, {TILE_SIZE, TILE_SIZE}, floor_def.color)
					} else {
						rl.DrawRectangleV(pos, {TILE_SIZE, TILE_SIZE}, floor_def.color)
					}
				} else {
					if use_assets && rl.IsTextureReady(tileset) && def.source_rec.width != 0 {
						rl.DrawTextureRec(tileset, def.source_rec, pos, rl.WHITE)
					} else {
						rl.DrawRectangleV(pos, {TILE_SIZE, TILE_SIZE}, def.color)
						if tile == .Water {
							rl.DrawRectangleLinesEx({pos.x, pos.y, TILE_SIZE, TILE_SIZE}, 1, rl.DARKBLUE)
						}
					}
				}
			}
		}
	}
}
