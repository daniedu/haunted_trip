package main

import "core:fmt"
import rl "vendor:raylib"

PIXEL_WINDOWS_HEIGHT :: 320

main :: proc() {

	rl.InitWindow(1920, 1080, "haunted trip - dual grid 24px")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)
	rl.SetWindowState({.WINDOW_RESIZABLE})

	game_state := GameState.Play

	player := Player {
		position        = {f32(MAP_WIDTH * TILE_SIZE / 2), f32(MAP_HEIGHT * TILE_SIZE / 2)},
		move_speed      = 90,
		equipped_weapon = .None,
	}

	map_grid := make_default_map()

	loaded := load_level(LEVEL_PATH, &map_grid)
	if loaded {
		fmt.println("Auto-loaded", LEVEL_PATH)
	}

	tilesets_load()
	defer tilesets_unload()

	oild_id := find_tileset_by_name("oild")
	use_assets := oild_id >= 0 && tileset_is_ready_by_id(oild_id)
	tileset_is_grid96 := use_assets && tileset_get_texture_by_id(oild_id).width == 96

	editor := editor_init()

	free_cam_pos := player.position

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		if rl.IsKeyPressed(.TAB) {
			if game_state == .Play {
				game_state = .Edit
				free_cam_pos = player.position
				fmt.println("Switched to Edit")
			} else {
				game_state = .Play
				fmt.println("Switched to Play")
			}
		}

		if rl.IsKeyPressed(.F1) {
			free_cam_pos = player.position
		}

		switch game_state {
		case .Play:
			process_player_inputs(&player, dt)
			update_player_collisions(&player, map_grid, dt)

		case .Edit:
			cam_speed :: 200
			if rl.IsKeyDown(.W) || rl.IsKeyDown(.UP)    { free_cam_pos.y -= cam_speed * dt }
			if rl.IsKeyDown(.S) || rl.IsKeyDown(.DOWN)  { free_cam_pos.y += cam_speed * dt }
			if rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT)  { free_cam_pos.x -= cam_speed * dt }
			if rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT) { free_cam_pos.x += cam_speed * dt }

			editor_camera_temp := rl.Camera2D {
				zoom   = f32(rl.GetScreenHeight()) / PIXEL_WINDOWS_HEIGHT,
				offset = {f32(rl.GetScreenWidth()) * 0.5, f32(rl.GetScreenHeight()) * 0.5},
				target = free_cam_pos,
			}
			editor_update(&editor, &map_grid, editor_camera_temp, dt)
		}

		camera_target: rl.Vector2
		switch game_state {
		case .Play: camera_target = player.position + {PLAYER_SIZE/2, PLAYER_SIZE/2}
		case .Edit: camera_target = free_cam_pos
		}
		camera := rl.Camera2D {
			zoom   = f32(rl.GetScreenHeight()) / PIXEL_WINDOWS_HEIGHT,
			offset = {f32(rl.GetScreenWidth()) * 0.5, f32(rl.GetScreenHeight()) * 0.5},
			target = camera_target,
		}

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground({ 18, 18, 22, 255 })

		rl.BeginMode2D(camera)

		// Outer flat (idx 0) now fills background - no void floor needed
		// Draw oild autotile for entire map: inner = dirt where cell==oild, outer = grass where empty
		if oild_id >= 0 {
			draw_tileset(map_grid, oild_id)
		}
		if editor.show_debug {
			editor_draw_debug_overlay(editor, map_grid)
		}

		draw_grids(editor.show_logical, editor.show_dual, editor.show_chunk)

		if game_state == .Edit {
			editor_draw_world_hover(editor)
		}

		rl.DrawRectangleV(player.position, {PLAYER_SIZE, PLAYER_SIZE}, rl.GREEN)
		rl.DrawCircleV(player.position + {PLAYER_SIZE/2, PLAYER_SIZE/2}, 2, rl.WHITE)

		if player.is_attacking {
			weapon_rect := get_weapon_rect(player)
			rl.DrawRectangleRec(weapon_rect, rl.RED)
		}

		rl.DrawCircleV({0,0}, 4, rl.YELLOW)
		rl.DrawText("origin", 6, -8, 10, rl.YELLOW)

		rl.DrawRectangleLinesEx({0,0, f32(MAP_WIDTH*TILE_SIZE), f32(MAP_HEIGHT*TILE_SIZE)}, 2, {255,255,255,20})

		rl.EndMode2D()

		if game_state == .Edit {
			editor_draw_palette(editor, map_grid)
		} else {
			rl.DrawRectangle(0, 0, rl.GetScreenWidth(), 60, {0,0,0,150})
			rl.DrawText("PLAY MODE - TAB to Edit | WASD Move | SPACE Attack | F1 Recenter", 10, 10, 16, rl.WHITE)
			text_player_pos := fmt.ctprintf(
				"Player %.1f,%.1f  Speed %.1f  Tile %d,%d  Facing %v  Weapon %v Attacking %v",
				player.position.x, player.position.y, player.move_speed,
				int((player.position.x + PLAYER_SIZE/2)/TILE_SIZE), int((player.position.y + PLAYER_SIZE/2)/TILE_SIZE),
				player.facing, player.equipped_weapon, player.is_attacking,
			)
			rl.DrawText(text_player_pos, 10, 30, 14, rl.LIGHTGRAY)
			rl.DrawText(fmt.ctprintf("Map %dx%d Tile %d Dual %d", MAP_WIDTH, MAP_HEIGHT, TILE_SIZE, DUAL_OFFSET), 10, 48, 12, rl.GRAY)
		}

		mode_col := game_state == .Play ? rl.GREEN : rl.YELLOW
		mode_txt := game_state == .Play ? "PLAY" : "EDIT"
		rl.DrawText(fmt.ctprintf("%s  [TAB]", mode_txt), rl.GetScreenWidth()-160, rl.GetScreenHeight()-36, 24, mode_col)

		if !use_assets {
			rl.DrawText("DEBUG COLORS (no texture)", 10, rl.GetScreenHeight()-50, 14, {255,180,80,255})
		} else if tileset_is_grid96 {
			rl.DrawText("oild 96x96 4x4@24  D:debug", 10, rl.GetScreenHeight()-50, 14, {120,200,255,255})
		}
	}
}
