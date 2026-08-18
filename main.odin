package main

import rl "vendor:raylib"

PIXEL_WINDOWS_HEIGHT :: 320


Direction :: enum {
	Up,
	Down,
	Left,
	Right,
}

WeaponType :: enum {
	None,
	Sword,
	Bow,
	Staff,
}

WeaponData :: struct {
	attack_duration: f32,
	range:           f32,
	damage:          int,
}

WEAPON_STATS := [WeaponType]WeaponData {
	.None = {attack_duration = 0.1, range = 8.0, damage = 1},
	.Sword = {attack_duration = 0.2, range = 14.0, damage = 5},
	.Bow = {attack_duration = 0.3, range = 25.0, damage = 4},
	.Staff = {attack_duration = 0.4, range = 18.0, damage = 6},
}

Player :: struct {
	position:        rl.Vector2,
	velocity:        rl.Vector2,
	facing:          Direction,
	move_speed:      f32,
	equipped_weapon: WeaponType,
	is_attacking:    bool,
	attack_timer:    f32,
	attack_duration: f32,
}

main :: proc() {

	rl.InitWindow(1920, 1080, "testinv")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)
	rl.SetWindowState({.WINDOW_RESIZABLE})


	player := Player {
		move_speed = 60,
	}

	map_grid := [5][5]TileType {
		{.Wall, .Wall, .Wall, .Wall, .Wall},
		{.Wall, .Floor, .Floor, .Floor, .Wall},
		{.Wall, .Floor, .Water, .Floor, .Wall},
		{.Wall, .Floor, .Floor, .Floor, .Wall},
		{.Wall, .Wall, .Wall, .Wall, .Wall},
	}

	tile_size := 32
	use_assets := false
	tileset := rl.Texture2D{}

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		process_player_inputs(&player, dt)


		// Drawing

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)

		camera := rl.Camera2D {
			zoom   = f32(rl.GetScreenHeight()) / PIXEL_WINDOWS_HEIGHT,
			offset = {f32(rl.GetScreenWidth() / 2) - 25, f32(rl.GetScreenHeight() / 2) - 25},
			target = player.position,
		}

		// ==========================================
		// 1. WORLD SPACE (Affected by Camera)
		// ==========================================

		rl.BeginMode2D(camera)

		for y in 0 ..< 5 {
			for x in 0 ..< 5 {
				draw_tile(map_grid[y][x], x, y, tile_size, use_assets, tileset)
			}
		}
		rl.DrawText("base", 0, 0, 12, rl.WHITE)
		rl.DrawRectangleV(player.position, 32, rl.GREEN)


		rl.EndMode2D()

		// ==========================================
		// 2. SCREEN SPACE / HUD (Fixed to Window)
		// ==========================================

		rl.DrawRectangle(0, rl.GetScreenHeight() - 20, rl.GetScreenWidth(), 20, rl.WHITE)

	}

}
