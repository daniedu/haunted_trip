package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

LEVEL_PATH :: "assets/tiles/level_01.json"

LevelData :: struct {
	version: int,
	width:   int,
	height:  int,
	tiles:   [][]u8, // row-major height x width, values are TileType u8
}

save_level :: proc(path: string, m: Map) -> bool {
	// Convert Map to LevelData
	tiles := make([][]u8, MAP_HEIGHT)
	defer {
		// we need to keep inner slices until marshal completes, free after
	}
	for y in 0..<MAP_HEIGHT {
		row := make([]u8, MAP_WIDTH)
		for x in 0..<MAP_WIDTH {
			row[x] = u8(m[y][x])
		}
		tiles[y] = row
	}
	defer {
		for row in tiles do delete(row)
		delete(tiles)
	}

	data := LevelData{
		version = 1,
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

	// Ensure dir exists (best effort)
	// `assets/tiles` already exists per assets listing

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
		fmt.eprintf("load_level: size mismatch file %dx%d vs compiled %dx%d - will crop/pad\n", data.width, data.height, MAP_WIDTH, MAP_HEIGHT)
	}

	// Copy with crop/pad
	for y in 0..<MAP_HEIGHT {
		for x in 0..<MAP_WIDTH {
			if y < len(data.tiles) && x < len(data.tiles[y]) {
				v := data.tiles[y][x]
				// clamp to valid TileType
				if v <= u8(TileType.Water) {
					m[y][x] = TileType(v)
				} else {
					m[y][x] = .Floor
				}
			} else {
				m[y][x] = .Floor
			}
		}
	}
	fmt.printf("Loaded level from %s\n", path)
	return true
}
