package main

import rl "vendor:raylib"

// Check if a given world position + player size overlaps any solid logical tile.
// Purely logical grid - does NOT know about dual display offset.
is_position_solid :: proc(pos: rl.Vector2, size: f32, m: Map) -> bool {
	padding :: 2.0 // chrono 32px on 24px grid needs slightly larger inset to avoid snag

	player_rect := rl.Rectangle {
		x      = pos.x + padding,
		y      = pos.y + padding,
		width  = size - (padding * 2.0),
		height = size - (padding * 2.0),
	}

	// Brute force check against all tiles (16x16 =256 checks, trivial).
	// Later switch to AABB broadphase if maps get larger (e.g. 64x64+).
	for y in 0..<MAP_HEIGHT {
		for x in 0..<MAP_WIDTH {
			tile_type := m[y][x]
			if !TILE_DATABASE[tile_type].is_solid {
				continue
			}
			tile_rect := rl.Rectangle {
				x      = f32(x * TILE_SIZE),
				y      = f32(y * TILE_SIZE),
				width  = f32(TILE_SIZE),
				height = f32(TILE_SIZE),
			}
			if rl.CheckCollisionRecs(player_rect, tile_rect) {
				return true
			}
		}
	}
	return false
}

update_player_collisions :: proc(player: ^Player, m: Map, dt: f32) {
	size :: f32(PLAYER_SIZE)

	// X axis
	next_pos := player.position
	next_pos.x += player.velocity.x * dt

	if !is_position_solid(next_pos, size, m) {
		player.position.x = next_pos.x
	} else {
		player.velocity.x = 0
		next_pos.x = player.position.x
	}

	// Y axis (use already-resolved X)
	next_pos.y += player.velocity.y * dt

	if !is_position_solid(next_pos, size, m) {
		player.position.y = next_pos.y
	} else {
		player.velocity.y = 0
	}
}
