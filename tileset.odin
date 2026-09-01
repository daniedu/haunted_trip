package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

// Registry — add a new terrain by appending one entry.
// PNG is 96x96 from aseprite. Your export is physical order, we map logical 0000..1111 -> physical via TILE_REMAP.
// 0 outer (0000), 15 inner (1111), 1..14 edges. Not listed = walkable.
Tileset :: struct {
	name:   string, // e.g. "oild"
	file:   string, // 96x96 path
	solid:  [16]bool, // per connection 0..15 blocks
	slower: [16]bool, // per connection slows (water/mud)
}

// Helper for easy decl: solid=mask({0,1,15}) -> those connections solid
mask :: proc "contextless" (ids: []int) -> [16]bool {
	m: [16]bool
	for id in ids {
		if id >= 0 && id < 16 do m[id] = true
	}
	return m
}
// All except outer 0 — use for walls/pits where any presence blocks (single cell still solid)
mask_all :: proc "contextless" () -> [16]bool {
	m: [16]bool
	for i in 1 ..< 16 do m[i] = true
	return m
}

// Aseprite export physical order -> logical. Keep here so we don't reorder your PNGs.
TILE_REMAP: [16]u8 = {6, 5, 2, 3, 10, 1, 4, 13, 7, 14, 11, 0, 9, 8, 15, 12}

TILESET_DECLS: []Tileset = {
	{name = "oild", file = "assets/tiles/oild_tiles.png"}, // all walkable
	{name = "pit", file = "assets/tiles/dirt_96.png", solid = mask_all()},
	{name = "water", file = "assets/tiles/water_96.png", solid = mask_all()}, // same outer grass, inner blue, solid for test (any pit/water blocks)
	// pit inner only (large lakes with walkable shallow edges): solid=mask({15})
	// {name = "lava", file = "assets/tiles/lava_96.png", solid=mask({15}), slower=mask_all()},
}

// Per-connection queries used by collision + editor
is_dual_solid :: proc(set_id: int, idx: u8) -> bool {
	if set_id < 0 || set_id >= len(TILESET_DECLS) do return false
	return TILESET_DECLS[set_id].solid[idx]
}
is_dual_slower :: proc(set_id: int, idx: u8) -> bool {
	if set_id < 0 || set_id >= len(TILESET_DECLS) do return false
	return TILESET_DECLS[set_id].slower[idx]
}

// Runtime — one per decl, loaded at startup.
TilesetRuntime :: struct {
	decl:    Tileset,
	texture: rl.Texture2D,
	ready:   bool,
}

tileset_runtime: [dynamic]TilesetRuntime

tilesets_load :: proc() -> bool {
	resize(&tileset_runtime, len(TILESET_DECLS))
	any_ok := false
	for decl, i in TILESET_DECLS {
		rt := &tileset_runtime[i]
		rt.decl = decl
		rt.ready = false
		rt.texture = {}
		if decl.file == "" do continue
		cpath := strings.clone_to_cstring(decl.file, context.temp_allocator)
		tex := rl.LoadTexture(cpath)
		if rl.IsTextureReady(tex) {
			rt.texture = tex
			rt.ready = true
			any_ok = true
			if int(tex.width) != 96 || int(tex.height) != 96 {
				fmt.printfln("Tileset %s: %dx%d expected 96x96", decl.name, tex.width, tex.height)
			} else {
				fmt.printfln("Loaded tileset %s -> %s", decl.name, decl.file)
			}
		} else {
			fmt.printfln("Tileset %s: failed to load %s", decl.name, decl.file)
		}
	}
	return any_ok
}

tilesets_unload :: proc() {
	for &rt in tileset_runtime {
		if rt.ready && rl.IsTextureReady(rt.texture) {
			rl.UnloadTexture(rt.texture)
			rt.ready = false
		}
	}
}

tileset_get_runtime_by_id :: proc(id: int) -> ^TilesetRuntime {
	assert(id >= 0 && id < len(tileset_runtime), "tileset id out of range")
	return &tileset_runtime[id]
}
tileset_get_texture_by_id :: proc(id: int) -> rl.Texture2D {
	assert(id >= 0 && id < len(tileset_runtime))
	return tileset_runtime[id].texture
}
tileset_is_ready_by_id :: proc(id: int) -> bool {
	if id < 0 || id >= len(tileset_runtime) do return false
	return tileset_runtime[id].ready
}

tileset_get_rect_by_id :: proc(set_id: int, logical_idx: u8) -> rl.Rectangle {
	if set_id < 0 || set_id >= len(tileset_runtime) do return {}
	physical := TILE_REMAP[logical_idx]
	col := int(physical) % 4
	row := int(physical) / 4
	return {f32(col * TILE_SIZE), f32(row * TILE_SIZE), f32(TILE_SIZE), f32(TILE_SIZE)}
}

// Find id by name, -1 if not found. Use at init/editor only.
find_tileset_by_name :: proc(name: string) -> int {
	for decl, i in TILESET_DECLS {
		if decl.name == name do return i
	}
	return -1
}
