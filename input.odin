package main

import rl "vendor:raylib"

process_player_inputs :: proc(player: ^Player, dt: f32) {

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
}
