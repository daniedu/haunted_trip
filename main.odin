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

	// 16x16 logical map - separated from draw logic (level.odin handles persistence)
	map_grid := make_default_map()

	// Try to auto-load saved level
	loaded := load_level(LEVEL_PATH, &map_grid)
	if loaded {
		fmt.println("Auto-loaded", LEVEL_PATH)
	}

	use_assets := false
	tileset := rl.Texture2D{}

	// Try dual-grid atlas 384x24 (16 tiles *24)
	if rl.FileExists("assets/tiles/dual_row_24.png") {
		tileset = rl.LoadTexture("assets/tiles/dual_row_24.png")
		if rl.IsTextureReady(tileset) {
			use_assets = true
			fmt.println("Loaded tileset assets/tiles/dual_row_24.png")
		}
	} else if rl.FileExists("assets/tiles/dual_row.png") {
		tileset = rl.LoadTexture("assets/tiles/dual_row.png")
		if rl.IsTextureReady(tileset) {
			use_assets = true
			fmt.println("Loaded tileset assets/tiles/dual_row.png")
		}
	} else if rl.FileExists("assets/tiles/oild_tiles.png") {
		tileset = rl.LoadTexture("assets/tiles/oild_tiles.png")
		if rl.IsTextureReady(tileset) {
			use_assets = true
			fmt.println("Loaded tileset assets/tiles/oild_tiles.png (check 24px layout)")
		}
	}

	defer if rl.IsTextureReady(tileset) do rl.UnloadTexture(tileset)

	editor := editor_init()

	// Free camera in Edit, follow player in Play
	free_cam_pos := player.position

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		// Global toggle
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

		// Allow F1 to recenter
		if rl.IsKeyPressed(.F1) {
			free_cam_pos = player.position
		}

		// Per-state update
		switch game_state {
		case .Play:
			process_player_inputs(&player, dt)
			update_player_collisions(&player, map_grid, dt)

		case .Edit:
			// Editor camera can pan with WASD/arrows or drag middle
			// Simple free cam: WASD pans when in Edit (reuse player input? custom)
			cam_speed :: 200
			if rl.IsKeyDown(.W) || rl.IsKeyDown(.UP)    { free_cam_pos.y -= cam_speed * dt }
			if rl.IsKeyDown(.S) || rl.IsKeyDown(.DOWN)  { free_cam_pos.y += cam_speed * dt }
			if rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT)  { free_cam_pos.x -= cam_speed * dt }
			if rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT) { free_cam_pos.x += cam_speed * dt }

			// Build a temp camera for editor hover calc
			// We need camera before editor_update, so construct here
			// Will reconstruct below for drawing but reuse pos
			// For now use same construction as drawing camera (duplicated logic)
			// To avoid drift, editor_update will receive the draw camera; we compute it twice.
			editor_camera_temp := rl.Camera2D {
				zoom   = f32(rl.GetScreenHeight()) / PIXEL_WINDOWS_HEIGHT,
				offset = {f32(rl.GetScreenWidth()) * 0.5, f32(rl.GetScreenHeight()) * 0.5},
				target = free_cam_pos,
			}
			editor_update(&editor, &map_grid, editor_camera_temp, dt)
		}

		// Camera selection
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

		// Drawing
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground({ 18, 18, 22, 255 })

		// ==========================================
		// 1. WORLD SPACE (Affected by Camera)
		// ==========================================

		rl.BeginMode2D(camera)

		// Background fill for map area (so empty outside is visible)
		rl.DrawRectangle(-20, -20, MAP_WIDTH*TILE_SIZE+40, MAP_HEIGHT*TILE_SIZE+40, {28,28,34,255})

		// Floor layer always (so 0000 dual tiles have floor beneath)
		draw_logical_floor(map_grid, tileset, use_assets)

		// Dual-grid layer (wall autotile)
		if editor.show_dual_preview || game_state == .Play {
			draw_dual_map(map_grid, tileset, use_assets)
		} else {
			// If preview disabled in edit, show raw logical tiles for clarity
			for y in 0..<MAP_HEIGHT {
				for x in 0..<MAP_WIDTH {
					// Only draw non-floor to avoid double-draw (floor already)
					t := map_grid[y][x]
					if t == .Wall || t == .Water {
						draw_tile(t, x, y, use_assets, tileset)
					}
				}
			}
		}

		// Grids
		draw_grids(editor.show_logical, editor.show_dual, editor.show_chunk)

		// Editor hover feedback
		if game_state == .Edit {
			editor_draw_world_hover(editor)
		}

		// Player
		rl.DrawRectangleV(player.position, {PLAYER_SIZE, PLAYER_SIZE}, rl.GREEN)
		// Center dot for Chrono-style pivot
		rl.DrawCircleV(player.position + {PLAYER_SIZE/2, PLAYER_SIZE/2}, 2, rl.WHITE)

		if player.is_attacking {
			weapon_rect := get_weapon_rect(player)
			rl.DrawRectangleRec(weapon_rect, rl.RED)
		}

		// Origin marker
		rl.DrawCircleV({0,0}, 4, rl.YELLOW)
		rl.DrawText("origin", 6, -8, 10, rl.YELLOW)

		// Map border highlight
		rl.DrawRectangleLinesEx({0,0, f32(MAP_WIDTH*TILE_SIZE), f32(MAP_HEIGHT*TILE_SIZE)}, 2, {255,255,255,20})

		rl.EndMode2D()

		// ==========================================
		// 2. SCREEN SPACE / HUD (Fixed to Window)
		// ==========================================

		if game_state == .Edit {
			editor_draw_palette(editor, map_grid)
		} else {
			// Play HUD
			rl.DrawRectangle(0, 0, rl.GetScreenWidth(), 48, {0,0,0,150})
			rl.DrawText("PLAY MODE - TAB to Edit | WASD Move | SPACE Attack | F1 Recenter", 10, 8, 12, rl.WHITE)
			text_player_pos := fmt.ctprintf(
				"Player %.1f,%.1f  Speed %.1f  Tile %d,%d  Facing %v  Weapon %v Attacking %v",
				player.position.x, player.position.y, player.move_speed,
				int((player.position.x + PLAYER_SIZE/2)/TILE_SIZE), int((player.position.y + PLAYER_SIZE/2)/TILE_SIZE),
				player.facing, player.equipped_weapon, player.is_attacking,
			)
			rl.DrawText(text_player_pos, 10, 24, 10, rl.LIGHTGRAY)
			rl.DrawText(fmt.ctprintf("Map %dx%d Tile %d Dual %d", MAP_WIDTH, MAP_HEIGHT, TILE_SIZE, DUAL_OFFSET), 10, 36, 10, rl.GRAY)
		}

		// Always show mode indicator bottom right
		mode_col := game_state == .Play ? rl.GREEN : rl.YELLOW
		mode_txt := game_state == .Play ? "PLAY" : "EDIT"
		rl.DrawText(fmt.ctprintf("%s  [TAB]", mode_txt), rl.GetScreenWidth()-140, rl.GetScreenHeight()-28, 20, mode_col)

		if !use_assets {
			rl.DrawText("DEBUG COLORS (no texture) - create assets/tiles/dual_row_24.png 384x24 row 16 tiles", 10, rl.GetScreenHeight()-40, 10, {255,180,80,255})
		}

	}
}
