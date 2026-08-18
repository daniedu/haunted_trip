package main

import rl "vendor:raylib"

process_player_inputs :: proc(player: ^Player, dt: f32) {
	// --- 1. Movement ---

	input_dir: rl.Vector2

	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {input_dir.x += 1}
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {input_dir.x -= 1}
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {input_dir.y += 1}
	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {input_dir.y -= 1}

	if input_dir.x != 0 && input_dir.y != 0 {
		input_dir = rl.Vector2Normalize(input_dir)
	}

	player.velocity = input_dir * player.move_speed
	player.position += player.velocity * dt

	// --- 2. Attack Timing & Input Logic ---
	if !player.is_attacking && rl.IsKeyPressed(.SPACE) {
		player.is_attacking = true

		stats := WEAPON_STATS[player.equipped_weapon]
		player.attack_duration = stats.attack_duration
		player.attack_timer = stats.attack_duration
	}
}
