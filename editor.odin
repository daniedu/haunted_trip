package main

import "core:fmt"
import rl "vendor:raylib"

EditMode :: enum { Tiles, Collision }

EditorState :: struct {
	mode:             EditMode,
	selected_set:     int, // -1 = empty
	selected_variant: u8,
	hover_cell:       [2]int, // for collision 16x16
	hover_visual:     [2]int, // for tiles 17x17
	is_hover_valid:   bool,
	show_grid:        bool,
	status_msg:       string,
	status_timer:     f32,
}

editor_init :: proc() -> EditorState {
	sel := 0 if len(TILESET_DECLS) > 0 else -1
	return EditorState{
		mode             = .Tiles,
		selected_set     = sel,
		selected_variant = 15,
		hover_cell       = {-1, -1},
		hover_visual     = {-1, -1},
		show_grid        = true,
		status_msg       = "Tiles: LMB paint | RMB erase | Alt+LMB copy | Q:Collision | S save",
		status_timer     = 5,
	}
}

editor_set_status :: proc(s: ^EditorState, msg: string) {
	s.status_msg = msg
	s.status_timer = 3.0
}

editor_update :: proc(s: ^EditorState, tiles: ^VisualMap, coll: ^CollisionMap, camera: rl.Camera2D, dt: f32) {
	if s.status_timer > 0 do s.status_timer -= dt

	mouse_screen := rl.GetMousePosition()
	mouse_world := rl.GetScreenToWorld2D(mouse_screen, camera)
	cell := world_to_cell(mouse_world)
	visual := world_to_visual(mouse_world)
	inside := cell[0] >= 0 && cell[0] < MAP_WIDTH && cell[1] >= 0 && cell[1] < MAP_HEIGHT
	inside_visual := visual[0] >= 0 && visual[0] < VISUAL_W && visual[1] >= 0 && visual[1] < VISUAL_H
	s.hover_cell = cell
	s.hover_visual = visual
	s.is_hover_valid = s.mode == .Tiles ? inside_visual : inside

	// Toggle mode Q
	if rl.IsKeyPressed(.Q) {
		s.mode = s.mode == .Tiles ? .Collision : .Tiles
		if s.mode == .Tiles {
			s.status_msg = "Tiles: LMB paint | RMB erase | Alt+LMB copy | Q:Collision"
		} else {
			s.status_msg = "Collision: LMB solid | RMB clear | Q:Tiles"
		}
		s.status_timer = 3
	}

	// Alt+LMB pick (tiles only)
	alt_down := rl.IsKeyDown(.LEFT_ALT) || rl.IsKeyDown(.RIGHT_ALT)
	if s.mode == .Tiles && inside_visual && alt_down && rl.IsMouseButtonPressed(.LEFT) {
		picked := tiles[visual[1]][visual[0]]
		if cell_is_empty(picked) {
			s.selected_set = -1
			editor_set_status(s, "Picked empty")
		} else {
			s.selected_set = picked.set_id
			s.selected_variant = picked.variant
			editor_set_status(s, fmt.tprintf("Picked %s:%d", TILESET_DECLS[picked.set_id].name, picked.variant))
		}
		return
	}

	// Menu click top bar
	MENU_H :: 88
	palette_handled := false
	if mouse_screen.y < MENU_H {
		x := 10
		cell_px :: 18
		gap :: 2
		for decl, id in TILESET_DECLS {
			block_w := 4*cell_px + 3*gap
			if mouse_screen.x >= f32(x) && mouse_screen.x < f32(x+block_w) && mouse_screen.y >= 18 && mouse_screen.y < 18+4*cell_px+3*gap {
				if rl.IsMouseButtonPressed(.LEFT) {
					rel_x := int(mouse_screen.x) - x
					rel_y := int(mouse_screen.y) - 18
					col := rel_x / (cell_px+gap)
					row := rel_y / (cell_px+gap)
					if col >=0 && col <4 && row>=0 && row<4 {
						if rel_x % (cell_px+gap) < cell_px && rel_y % (cell_px+gap) < cell_px {
							phys := row*4 + col
							logical := phys
							for l in 0..<16 {
								if int(TILE_REMAP[l]) == phys { logical = l; break }
							}
							s.selected_set = id
							s.selected_variant = u8(logical)
							s.mode = .Tiles
							editor_set_status(s, fmt.tprintf("Tiles %s:%d", decl.name, logical))
							palette_handled = true
						}
					}
				} else {
					palette_handled = true
				}
			}
			x += block_w + 20
		}
		empty_w :: 40
		if mouse_screen.x >= f32(x) && mouse_screen.x < f32(x+empty_w) && mouse_screen.y >= 18 && mouse_screen.y < 18+40 {
			if rl.IsMouseButtonPressed(.LEFT) {
				s.selected_set = -1
				editor_set_status(s, "Selected empty")
				palette_handled = true
			} else {
				palette_handled = true
			}
		}
		if palette_handled do return
	}

	// Paint
	if s.mode == .Tiles {
		if inside_visual && !palette_handled {
			if rl.IsMouseButtonDown(.LEFT) && !alt_down {
				tiles[visual[1]][visual[0]] = make_cell(s.selected_set, s.selected_variant)
			} else if rl.IsMouseButtonDown(.RIGHT) {
				tiles[visual[1]][visual[0]] = EmptyCell
			}
		}
	} else { // Collision
		if inside && !palette_handled {
			if rl.IsMouseButtonDown(.LEFT) {
				coll[cell[1]][cell[0]] = true
			} else if rl.IsMouseButtonDown(.RIGHT) {
				coll[cell[1]][cell[0]] = false
			}
		}
	}

	if rl.IsKeyPressed(.G) {
		s.show_grid = !s.show_grid
		editor_set_status(s, fmt.tprintf("Grid %v", s.show_grid))
	}
	if rl.IsKeyPressed(.S) {
		ok1 := save_level(LEVEL_PATH, tiles^, coll^)
		if ok1 do editor_set_status(s, "Saved")
		else do editor_set_status(s, "Save FAILED")
	}
	if rl.IsKeyPressed(.L) {
		ok := load_level(LEVEL_PATH, tiles, coll)
		if ok do editor_set_status(s, "Loaded")
		else do editor_set_status(s, "Load FAILED")
	}
	if rl.IsKeyPressed(.C) {
		if s.mode == .Tiles {
			for y in 0..<VISUAL_H do for x in 0..<VISUAL_W do tiles[y][x] = EmptyCell
			editor_set_status(s, "Cleared tiles")
		} else {
			for y in 0..<MAP_HEIGHT do for x in 0..<MAP_WIDTH do coll[y][x] = false
			editor_set_status(s, "Cleared collision")
		}
	}
	if rl.IsKeyPressed(.R) {
		tiles^ = make_default_visual()
		coll^ = make_default_collision()
		editor_set_status(s, "Reset")
	}
}

