package main

import rl "vendor:raylib"

// Check if a given rectangle overlaps any solid tile in the map
is_position_solid :: proc(pos: rl.Vector2, size: f32, map_grid: [5][5]TileType) -> bool {
	// 3-pixel inset padding prevents corners from snagging and jittering against walls
	padding :: 3.0

	player_rect := rl.Rectangle {
		y      = pos.y + padding,
		x      = pos.x + padding,
		width  = 32.0 - (padding * 2.0),
		height = 32.0 - (padding * 2.0),
	}

	// Loop through the 5x5 map grid
	for y in 0 ..< 5 {
		for x in 0 ..< 5 {
			tile_type := map_grid[y][x]
			if TILE_DATABASE[tile_type].is_solid {
				tile_rect := rl.Rectangle {
					x      = f32(x * 32),
					y      = f32(y * 32),
					width  = 32.0,
					height = 32.0,
				}

				// Check if the player rectangle overlaps this solid wall tile
				if rl.CheckCollisionRecs(player_rect, tile_rect) {
					return true
				}
			}
		}
	}
	return false
}

update_player_collisions :: proc(player: ^Player, map_grid: [5][5]TileType, dt: f32) {
	// 1. Handle X axis movement safely
	next_x_pos := player.position
	next_x_pos.x += player.velocity.x * dt

	if !is_position_solid(next_x_pos, 32, map_grid) {
		player.position.x = next_x_pos.x
	} else {
		player.velocity.x = 0
	}

	// 2. Handle Y axis movement safely
	next_y_pos := player.position
	next_y_pos.y += player.velocity.y * dt

	if !is_position_solid(next_y_pos, 32, map_grid) {
		player.position.y = next_y_pos.y
	} else {
		player.velocity.y = 0
	}
}
