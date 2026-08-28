package main

import "core:fmt"
import rl "vendor:raylib"

EditorState :: struct {
	selected:      TileType,
	hover_cell:    [2]int, // x,y in map coords, -1 if out of bounds
	is_hover_valid: bool,
	show_logical:  bool,
	show_dual:     bool,
	show_chunk:    bool,
	show_dual_preview: bool,
	status_msg:    string,
	status_timer:  f32,
}

editor_init :: proc() -> EditorState {
	return EditorState{
		selected           = .Wall,
		hover_cell         = {-1, -1},
		show_logical       = true,
		show_dual          = true,
		show_chunk         = false,
		show_dual_preview  = true,
		status_msg         = "Edit: LMB Paint | RMB Erase | 1-4 Tiles | G/P Grids | S Save | L Load | C Clear | TAB Play",
		status_timer       = 5,
	}
}

editor_set_status :: proc(s: ^EditorState, msg: string) {
	s.status_msg = msg
	s.status_timer = 3.0
}

editor_update :: proc(s: ^EditorState, m: ^Map, camera: rl.Camera2D, dt: f32) {
	// status timer
	if s.status_timer > 0 {
		s.status_timer -= dt
	}

	// --- hover via screen -> world ---
	mouse_screen := rl.GetMousePosition()
	mouse_world := rl.GetScreenToWorld2D(mouse_screen, camera)
	cell := world_to_cell(mouse_world)
	inside := cell[0] >= 0 && cell[0] < MAP_WIDTH && cell[1] >= 0 && cell[1] < MAP_HEIGHT
	s.hover_cell = cell
	s.is_hover_valid = inside

	// --- painting ---
	// Hold to paint drag
	if inside {
		if rl.IsMouseButtonDown(.LEFT) {
			m[cell[1]][cell[0]] = s.selected
		} else if rl.IsMouseButtonDown(.RIGHT) {
			// Right-drag erases to Floor (or Empty if you prefer)
			m[cell[1]][cell[0]] = .Floor
		}
		// Eyedrop middle button picks tile
		if rl.IsMouseButtonPressed(.MIDDLE) {
			s.selected = m[cell[1]][cell[0]]
			editor_set_status(s, fmt.tprintf("Picked %v", s.selected))
		}
	}

	// --- keyboard ---
	if rl.IsKeyPressed(.ONE)   { s.selected = .Floor; editor_set_status(s, "Selected: Floor") }
	if rl.IsKeyPressed(.TWO)   { s.selected = .Wall;  editor_set_status(s, "Selected: Wall") }
	if rl.IsKeyPressed(.THREE) { s.selected = .Water; editor_set_status(s, "Selected: Water") }
	if rl.IsKeyPressed(.FOUR)  { s.selected = .Empty; editor_set_status(s, "Selected: Empty") }

	// Cycle with Q/E or wheel
	if rl.IsKeyPressed(.Q) || rl.GetMouseWheelMove() < 0 {
		// cycle backwards
		v := int(s.selected)
		v = (v - 1 + len(TileType)) % len(TileType)
		s.selected = TileType(v)
		editor_set_status(s, fmt.tprintf("Selected: %v", s.selected))
	}
	if rl.IsKeyPressed(.E) || rl.GetMouseWheelMove() > 0 {
		v := int(s.selected)
		v = (v + 1) % len(TileType)
		s.selected = TileType(v)
		editor_set_status(s, fmt.tprintf("Selected: %v", s.selected))
	}

	if rl.IsKeyPressed(.G) {
		s.show_logical = !s.show_logical
		s.show_dual = !s.show_dual
		editor_set_status(s, fmt.tprintf("Grids logical %v dual %v", s.show_logical, s.show_dual))
	}
	if rl.IsKeyPressed(.H) {
		s.show_chunk = !s.show_chunk
	}
	if rl.IsKeyPressed(.P) {
		s.show_dual_preview = !s.show_dual_preview
		editor_set_status(s, fmt.tprintf("Dual preview %v", s.show_dual_preview))
	}

	if rl.IsKeyPressed(.S) {
		ok := save_level(LEVEL_PATH, m^)
		if ok { editor_set_status(s, "Saved to level_01.json") }
		else  { editor_set_status(s, "Save FAILED") }
	}
	if rl.IsKeyPressed(.L) {
		ok := load_level(LEVEL_PATH, m)
		if ok { editor_set_status(s, "Loaded level_01.json") }
		else  { editor_set_status(s, "Load FAILED - no file?") }
	}
	if rl.IsKeyPressed(.C) {
		for y in 0..<MAP_HEIGHT { for x in 0..<MAP_WIDTH { m[y][x] = .Floor } }
		editor_set_status(s, "Cleared to Floor")
	}
	if rl.IsKeyPressed(.R) {
		m^ = make_default_map()
		editor_set_status(s, "Reset default map")
	}
}

