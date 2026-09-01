package main

import rl "vendor:raylib"

// Per-tileset inner/outer collision: wall is just is_solid=true on inner or outer of any set.
is_position_solid :: proc(pos: rl.Vector2, size: f32, m: Map) -> bool {
	padding :: 2.0
	player_rect := rl.Rectangle{
		x      = pos.x + padding,
		y      = pos.y + padding,
		width  = size - (padding * 2.0),
		height = size - (padding * 2.0),
	}
	for y in 0..<MAP_HEIGHT {
		for x in 0..<MAP_WIDTH {
			cell := m[y][x]
			if !cell_is_solid(cell) do continue
			tile_rect := rl.Rectangle{
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

is_position_slower :: proc(pos: rl.Vector2, size: f32, m: Map) -> bool {
	padding :: 2.0
	player_rect := rl.Rectangle{
		x      = pos.x + padding,
		y      = pos.y + padding,
		width  = size - (padding * 2.0),
		height = size - (padding * 2.0),
	}
	for y in 0..<MAP_HEIGHT {
		for x in 0..<MAP_WIDTH {
			cell := m[y][x]
			if !cell_is_slower(cell) do continue
			tile_rect := rl.Rectangle{
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

// Returns speed multiplier based on tile behavior: slower tiles reduce movement.
get_tile_speed_multiplier :: proc(pos: rl.Vector2, size: f32, m: Map) -> f32 {
	if is_position_slower(pos, size, m) {
		return 0.5 // 50% speed on slower tiles (water/mud). Tune per tileset later via TILE_DATABASE.slow_factor
	}
	return 1.0
}

update_player_collisions :: proc(player: ^Player, m: Map, dt: f32) {
	size :: f32(PLAYER_SIZE)

	// Apply slower multiplier before collision (per tileset behavior)
	speed_mult := get_tile_speed_multiplier(player.position, size, m)
	// velocity already includes input_dir * move_speed; scale dt by multiplier
	effective_dt := dt * speed_mult

	// X axis
	next_pos := player.position
	next_pos.x += player.velocity.x * effective_dt

	if !is_position_solid(next_pos, size, m) {
		player.position.x = next_pos.x
	} else {
		player.velocity.x = 0
		next_pos.x = player.position.x
	}

	// Y axis (use already-resolved X)
	next_pos.y += player.velocity.y * effective_dt

	if !is_position_solid(next_pos, size, m) {
		player.position.y = next_pos.y
	} else {
		player.velocity.y = 0
	}
}