editor_draw_world_hover :: proc(s: EditorState) {
	if !s.is_hover_valid do return
	if s.mode == .Tiles {
		px := f32(s.hover_visual[0] * TILE_SIZE + DUAL_OFFSET)
		py := f32(s.hover_visual[1] * TILE_SIZE + DUAL_OFFSET)
		rl.DrawRectangleV({px, py}, {TILE_SIZE, TILE_SIZE}, {255, 255, 255, 30})
		rl.DrawRectangleLinesEx({px, py, TILE_SIZE, TILE_SIZE}, 2, rl.WHITE)
		rl.DrawText(fmt.ctprintf("%d,%d v%d", s.hover_visual[0], s.hover_visual[1], s.selected_variant), i32(px+2), i32(py+2), 10, rl.WHITE)
	} else {
		px := f32(s.hover_cell[0] * TILE_SIZE)
		py := f32(s.hover_cell[1] * TILE_SIZE)
		rl.DrawRectangleV({px, py}, {TILE_SIZE, TILE_SIZE}, {255, 80, 80, 40})
		rl.DrawRectangleLinesEx({px, py, TILE_SIZE, TILE_SIZE}, 2, rl.RED)
	}
}

editor_draw_debug_overlay :: proc(s: EditorState, tiles: VisualMap, coll: CollisionMap) {
	if s.mode == .Collision {
		// Draw collision overlay: red where solid
		for y in 0..<MAP_HEIGHT {
			for x in 0..<MAP_WIDTH {
				if !coll[y][x] do continue
				pos := rl.Vector2{f32(x*TILE_SIZE), f32(y*TILE_SIZE)}
				rl.DrawRectangleV(pos, {TILE_SIZE, TILE_SIZE}, {255,0,0,70})
				rl.DrawRectangleLinesEx({pos.x, pos.y, TILE_SIZE, TILE_SIZE}, 1, rl.RED)
			}
		}
	}
}

draw_checker_background :: proc(x, y, w, h: i32) {
	a := rl.Color{45, 45, 50, 255}
	b := rl.Color{60, 60, 65, 255}
	sz :: 8
	for py := i32(0); py < h; py += sz {
		for px := i32(0); px < w; px += sz {
			col := a if ((px/sz + py/sz) % 2 == 0) else b
			rl.DrawRectangle(x+px, y+py, min(sz, w-px), min(sz, h-py), col)
		}
	}
}

