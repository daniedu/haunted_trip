package main

import rl "vendor:raylib"

process_player_inputs :: proc(player: ^Player, dt: f32) {
	// --- 1. & Movement Logic ---
	input_dir: rl.Vector2
	// Track individual key presses to set precise facing
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
		input_dir.x += 1
		player.facing = .Right
	}
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
		input_dir.x -= 1
		player.facing = .Left
	}
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {
		input_dir.y += 1
		player.facing = .Down
	}
	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
		input_dir.y -= 1
		player.facing = .Up
	}

	// Normalize vector so diagonal movement isn't faster
	if input_dir.x != 0 && input_dir.y != 0 {
		input_dir = rl.Vector2Normalize(input_dir)
	}
	// if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {input_dir.x += 1}
	// if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {input_dir.x -= 1}
	// if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {input_dir.y += 1}
	// if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {input_dir.y -= 1}

	if input_dir.x != 0 && input_dir.y != 0 {
		input_dir = rl.Vector2Normalize(input_dir)
	}

	player.velocity = input_dir * player.move_speed
	// player.position += player.velocity * dt

	// --- 2. Attack Timing & Input Logic ---
	// Handle attack timer countdown
	if player.is_attacking {
		player.attack_timer -= dt
		if player.attack_timer <= 0 {
			player.is_attacking = false
		}
	}

	// Trigger attack on input (e.g., Spacebar)
	if !player.is_attacking && rl.IsKeyPressed(.SPACE) {
		player.is_attacking = true
		weapon_data := WEAPON_STATS[player.equipped_weapon]
		player.attack_timer = weapon_data.attack_duration
	}
}
