package main

import rl "vendor:raylib"

// Decor / Building system scaffolding.
// Walls as tiles handle autotile terrain; buildings as multi-tile decor allow
// doors, warps, and larger footprints without polluting the autotile logic.
// For now stubs: collision hook, drawing placeholder, serialization reserved for future.

// Per-decor definition (future tileset for buildings)
DecorDef :: struct {
	name:          string,
	size:          [2]int, // e.g., [2,3] tiles (48x72 px)
	is_solid:      bool,
	has_door:      bool,
	door_offset:   [2]int, // tile offset inside decor where door warp triggers
	warp_target:   string, // level or interior id; ignored for now
	color:         rl.Color, // debug fallback
	source_rect:   rl.Rectangle, // if using atlas
}

// Placed instance in world
DecorInstance :: struct {
	def_index:  int,      // index into DECOR_DATABASE
	pos:        [2]int,   // top-left cell in map coordinates
	rotation:   int,      // 0..3 placeholder
}

// Database of building/decor types - extend without touching tile logic
DECOR_DATABASE := [1]DecorDef{
	{ name = "hut_2x2", size = {2, 2}, is_solid = true, has_door = true, door_offset = {1, 1}, warp_target = "interior_hut", color = {180, 120, 80, 255}, source_rect = {0, 0, 48, 48} },
}

// Runtime placed decors - would be persisted to level file version 2 later
decor_instances: [dynamic]DecorInstance

is_decor_solid_at :: proc(player_rect: rl.Rectangle) -> bool {
	// Check against all placed decors that are solid
	for d in decor_instances {
		def := DECOR_DATABASE[d.def_index]
		if !def.is_solid do continue
		// Door cell is non-solid to allow entry
		// For now treat whole footprint as solid except door tile
		for dy in 0..<def.size.y {
			for dx in 0..<def.size.x {
				if def.has_door && dx == def.door_offset.x && dy == def.door_offset.y {
					continue
				}
				cell_rect := rl.Rectangle{
					x      = f32((d.pos.x + dx) * TILE_SIZE),
					y      = f32((d.pos.y + dy) * TILE_SIZE),
					width  = f32(TILE_SIZE),
					height = f32(TILE_SIZE),
				}
				if rl.CheckCollisionRecs(player_rect, cell_rect) {
					return true
				}
			}
		}
	}
	return false
}

// Placeholder warp check - called from game loop when player overlaps door
check_decor_warp :: proc(player_pos: rl.Vector2) -> (bool, string) {
	player_rect := rl.Rectangle{ x = player_pos.x, y = player_pos.y, width = f32(PLAYER_SIZE), height = f32(PLAYER_SIZE) }
	for d in decor_instances {
		def := DECOR_DATABASE[d.def_index]
		if !def.has_door do continue
		door_rect := rl.Rectangle{
			x      = f32((d.pos.x + def.door_offset.x) * TILE_SIZE),
			y      = f32((d.pos.y + def.door_offset.y) * TILE_SIZE),
			width  = f32(TILE_SIZE),
			height = f32(TILE_SIZE),
		}
		if rl.CheckCollisionRecs(player_rect, door_rect) {
			return true, def.warp_target
		}
	}
	return false, ""
}

draw_decor_instances :: proc() {
	// Draw after dual but before player. Currently debug rects only.
	for d in decor_instances {
		def := DECOR_DATABASE[d.def_index]
		base_pos := rl.Vector2{ f32(d.pos.x * TILE_SIZE), f32(d.pos.y * TILE_SIZE) }
		size_px := rl.Vector2{ f32(def.size.x * TILE_SIZE), f32(def.size.y * TILE_SIZE) }
		rl.DrawRectangleV(base_pos, size_px, def.color)
		rl.DrawRectangleLinesEx({base_pos.x, base_pos.y, size_px.x, size_px.y}, 2, rl.BLACK)
		// Door marker
		if def.has_door {
			door_pos := rl.Vector2{ f32((d.pos.x + def.door_offset.x) * TILE_SIZE), f32((d.pos.y + def.door_offset.y) * TILE_SIZE) }
			rl.DrawRectangleV(door_pos, {TILE_SIZE, TILE_SIZE}, {100, 200, 100, 255})
			rl.DrawRectangleLinesEx({door_pos.x, door_pos.y, TILE_SIZE, TILE_SIZE}, 1, rl.WHITE)
		}
		rl.DrawText(cstring(raw_data(def.name)), i32(base_pos.x + 2), i32(base_pos.y + 2), 8, rl.WHITE)
	}
}

// Editor helpers for placing decors (stub - not yet wired to editor.odin)
decor_place :: proc(cell: [2]int, def_index: int) {
	append(&decor_instances, DecorInstance{ def_index = def_index, pos = cell })
}

decor_clear_all :: proc() {
	clear(&decor_instances)
}
