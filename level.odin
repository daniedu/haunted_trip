package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

LEVEL_PATH :: "levels/level_01.json"

LevelData :: struct {
	version: int,
	width:   int,
	height:  int,
	tiles:   [][]u8, // 0=empty, 1=oild
}

cell_to_u8 :: proc(c: TileCell) -> u8 {
	if cell_is_empty(c) do return 0
	// single set: 0->1, future sets will be +1 offset
	return u8(c.set_id + 1)
}
u8_to_cell :: proc(v: u8) -> TileCell {
	if v == 0 do return EmptyCell
	set_id := int(v) - 1
	if set_id < 0 || set_id >= len(TILESET_DECLS) do return EmptyCell
	return TileCell{set_id = set_id}
}

save_level :: proc(path: string, m: Map) -> bool {
	tiles := make([][]u8, MAP_HEIGHT)
	defer {}
	for y in 0 ..< MAP_HEIGHT {
		row := make([]u8, MAP_WIDTH)
		for x in 0 ..< MAP_WIDTH {
			row[x] = cell_to_u8(m[y][x])
		}
		tiles[y] = row
	}
	defer {
		for row in tiles do delete(row)
		delete(tiles)
	}

	data := LevelData {
		version = 4,
		width   = MAP_WIDTH,
		height  = MAP_HEIGHT,
		tiles   = tiles,
	}
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

load_level :: proc(path: string, m: ^Map) -> bool {
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
		for row in data.tiles do delete(row)
		delete(data.tiles)
	}

	if data.width != MAP_WIDTH || data.height != MAP_HEIGHT {
		fmt.eprintf(
			"load_level: size mismatch file %dx%d vs compiled %dx%d - crop/pad\n",
			data.width,
			data.height,
			MAP_WIDTH,
			MAP_HEIGHT,
		)
	}

	// ignore versions <4 (legacy inner/outer and TileType)
	if data.version < 4 {
		fmt.eprintf("load_level: ignoring legacy version %d, using default map\n", data.version)
		m^ = make_default_map()
		return false
	}

	for y in 0 ..< MAP_HEIGHT {
		for x in 0 ..< MAP_WIDTH {
			if y < len(data.tiles) && x < len(data.tiles[y]) {
				m[y][x] = u8_to_cell(data.tiles[y][x])
			} else {
				m[y][x] = EmptyCell
			}
		}
	}
	fmt.printf("Loaded level from %s (v%d)\n", path, data.version)
	return true
}
