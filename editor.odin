package main

import "core:fmt"
import rl "vendor:raylib"

EditorState :: struct {
	selected_set:   int, // -1 = outer, 0 = oild
	hover_cell:     [2]int,
	is_hover_valid: bool,
	show_logical:   bool,
	show_dual:      bool,
	show_chunk:     bool,
	show_tileset:   bool,
	show_debug:     bool,
	status_msg:     string,
	status_timer:   f32,
}

editor_init :: proc() -> EditorState {
	oild_id := find_tileset_by_name("oild")
	if oild_id < 0 do oild_id = 0
	return EditorState{
		selected_set = oild_id,
		hover_cell   = {-1, -1},
		show_logical = true,
		show_dual    = true,
		show_chunk   = false,
		show_tileset = true,
		show_debug   = false,
		status_msg   = "LMB Inner | RMB Outer | D debug | G/T | S Save | TAB Play",
		status_timer = 5,
	}
}

editor_set_status :: proc(s: ^EditorState, msg: string) {
	s.status_msg = msg
	s.status_timer = 3.0
}

editor_update :: proc(s: ^EditorState, m: ^Map, camera: rl.Camera2D, dt: f32) {
	if s.status_timer > 0 do s.status_timer -= dt

	mouse_screen := rl.GetMousePosition()
	mouse_world := rl.GetScreenToWorld2D(mouse_screen, camera)
	cell := world_to_cell(mouse_world)
	inside := cell[0] >= 0 && cell[0] < MAP_WIDTH && cell[1] >= 0 && cell[1] < MAP_HEIGHT
	s.hover_cell = cell
	s.is_hover_valid = inside

	// LMB = paint inner (dirt), RMB = paint outer (grass) - both are same tileset, just member true/false
	if inside {
		if rl.IsMouseButtonDown(.LEFT) {
			if s.selected_set >= 0 {
				m[cell[1]][cell[0]] = TileCell{set_id = s.selected_set}
			} else {
				m[cell[1]][cell[0]] = EmptyCell
			}
		} else if rl.IsMouseButtonDown(.RIGHT) {
			// outer brush: set to empty (outer side of same oild atlas) - not void
			m[cell[1]][cell[0]] = EmptyCell
		}
		if rl.IsMouseButtonPressed(.MIDDLE) {
			picked := m[cell[1]][cell[0]]
			if cell_is_empty(picked) {
				s.selected_set = -1
			} else {
				s.selected_set = picked.set_id
				editor_set_status(s, fmt.tprintf("Picked %s", TILESET_DECLS[picked.set_id].name))
			}
		}
	}

	// 1 = oild, 2/3 disabled, 0/4 = empty
	if rl.IsKeyPressed(.ONE) {
		id := find_tileset_by_name("oild")
		if id >= 0 { s.selected_set = id; editor_set_status(s, "Selected: oild") }
	}
	if rl.IsKeyPressed(.TWO) || rl.IsKeyPressed(.THREE) {
		editor_set_status(s, "Only oild enabled - add more in tileset.odin later")
	}
	if rl.IsKeyPressed(.FOUR) || rl.IsKeyPressed(.ZERO) {
		s.selected_set = -1
		editor_set_status(s, "Selected: Empty (erase)")
	}

	if rl.IsKeyPressed(.G) {
		s.show_logical = !s.show_logical
		s.show_dual = !s.show_dual
		editor_set_status(s, fmt.tprintf("Grids logical %v dual %v", s.show_logical, s.show_dual))
	}
	if rl.IsKeyPressed(.H) do s.show_chunk = !s.show_chunk
	if rl.IsKeyPressed(.T) {
		s.show_tileset = !s.show_tileset
		editor_set_status(s, fmt.tprintf("Tileset preview %v", s.show_tileset))
	}
	if rl.IsKeyPressed(.D) {
		s.show_debug = !s.show_debug
		editor_set_status(s, fmt.tprintf("Debug values %v", s.show_debug))
	}

	if rl.IsKeyPressed(.S) {
		ok := save_level(LEVEL_PATH, m^)
		if ok do editor_set_status(s, "Saved to level_01.json")
		else do editor_set_status(s, "Save FAILED")
	}
	if rl.IsKeyPressed(.L) {
		ok := load_level(LEVEL_PATH, m)
		if ok do editor_set_status(s, "Loaded level_01.json")
		else do editor_set_status(s, "Load FAILED")
	}
	if rl.IsKeyPressed(.C) {
		for y in 0..<MAP_HEIGHT {
			for x in 0..<MAP_WIDTH {
				if s.selected_set >= 0 {
					m[y][x] = TileCell{set_id = s.selected_set}
				} else {
					m[y][x] = EmptyCell
				}
			}
		}
		editor_set_status(s, "Cleared")
	}
	if rl.IsKeyPressed(.R) {
		m^ = make_default_map()
		editor_set_status(s, "Reset default map")
	}
}

