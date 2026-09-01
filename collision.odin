package main

import rl "vendor:raylib"

// Manual collision: you paint 16x16 solid cells in collision editor.
// Tiles and collision are separate — simplest way to start.

_player_rect :: proc(pos: rl.Vector2, size: f32) -> rl.Rectangle {
	padding :: 2.0
	return {pos.x + padding, pos.y + padding, size - padding*2, size - padding*2}
}

is_position_solid :: proc(pos: rl.Vector2, size: f32, m: CollisionMap) -> bool {
	rect := _player_rect(pos, size)
	for y in 0..<MAP_HEIGHT {
		for x in 0..<MAP_WIDTH {
			if !m[y][x] do continue
			tile := rl.Rectangle{f32(x * TILE_SIZE), f32(y * TILE_SIZE), TILE_SIZE, TILE_SIZE}
			if rl.CheckCollisionRecs(rect, tile) do return true
		}
	}
	return false
}

// Slower kept simple: same solid map slows, or separate slower map later
is_position_slower :: proc(pos: rl.Vector2, size: f32, m: CollisionMap) -> bool {
	return false
}

get_tile_speed_multiplier :: proc(pos: rl.Vector2, size: f32, m: CollisionMap) -> f32 {
	if is_position_slower(pos, size, m) do return 0.5
	return 1.0
}

update_player_collisions :: proc(player: ^Player, m: CollisionMap, dt: f32) {
	size :: f32(PLAYER_SIZE)
	speed_mult := get_tile_speed_multiplier(player.position, size, m)
	effective_dt := dt * speed_mult

	next_pos := player.position
	next_pos.x += player.velocity.x * effective_dt
	if !is_position_solid(next_pos, size, m) {
		player.position.x = next_pos.x
	} else {
		player.velocity.x = 0
		next_pos.x = player.position.x
	}

	next_pos.y += player.velocity.y * effective_dt
	if !is_position_solid(next_pos, size, m) {
		player.position.y = next_pos.y
	} else {
		player.velocity.y = 0
	}
}
