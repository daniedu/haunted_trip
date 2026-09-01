package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

LEVEL_PATH :: "levels/level_01.json"

// Manual double-grid: visual 17x17 tiles + 16x16 collision
LevelData :: struct {
	version:    int,
	width:      int,
	height:     int,
	visual_w:   int,
	visual_h:   int,
	tiles:      [][]u8,  // visual set_id+1 (17x17) 0 empty
	variants:   [][]u8,  // visual variant 0..15
	collision:  [][]u8,  // 16x16 0/1 solid
}

save_level :: proc(path: string, tiles: VisualMap, coll: CollisionMap) -> bool {
	vt := make([][]u8, VISUAL_H)
	vv := make([][]u8, VISUAL_H)
	for y in 0..<VISUAL_H {
		row := make([]u8, VISUAL_W)
		vrow := make([]u8, VISUAL_W)
		for x in 0..<VISUAL_W {
			c := tiles[y][x]
			if cell_is_empty(c) {
				row[x] = 0
				vrow[x] = 0
			} else {
				row[x] = u8(c.set_id + 1)
				vrow[x] = c.variant
			}
		}
		vt[y] = row
		vv[y] = vrow
	}
	ct := make([][]u8, MAP_HEIGHT)
	for y in 0..<MAP_HEIGHT {
		row := make([]u8, MAP_WIDTH)
		for x in 0..<MAP_WIDTH {
			row[x] = coll[y][x] ? 1 : 0
		}
		ct[y] = row
	}
	defer {
		for r in vt do delete(r)
		delete(vt)
		for r in vv do delete(r)
		delete(vv)
		for r in ct do delete(r)
		delete(ct)
	}

	data := LevelData{version = 6, width = MAP_WIDTH, height = MAP_HEIGHT, visual_w = VISUAL_W, visual_h = VISUAL_H, tiles = vt, variants = vv, collision = ct}
	bytes, err := json.marshal(data, {pretty = true})
	if err != nil {
		fmt.eprintf("save_level: marshal failed: %v\n", err)
		return false
	}
	defer delete(bytes)
	if os.write_entire_file(path, bytes) != nil {
		fmt.eprintf("save_level: write %s failed\n", path)
		return false
	}
	fmt.printf("Saved level to %s (%d bytes)\n", path, len(bytes))
	return true
}

load_level :: proc(path: string, tiles: ^VisualMap, coll: ^CollisionMap) -> bool {
	bytes, err_read := os.read_entire_file_from_path(path, context.allocator)
	if err_read != nil {
		fmt.eprintf("load_level: cannot read %s: %v\n", path, err_read)
		return false
	}
	defer delete(bytes)

	data: LevelData
	err := json.unmarshal(bytes, &data)
	if err != nil {
		fmt.eprintf("load_level: unmarshal failed: %v\n", err)
		return false
	}
	defer {
		for r in data.tiles do delete(r)
		delete(data.tiles)
		for r in data.variants do delete(r)
		delete(data.variants)
		for r in data.collision do delete(r)
		delete(data.collision)
	}

	if data.version < 4 {
		fmt.eprintf("load_level: legacy v%d -> default\n", data.version)
		tiles^ = make_default_visual()
		coll^ = make_default_collision()
		return false
	}

	// Load visual 17x17
	if data.tiles != nil {
		for y in 0..<VISUAL_H {
			for x in 0..<VISUAL_W {
				if y < len(data.tiles) && x < len(data.tiles[y]) {
					v := data.tiles[y][x]
					var: u8 = 15
					if data.variants != nil && y < len(data.variants) && x < len(data.variants[y]) {
						var = data.variants[y][x]
					}
					if v == 0 {
						tiles[y][x] = EmptyCell
					} else {
						id := int(v)-1
						if tileset_is_valid(id) {
							tiles[y][x] = TileCell{set_id = id, variant = var % 16}
						} else {
							tiles[y][x] = EmptyCell
						}
					}
				} else {
					tiles[y][x] = EmptyCell
				}
			}
		}
	}

	// Load collision 16x16
	if data.collision != nil {
		for y in 0..<MAP_HEIGHT {
			for x in 0..<MAP_WIDTH {
				if y < len(data.collision) && x < len(data.collision[y]) {
					coll[y][x] = data.collision[y][x] != 0
				} else {
					coll[y][x] = false
				}
			}
		}
	} else if data.version < 6 {
		// Old files had no separate collision: derive from visual tiles' solid where variant solid
		// For compat, keep existing coll as default
		coll^ = make_default_collision()
	}

	fmt.printf("Loaded level from %s (v%d)\n", path, data.version)
	return true
}

// Compat wrappers for old call sites (level with only tiles)
save_level_compat :: proc(path: string, m: VisualMap) -> bool {
	c := make_default_collision()
	return save_level(path, m, c)
}
