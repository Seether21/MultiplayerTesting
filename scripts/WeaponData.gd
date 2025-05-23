extends Resource
class_name WeaponData


@export var fire_rate : float
@export var max_ammo : int
@export var reload_time : float
@export var projectile_scene : PackedScene
@export var current_ammo := 0
@export var fire_mode : Fire_Mode


enum Fire_Mode{
	SEMI_AUTO,
	FULL_AUTO
}
