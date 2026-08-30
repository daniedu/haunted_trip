package main

import "core:fmt"
import rl "vendor:raylib"

// Single-tileset registry. Add more later by appending to TILESET_DECLS.
// Each entry is 96x96 4x4@24, 16 tiles 0000..1111 with optional remap.

TilesetDecl :: struct {
	name:      string, // e.g. "oild"
	file:      string, // 96x96
	color:     rl.Color,
	is_solid:  bool,
	is_slower: bool,
	has_remap: bool,
	remap:     [16]u8,
	autotile:  bool,
}

// 16 rects for 96x96 and legacy 384x24
DUAL_TILE_RECTS_GRID_96 := [16]rl.Rectangle{
	{  0*24, 0*24, 24, 24 }, {  1*24, 0*24, 24, 24 }, {  2*24, 0*24, 24, 24 }, {  3*24, 0*24, 24, 24 },
	{  0*24, 1*24, 24, 24 }, {  1*24, 1*24, 24, 24 }, {  2*24, 1*24, 24, 24 }, {  3*24, 1*24, 24, 24 },
	{  0*24, 2*24, 24, 24 }, {  1*24, 2*24, 24, 24 }, {  2*24, 2*24, 24, 24 }, {  3*24, 2*24, 24, 24 },
	{  0*24, 3*24, 24, 24 }, {  1*24, 3*24, 24, 24 }, {  2*24, 3*24, 24, 24 }, {  3*24, 3*24, 24, 24 },
}
DUAL_TILE_RECTS_ROW_384 := [16]rl.Rectangle{
	{  0*24, 0, 24, 24 }, {  1*24, 0, 24, 24 }, {  2*24, 0, 24, 24 }, {  3*24, 0, 24, 24 },
	{  4*24, 0, 24, 24 }, {  5*24, 0, 24, 24 }, {  6*24, 0, 24, 24 }, {  7*24, 0, 24, 24 },
	{  8*24, 0, 24, 24 }, {  9*24, 0, 24, 24 }, { 10*24, 0, 24, 24 }, { 11*24, 0, 24, 24 },
	{ 12*24, 0, 24, 24 }, { 13*24, 0, 24, 24 }, { 14*24, 0, 24, 24 }, { 15*24, 0, 24, 24 },
}
get_dual_rect :: proc(idx: u8, tileset: rl.Texture2D) -> rl.Rectangle {
	if int(tileset.width) == 384 && int(tileset.height) == 24 do return DUAL_TILE_RECTS_ROW_384[idx]
	if int(tileset.width) == 96 && int(tileset.height) == 96 do return DUAL_TILE_RECTS_GRID_96[idx]
	if tileset.width > tileset.height * 2 do return DUAL_TILE_RECTS_ROW_384[idx]
	return DUAL_TILE_RECTS_GRID_96[idx]
}

OILD_REMAP :: [16]u8{6, 5, 2, 3, 10, 1, 4, 13, 7, 14, 11, 0, 9, 8, 15, 12}

TILESET_DECLS: []TilesetDecl = {
	{
		name = "oild", file = "assets/tiles/oild_tiles.png", has_remap = true, remap = OILD_REMAP, autotile = true,
		color = {90, 90, 95, 255}, is_solid = false, is_slower = false,
	},
}

TilesetRuntime :: struct {
	decl:    TilesetDecl,
	texture: rl.Texture2D,
	ready:   bool,
}

tileset_runtime: [dynamic]TilesetRuntime
tilesets_loaded := false

tilesets_load :: proc() -> bool {
	if tilesets_loaded do return true
	resize(&tileset_runtime, len(TILESET_DECLS))
	any_ok := false
	for decl, idx in TILESET_DECLS {
		rt := &tileset_runtime[idx]
		rt.decl = decl
		rt.ready = false
		rt.texture = {}
		if decl.file != "" && rl.FileExists(cstring(raw_data(decl.file))) {
			tex := rl.LoadTexture(cstring(raw_data(decl.file)))
			if rl.IsTextureReady(tex) {
				rt.texture = tex
				rt.ready = true
				any_ok = true
				if int(tex.width) != 96 || int(tex.height) != 96 {
					fmt.printfln("Tileset %s: %dx%d expected 96x96", decl.name, tex.width, tex.height)
				} else {
					fmt.printfln("Loaded tileset %s -> %s 96x96", decl.name, decl.file)
				}
			} else {
				fmt.printfln("Tileset %s: failed to load %s", decl.name, decl.file)
			}
		} else if decl.file != "" {
			fmt.printfln("Tileset %s: file not found %s", decl.name, decl.file)
		}
	}
	tilesets_loaded = true
	return any_ok
}

tilesets_unload :: proc() {
	for &rt in tileset_runtime {
		if rt.ready && rl.IsTextureReady(rt.texture) {
			rl.UnloadTexture(rt.texture)
			rt.ready = false
		}
	}
	tilesets_loaded = false
}

tileset_get_runtime_by_id :: proc(id: int) -> ^TilesetRuntime {
	return &tileset_runtime[id]
}
tileset_get_texture_by_id :: proc(id: int) -> rl.Texture2D {
	return tileset_runtime[id].texture
}
tileset_is_ready_by_id :: proc(id: int) -> bool {
	return tileset_runtime[id].ready
}

tileset_get_rect_by_id :: proc(set_id: int, logical_idx: u8) -> rl.Rectangle {
	if set_id < 0 || set_id >= len(tileset_runtime) do return {}
	rt := tileset_runtime[set_id]
	tex := rt.texture
	physical_idx := logical_idx
	if rt.decl.has_remap {
		physical_idx = rt.decl.remap[logical_idx]
	}
	if int(tex.width) == 96 && int(tex.height) == 96 {
		col := int(physical_idx) % 4
		row := int(physical_idx) / 4
		return { f32(col*24), f32(row*24), 24, 24 }
	}
	if int(tex.width) == 384 && int(tex.height) == 24 {
		return { f32(int(physical_idx)*24), 0, 24, 24 }
	}
	return get_dual_rect(physical_idx, tex)
}
