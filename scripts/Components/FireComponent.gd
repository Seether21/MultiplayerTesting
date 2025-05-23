extends Node
class_name FireComponent

@export var spawn_point : Node2D
@export var friendly_fire = false
signal fired
signal out_of_ammo
signal reload_complete
signal no_weapon
var current_weapon : WeaponData
var last_fired_time : float
var reloading : bool = false
var reload_percentage := 0.0

var current_team : int

func _ready() -> void:
	if !is_multiplayer_authority():
		return
	GameManager.friendly_fire_changed.connect(_set_friendly_fire)


func set_team(new_team : int):
	current_team = new_team

func _set_friendly_fire(toggle : bool):
	friendly_fire = toggle


func fire():
	if !spawn_point:
		return
	if !current_weapon:
		no_weapon.emit()
		return
	if current_weapon.current_ammo <= 0:
		out_of_ammo.emit()
		return
	if Time.get_unix_time_from_system() - last_fired_time < current_weapon.fire_rate:
		return
	_spawn_bullet.rpc()
	
	last_fired_time = Time.get_unix_time_from_system()
	current_weapon.current_ammo -= 1
	fired.emit()

@rpc("any_peer","call_local")
func _spawn_bullet():
	var projectile = current_weapon.projectile_scene.instantiate() as Projectile
	projectile.set_data(current_team,friendly_fire,1)
	var spawn_node := get_tree().get_first_node_in_group("ProjectileSpawns")
	if !spawn_node:
		return
	projectile.start_position = spawn_point.global_position
	projectile.start_rotation = spawn_point.global_rotation
	spawn_node.add_child(projectile, true)


func set_new_weapon(weapon_data : WeaponData):
	current_weapon = weapon_data
	reloading = false
	reload_percentage = 0.0
	


func try_fire():
	if reloading:
		out_of_ammo.emit()
		return
	if !current_weapon:
		return
	fire()


func reload(delta : float):
	reload_percentage += (delta / current_weapon.reload_time) * 100
	if reload_percentage >= 100:
		reloading = false
		reload_percentage = 0.0
		current_weapon.current_ammo = current_weapon.max_ammo
		reload_complete.emit()


func start_reload():
	if !reloading:
		reload_percentage = 0.0
		reloading = true
