package main


Player :: struct {
	position:        rl.Vector2,
	velocity:        rl.Vector2,
	facing:          Direction,
	move_speed:      f32,
	equipped_weapon: WeaponType,
	is_attacking:    bool,
	attack_timer:    f32,
	attack_duration: f32,
}
