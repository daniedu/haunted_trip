package main

import rl "vendor:raylib"

Player :: struct {
	position:        rl.Vector2,
	velocity:        rl.Vector2,
	facing:          Direction,
	move_speed:      f32,
	base_speed:      f32, // for restoring after slower tiles
	equipped_weapon: WeaponType,
	is_attacking:    bool,
	attack_timer:    f32,
	attack_duration: f32,
}

Direction :: enum {
	Up,
	Down,
	Left,
	Right,
}
