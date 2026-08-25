package main

import rl "vendor:raylib"

WeaponType :: enum {
	None,
	Sword,
	Bow,
	Staff,
}

WeaponData :: struct {
	attack_duration: f32,
	range:           f32,
	damage:          int,
	length:          f32, // How far out in front it reaches
	width:           f32, // How wide the swipe/hitbox is
}


WEAPON_STATS := [WeaponType]WeaponData {
	.None = {attack_duration = 0.1, length = 8.0, width = 8.0, damage = 1},
	.Sword = {attack_duration = 0.2, length = 20.0, width = 32.0, damage = 5}, // Wide horizontal sweep feel
	.Bow = {attack_duration = 0.3, length = 25.0, width = 12.0, damage = 4},
	.Staff = {attack_duration = 0.4, length = 22.0, width = 22.0, damage = 6},
}
get_weapon_rect :: proc(player: Player) -> rl.Rectangle {
	weapon := WEAPON_STATS[player.equipped_weapon]
	player_size :: 32.0

	rect := rl.Rectangle{}

	switch player.facing {
	case .Up:
		// Up/Down: Width goes horizontal, Length goes vertical (upward)
		rect.width = weapon.width
		rect.height = weapon.length
		rect.x = player.position.x + (player_size / 2) - (rect.width / 2)
		rect.y = player.position.y - rect.height

	case .Down:
		rect.width = weapon.width
		rect.height = weapon.length
		rect.x = player.position.x + (player_size / 2) - (rect.width / 2)
		rect.y = player.position.y + player_size

	case .Left:
		// Left/Right: Length goes horizontal (leftward), Width goes vertical
		rect.width = weapon.length
		rect.height = weapon.width
		rect.x = player.position.x - rect.width
		rect.y = player.position.y + (player_size / 2) - (rect.height / 2)

	case .Right:
		rect.width = weapon.length
		rect.height = weapon.width
		rect.x = player.position.x + player_size
		rect.y = player.position.y + (player_size / 2) - (rect.height / 2)
	}

	return rect
}