editor_draw_world_hover :: proc(s: EditorState) {
	if !s.is_hover_valid do return
	px := f32(s.hover_cell[0] * TILE_SIZE)
	py := f32(s.hover_cell[1] * TILE_SIZE)
	rl.DrawRectangleV({px, py}, {TILE_SIZE, TILE_SIZE}, {255, 255, 255, 30})
	rl.DrawRectangleLinesEx({px, py, TILE_SIZE, TILE_SIZE}, 2, rl.WHITE)
	rl.DrawText(fmt.ctprintf("%d,%d", s.hover_cell[0], s.hover_cell[1]), i32(px+2), i32(py+2), 12, rl.WHITE)
}

editor_draw_debug_overlay :: proc(s: EditorState, m: Map) {
	if !s.show_debug do return
	if s.selected_set < 0 do return
	for y in -1..<MAP_HEIGHT {
		for x in -1..<MAP_WIDTH {
			idx := get_dual_index_for_set(m, x, y, s.selected_set)
			pos := rl.Vector2{f32(x * TILE_SIZE + DUAL_OFFSET), f32(y * TILE_SIZE + DUAL_OFFSET)}
			label := fmt.ctprintf("%d", idx)
			rl.DrawText(label, i32(pos.x+6), i32(pos.y+6), 12, {255,255,0,230})
			// idx 0 is now valid outer flat, mark with green circle
			if idx == 0 do rl.DrawCircleV(pos + {12,12}, 3, {100,255,100,120})
			if idx == 15 do rl.DrawCircleV(pos + {12,4}, 3, {255,100,100,120})
		}
	}
	rl.DrawText(fmt.ctprintf("DEBUG %s  0=outer 15=inner  D toggle", TILESET_DECLS[s.selected_set].name), -30, -36, 16, rl.YELLOW)
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

editor_draw_palette :: proc(s: EditorState, m: Map) {
	bar_h :: 72
	rl.DrawRectangle(0, 0, rl.GetScreenWidth(), bar_h, {0, 0, 0, 180})
	rl.DrawRectangleLines(0, 0, rl.GetScreenWidth(), bar_h, {255, 255, 255, 30})

	swatch_size :: 40
	y :: 14
	start_x :: 10

	// oild swatch - show 15 inner and 0 outer side by side
	oild_id := find_tileset_by_name("oild")
	if oild_id >= 0 {
		decl := TILESET_DECLS[oild_id]
		x := start_x
		is_selected := s.selected_set == oild_id
		col := decl.color
		if is_selected {
			rl.DrawRectangle(i32(x-2), i32(y-2), swatch_size*2+4+8, swatch_size+4, rl.YELLOW)
		} else {
			rl.DrawRectangle(i32(x-1), i32(y-1), swatch_size*2+2+8, swatch_size+2, {255,255,255,60})
		}
		rt := tileset_get_runtime_by_id(oild_id)
		if rt.ready {
			draw_checker_background(i32(x), i32(y), swatch_size, swatch_size)
			src_inner := tileset_get_rect_by_id(oild_id, 15)
			rl.DrawTexturePro(rt.texture, src_inner, {f32(x), f32(y), f32(swatch_size), f32(swatch_size)}, {0,0}, 0, rl.WHITE)
			rl.DrawRectangleLines(i32(x), i32(y), swatch_size, swatch_size, rl.RED)
			rl.DrawText("15", i32(x+2), i32(y+2), 10, rl.WHITE)

			draw_checker_background(i32(x+swatch_size+8), i32(y), swatch_size, swatch_size)
			src_outer := tileset_get_rect_by_id(oild_id, 0)
			rl.DrawTexturePro(rt.texture, src_outer, {f32(x+swatch_size+8), f32(y), f32(swatch_size), f32(swatch_size)}, {0,0}, 0, rl.WHITE)
			rl.DrawRectangleLines(i32(x+swatch_size+8), i32(y), swatch_size, swatch_size, rl.GREEN)
			rl.DrawText("0", i32(x+swatch_size+10), i32(y+2), 10, rl.WHITE)
		} else {
			rl.DrawRectangle(i32(x), i32(y), swatch_size, swatch_size, col)
			rl.DrawRectangle(i32(x+swatch_size+8), i32(y), swatch_size, swatch_size, {80,80,80,255})
		}
		offset_x :: swatch_size*2+8
		if is_selected {
			rl.DrawText(fmt.ctprintf("%s", decl.name), i32(x+offset_x+4), i32(y)+2, 13, rl.WHITE)
			rl.DrawText("LMB inner RMB outer", i32(x+offset_x+4), i32(y)+18, 10, rl.GRAY)
			rl.DrawText("SELECTED", i32(x), i32(y)+swatch_size+4, 10, rl.YELLOW)
		} else {
			rl.DrawText(fmt.ctprintf("%s", decl.name), i32(x+offset_x+4), i32(y)+2, 13, rl.WHITE)
		}
		rl.DrawText("[1]", i32(x+offset_x+4), i32(y)+32, 11, rl.GRAY)
	}

	// empty swatch hidden - outer is just empty logical but same atlas, not void
	// Keep small indicator for erase mode
	empty_x := start_x + 180
	rl.DrawRectangle(i32(empty_x), i32(y), swatch_size, swatch_size, {80,80,80,255})
	rl.DrawRectangleLines(i32(empty_x), i32(y), swatch_size, swatch_size, rl.BLACK)
	rl.DrawText("Outer", i32(empty_x+swatch_size+4), i32(y+2), 13, rl.WHITE)
	rl.DrawText("[0/4] RMB", i32(empty_x+swatch_size+4), i32(y)+18, 11, rl.GRAY)
	if s.selected_set < 0 {
		rl.DrawRectangle(i32(empty_x-2), i32(y-2), swatch_size+4, swatch_size+4, rl.YELLOW)
		rl.DrawText("SELECTED", i32(empty_x), i32(y)+swatch_size+4, 10, rl.YELLOW)
	}

	instr_x := rl.GetScreenWidth() - 600
	if instr_x < 400 do instr_x = 400
	rl.DrawText("LMB:Inner  RMB:Outer  MMB:Pick  G:Grid T:Tileset D:Debug", instr_x, 10, 13, rl.LIGHTGRAY)
	rl.DrawText("S:Save L:Load C:Clear R:Reset TAB:Play  1:oild 0:Outer", instr_x, 28, 13, rl.LIGHTGRAY)

	if s.status_timer > 0 {
		rl.DrawText(fmt.ctprintf("%s", s.status_msg), 10, 52, 13, rl.YELLOW)
	}

	// Tileset preview
	if s.show_tileset && s.selected_set >= 0 && tileset_is_ready_by_id(s.selected_set) {
		rt := tileset_get_runtime_by_id(s.selected_set)
		panel_x := rl.GetScreenWidth() - 440
		panel_y: i32 = bar_h + 10
		panel_w: i32 = 420
		panel_h: i32 = 200
		rl.DrawRectangle(panel_x, panel_y, panel_w, panel_h + 30, {0,0,0,200})
		rl.DrawRectangleLines(panel_x, panel_y, panel_w, panel_h + 30, {255,255,255,40})
		rl.DrawText(fmt.ctprintf("%s (%s)", rt.decl.name, rt.decl.file), panel_x+6, panel_y+4, 14, rl.WHITE)
		props := fmt.ctprintf("color solid:%v slower:%v %s", rt.decl.is_solid, rt.decl.is_slower, rt.decl.has_remap ? "[remapped]" : "")
		rl.DrawText(props, panel_x+6, panel_y+20, 11, rl.LIGHTGRAY)
		grid_x: i32 = panel_x + 10
		grid_y: i32 = panel_y + 34
		grid_sz: i32 = 160
		draw_checker_background(grid_x, grid_y, grid_sz, grid_sz)
		rl.DrawText("PHYSICAL (PNG)", grid_x, grid_y-12, 11, rl.GRAY)
		logic_x: i32 = panel_x + 240
		logic_y: i32 = panel_y + 34
		draw_checker_background(logic_x, logic_y, grid_sz, grid_sz)
		rl.DrawText("LOGICAL (render)", logic_x, logic_y-12, 11, rl.GRAY)
		if rt.ready {
			cell: i32 = 40
			for phys in 0..<16 {
				src_raw := rl.Rectangle{ f32((phys%4)*24), f32((phys/4)*24), 24, 24 }
				col := phys % 4
				row := phys / 4
				dst := rl.Rectangle{ f32(grid_x + i32(col)*cell), f32(grid_y + i32(row)*cell), f32(cell), f32(cell) }
				rl.DrawTexturePro(rt.texture, src_raw, dst, {0,0}, 0, rl.WHITE)
				rl.DrawRectangleLinesEx(dst, 1, {255,255,255,20})
				logical := phys
				if rt.decl.has_remap {
					for l in 0..<16 {
						if int(rt.decl.remap[l]) == phys { logical = l; break }
					}
				}
				rl.DrawText(fmt.ctprintf("p%d", phys), i32(dst.x+2), i32(dst.y+2), 10, rl.GRAY)
				if logical != phys {
					rl.DrawText(fmt.ctprintf("->l%d", logical), i32(dst.x+2), i32(dst.y+12), 10, rl.YELLOW)
				}
			}
			for logical in 0..<16 {
				src := tileset_get_rect_by_id(s.selected_set, u8(logical))
				col := logical % 4
				row := logical / 4
				dst := rl.Rectangle{ f32(logic_x + i32(col)*cell), f32(logic_y + i32(row)*cell), f32(cell), f32(cell) }
				rl.DrawTexturePro(rt.texture, src, dst, {0,0}, 0, rl.WHITE)
				rl.DrawRectangleLinesEx(dst, 1, {255,255,255,20})
				phys := logical
				if rt.decl.has_remap { phys = int(rt.decl.remap[logical]) }
				rl.DrawText(fmt.ctprintf("l%d", logical), i32(dst.x+2), i32(dst.y+2), 10, phys==logical ? rl.GRAY : rl.YELLOW)
				if phys != logical {
					rl.DrawText(fmt.ctprintf("p%d", phys), i32(dst.x+2), i32(dst.y+12), 10, {150,150,255,255})
				}
			}
		}
		rl.DrawText("T hide | checker", panel_x+6, panel_y+panel_h+8, 10, {180,180,180,255})
	} else if s.show_tileset && s.selected_set >= 0 {
		panel_x := rl.GetScreenWidth() - 220
		panel_y: i32 = bar_h + 10
		rl.DrawRectangle(panel_x, panel_y, 200, 50, {0,0,0,200})
		rl.DrawRectangleLines(panel_x, panel_y, 200, 50, {255,255,255,40})
		rl.DrawText("No tileset texture", panel_x+8, panel_y+8, 10, {255,180,80,255})
		rl.DrawText("T to hide", panel_x+8, panel_y+22, 8, rl.GRAY)
	}

	bottom_y := rl.GetScreenHeight() - 28
	rl.DrawRectangle(0, bottom_y, rl.GetScreenWidth(), 28, {0,0,0,180})
	hover_txt: cstring
	if s.is_hover_valid {
		cell := get_cell_safe(m, s.hover_cell[0], s.hover_cell[1])
		hover_desc: string = "empty"
		dual_idx: u8 = 0
		if !cell_is_empty(cell) {
			decl := TILESET_DECLS[cell.set_id]
			hover_desc = fmt.tprintf("%s", decl.name)
			if s.selected_set >= 0 {
				dual_idx = get_dual_index_for_set(m, s.hover_cell[0], s.hover_cell[1], s.selected_set)
			} else {
				dual_idx = get_dual_index_for_set(m, s.hover_cell[0], s.hover_cell[1], cell.set_id)
			}
		} else if s.selected_set >= 0 {
			dual_idx = get_dual_index_for_set(m, s.hover_cell[0], s.hover_cell[1], s.selected_set)
		}
		sel_desc: string = "empty"
		if s.selected_set >= 0 do sel_desc = TILESET_DECLS[s.selected_set].name
		hover_txt = fmt.ctprintf("Hover %d,%d | %s | Selected: %s | Dual:%d | %s", s.hover_cell[0], s.hover_cell[1], hover_desc, sel_desc, dual_idx, s.status_msg)
	} else {
		sel_desc2: string = "empty"
		if s.selected_set >= 0 do sel_desc2 = TILESET_DECLS[s.selected_set].name
		hover_txt = fmt.ctprintf("Selected %s | %s | Mode: EDIT (TAB to Play)", sel_desc2, s.status_msg)
	}
	rl.DrawText(hover_txt, 8, bottom_y+8, 14, rl.WHITE)
}