// World-space hover outline (call inside BeginMode2D)
editor_draw_world_hover :: proc(s: EditorState) {
	if !s.is_hover_valid do return
	px := f32(s.hover_cell[0] * TILE_SIZE)
	py := f32(s.hover_cell[1] * TILE_SIZE)
	// Fill faint
	rl.DrawRectangleV({px, py}, {TILE_SIZE, TILE_SIZE}, {255, 255, 255, 30})
	// Outline thick white
	rl.DrawRectangleLinesEx({px, py, TILE_SIZE, TILE_SIZE}, 2, rl.WHITE)
	// Small cell coord label
	rl.DrawText(fmt.ctprintf("%d,%d", s.hover_cell[0], s.hover_cell[1]), i32(px+2), i32(py+2), 8, rl.WHITE)

	// Show dual index preview at hover's dual cell (top-left corner of display)
	// Not needed but helpful debug
}

// Screen-space palette + status (call outside BeginMode2D)
editor_draw_palette :: proc(s: EditorState, m: Map) {
	// Top bar background
	bar_h :: 56
	rl.DrawRectangle(0, 0, rl.GetScreenWidth(), bar_h, {0, 0, 0, 180})
	rl.DrawRectangleLines(0, 0, rl.GetScreenWidth(), bar_h, {255, 255, 255, 30})

	// Tile swatches
	swatch_size :: 32
	padding :: 8
	start_x :: 10
	y :: 10

	types := [4]TileType{.Floor, .Wall, .Water, .Empty}
	labels := [4]string{"1:Floor","2:Wall","3:Water","4:Empty"}
	keys   := [4]string{"1","2","3","4"}

	for i in 0..<len(types) {
		t := types[i]
		x := start_x + i*(swatch_size + padding + 40)
		def := TILE_DATABASE[t]
		col := def.color
		if t == .Empty { col = {80,80,80,255} }

		// Highlight selected
		if t == s.selected {
			rl.DrawRectangle(i32(x-2), i32(y-2), swatch_size+4, swatch_size+4, rl.YELLOW)
		} else {
			rl.DrawRectangle(i32(x-1), i32(y-1), swatch_size+2, swatch_size+2, {255,255,255,60})
		}
		rl.DrawRectangle(i32(x), i32(y), swatch_size, swatch_size, col)
		rl.DrawRectangleLines(i32(x), i32(y), swatch_size, swatch_size, rl.BLACK)
		// label
		rl.DrawText(fmt.ctprintf("%s", labels[i]), i32(x)+swatch_size+4, i32(y)+2, 10, rl.WHITE)
		rl.DrawText(fmt.ctprintf("[%s]", keys[i]), i32(x)+swatch_size+4, i32(y)+14, 8, rl.LIGHTGRAY)
		if t == s.selected {
			rl.DrawText("SELECTED", i32(x), i32(y)+swatch_size+2, 8, rl.YELLOW)
		}
	}

	// Instructions right side
	instr_x := rl.GetScreenWidth() - 420
	if instr_x < 400 do instr_x = 400
	rl.DrawText("LMB:Paint  RMB:Erase  MMB:Pick  Q/E:Cycle  G:Grid  H:Chunk  P:Preview", instr_x, 8, 10, rl.LIGHTGRAY)
	rl.DrawText("S:Save  L:Load  C:Clear  R:Reset  TAB:Play", instr_x, 20, 10, rl.LIGHTGRAY)

	// Status msg bottom of bar
	if s.status_timer > 0 {
		rl.DrawText(fmt.ctprintf("%s", s.status_msg), 10, 42, 10, rl.YELLOW)
	}

	// Bottom status bar
	bottom_y := rl.GetScreenHeight() - 22
	rl.DrawRectangle(0, bottom_y, rl.GetScreenWidth(), 22, {0,0,0,160})
	hover_txt: cstring
	if s.is_hover_valid {
		tile_at_hover := get_tile_safe(m, s.hover_cell[0], s.hover_cell[1])
		dual_idx := get_dual_index(m, s.hover_cell[0], s.hover_cell[1], is_wall)
		hover_txt = fmt.ctprintf("Hover %d,%d | Tile: %v | Selected: %v | DualIdx: %d | Mode: EDIT (TAB to Play) | %s", s.hover_cell[0], s.hover_cell[1], tile_at_hover, s.selected, dual_idx, s.status_msg)
	} else {
		hover_txt = fmt.ctprintf("Selected %v | %s | Mode: EDIT (TAB to Play)", s.selected, s.status_msg)
	}
	rl.DrawText(hover_txt, 8, bottom_y+6, 10, rl.WHITE)
}