editor_draw_palette :: proc(s: EditorState, tiles: VisualMap, coll: CollisionMap) {
	MENU_H :: 88
	rl.DrawRectangle(0, 0, rl.GetScreenWidth(), MENU_H, {0, 0, 0, 190})
	rl.DrawRectangleLines(0, 0, rl.GetScreenWidth(), MENU_H, {255, 255, 255, 25})

	if s.mode == .Tiles {
		rl.DrawText("TILES — click tile to select | Alt+Click world copy | RMB erase | Q:Collision", 10, 4, 11, rl.LIGHTGRAY)
	} else {
		rl.DrawText("COLLISION — LMB solid | RMB clear | Q:Tiles", 10, 4, 11, {255,120,120,255})
	}

	x := 10
	cell_px :: 18
	gap :: 2
	for decl, id in TILESET_DECLS {
		is_selected_set := s.mode == .Tiles && s.selected_set == id
		block_w := 4*cell_px + 3*gap
		label_col := is_selected_set ? rl.YELLOW : rl.WHITE
		rl.DrawText(fmt.ctprintf("%s", decl.name), i32(x), 14, 9, label_col)

		rt := tileset_get_runtime_by_id(id)
		for phys in 0..<16 {
			col := phys % 4
			row := phys / 4
			dst := rl.Rectangle{f32(x + col*(cell_px+gap)), 18, cell_px, cell_px}
			dst.y = 18 + f32(row*(cell_px+gap))
			draw_checker_background(i32(dst.x), i32(dst.y), cell_px, cell_px)
			if rt.ready {
				src := rl.Rectangle{f32(col*TILE_SIZE), f32(row*TILE_SIZE), TILE_SIZE, TILE_SIZE}
				rl.DrawTexturePro(rt.texture, src, dst, {0,0}, 0, rl.WHITE)
			} else {
				rl.DrawRectangleRec(dst, {80,80,80,255})
			}
			logical := phys
			for l in 0..<16 {
				if int(TILE_REMAP[l]) == phys { logical = l; break }
			}
			is_sel := is_selected_set && int(s.selected_variant) == logical
			if is_sel {
				rl.DrawRectangleLinesEx(dst, 2, rl.YELLOW)
			} else {
				rl.DrawRectangleLinesEx(dst, 1, {255,255,255,30})
			}
			if is_dual_solid(id, u8(logical)) {
				rl.DrawRectangleRec({dst.x, dst.y, cell_px, cell_px}, {255,0,0,35})
			} else if is_dual_slower(id, u8(logical)) {
				rl.DrawRectangleRec({dst.x, dst.y, cell_px, cell_px}, {80,120,255,35})
			}
		}
		if is_selected_set {
			rl.DrawRectangleLinesEx({f32(x-2), 12, f32(block_w+4), f32(4*cell_px+3*gap+4)}, 2, rl.YELLOW)
		}
		x += block_w + 20
	}

	empty_w :: 40
	empty_h :: 40
	is_empty_sel := s.selected_set < 0 && s.mode == .Tiles
	if is_empty_sel {
		rl.DrawRectangle(i32(x-2), 10, empty_w+4, empty_h+4, rl.YELLOW)
	}
	rl.DrawRectangle(i32(x), 12, empty_w, empty_h, {80,80,80,255})
	rl.DrawRectangleLines(i32(x), 12, empty_w, empty_h, rl.BLACK)
	rl.DrawText("Empty", i32(x), 12+empty_h+4, 9, is_empty_sel ? rl.YELLOW : rl.WHITE)
	x += empty_w + 20

	instr_x := rl.GetScreenWidth() - 340
	if instr_x < i32(x+10) do instr_x = i32(x+10)
	if s.mode == .Tiles {
		rl.DrawText("LMB paint  RMB erase  Alt+LMB copy", instr_x, 18, 11, rl.LIGHTGRAY)
	} else {
		rl.DrawText("LMB solid  RMB clear", instr_x, 18, 11, {255,180,180,255})
	}
	rl.DrawText("G grid  S save  L load  C clear  Q toggle Tiles/Collision  TAB play", instr_x, 32, 11, rl.LIGHTGRAY)
	if s.mode == .Tiles && s.selected_set >= 0 {
		rl.DrawText(fmt.ctprintf("Sel %s:%d", TILESET_DECLS[s.selected_set].name, s.selected_variant), instr_x, 48, 11, rl.YELLOW)
	} else if s.mode == .Collision {
		rl.DrawText("Mode: Collision", instr_x, 48, 11, rl.RED)
	} else {
		rl.DrawText("Sel empty", instr_x, 48, 11, rl.YELLOW)
	}
	if s.status_timer > 0 {
		rl.DrawText(fmt.ctprintf("%s", s.status_msg), 10, MENU_H-16, 10, rl.YELLOW)
	}

	bottom_y := rl.GetScreenHeight() - 24
	rl.DrawRectangle(0, bottom_y, rl.GetScreenWidth(), 24, {0,0,0,180})
	hover_txt: cstring
	if s.is_hover_valid {
		if s.mode == .Tiles {
			v := s.selected_variant
			hover_txt = fmt.ctprintf("Tiles %d,%d | Sel %s:%d | %s", s.hover_visual[0], s.hover_visual[1], s.selected_set>=0?TILESET_DECLS[s.selected_set].name:"empty", v, s.status_msg)
		} else {
			hover_txt = fmt.ctprintf("Collision %d,%d solid:%v | Sel %s", s.hover_cell[0], s.hover_cell[1], s.is_hover_valid ? coll[s.hover_cell[1]][s.hover_cell[0]] : false, s.status_msg)
		}
	} else {
		hover_txt = fmt.ctprintf("Mode %v | Sel %s:%d | TAB Play/Edit Q toggle", s.mode, s.selected_set>=0?TILESET_DECLS[s.selected_set].name:"empty", s.selected_variant)
	}
	rl.DrawText(hover_txt, 8, bottom_y+6, 12, rl.WHITE)
}
