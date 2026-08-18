package main

import rl "vendor:raylib"

PIXEL_WINDOWS_HEIGHT :: 60

Player :: struct {
	position:   rl.Vector2,
	velocity:   rl.Vector2,
	move_speed: f32,
}

main :: proc() {

	rl.InitWindow(1920, 1080, "testinv")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)
	rl.SetWindowState({.WINDOW_RESIZABLE})


	player := Player {
		move_speed = 25,
	}

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		process_player_inputs(&player, dt)


		// Drawing

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)

		camera := rl.Camera2D {
			zoom   = f32(rl.GetScreenHeight()) / PIXEL_WINDOWS_HEIGHT,
			offset = {f32(rl.GetScreenWidth() / 2) + 10, f32(rl.GetScreenHeight() / 2)} + 10,
			target = player.position,
		}

		// ==========================================
		// 1. WORLD SPACE (Affected by Camera)
		// ==========================================

		rl.BeginMode2D(camera)

		rl.DrawText("base", 0, 0, 12, rl.WHITE)
		rl.DrawRectangleV(player.position, 10, rl.GREEN)

		rl.EndMode2D()

		// ==========================================
		// 2. SCREEN SPACE / HUD (Fixed to Window)
		// ==========================================

		rl.DrawRectangle(0, 0, rl.GetScreenWidth(), 60, rl.WHITE)

		// Draw text over the screen (x, y, font_size, color)
		// rl.DrawText("SCORE: 0000", 10, 8, 10, rl.WHITE)
		// rl.DrawText("HP: [|||||     ]", 200, 8, 10, rl.RED)

	}

}
