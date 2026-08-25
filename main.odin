package main

import "core:fmt"
import rl "vendor:raylib"

PIXEL_WINDOWS_HEIGHT :: 320

main :: proc() {

	rl.InitWindow(1920, 1080, "testinv")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)
	rl.SetWindowState({.WINDOW_RESIZABLE})

	game_state := GameState.Play

	player := Player {
		move_speed      = 60,
		equipped_weapon = .None,
	}

	map_grid := [5][5]TileType {
		{.Floor, .Floor, .Wall, .Wall, .Wall},
		{.Floor, .Floor, .Floor, .Floor, .Wall},
		{.Wall, .Floor, .Water, .Floor, .Wall},
		{.Wall, .Floor, .Floor, .Floor, .Wall},
		{.Wall, .Wall, .Wall, .Wall, .Wall},
	}

	tile_size := 32
	use_assets := false
	tileset := rl.Texture2D{}

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		// GAME STATE
		switch game_state {

		case .Play:
			process_player_inputs(&player, dt)
			update_player_collisions(&player, map_grid, dt)

		case .Edit:
			// TODO: Handle mouse clicking to place tiles on the map_grid
			if rl.IsMouseButtonPressed(.LEFT) {
				// Edit logic here...
			}
		}

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
		if player.is_attacking {
			weapon_rect := get_weapon_rect(player)

			// Draw the active weapon slash for debugging/feedback
			rl.DrawRectangleRec(weapon_rect, rl.RED)

			// TODO: Loop through enemies and check:
			// if rl.CheckCollisionRecs(weapon_rect, enemy.rect) { deal_damage(...) }
		}

		rl.EndMode2D()

		// ==========================================
		// 2. SCREEN SPACE / HUD (Fixed to Window)
		// ==========================================

		text_player_pos := fmt.ctprintf(
			"Player X: %.1f, Y: %.1f, MV: %.1f",
			player.position.x,
			player.position.y,
			player.move_speed,
		)
		rl.DrawText(text_player_pos, 0, 0, 12, rl.WHITE)

		text_player_data := fmt.ctprintf(
			"Player is_attacking: %, weapon: %",
			player.is_attacking,
			player.equipped_weapon,
		)
		rl.DrawText(text_player_data, 0, 12, 12, rl.WHITE)
		// rl.DrawRectangle(
		// 	0,
		// 	rl.GetScreenHeight() - rl.GetScreenHeight() / 4,
		// 	rl.GetScreenWidth(),
		// 	rl.GetScreenHeight() / 4,
		// 	rl.WHITE,
		// )

	}

}
