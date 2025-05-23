extends CharacterBody2D

var sprint := false
var stunned := false


@onready var state_chart: StateChart = $StateChart
@onready var death_counter: Timer = $Components/DeathCounter

@export var current_weapon : WeaponData
@export_range(1,4,1) var current_team : int
@onready var camera: Camera2D = $Camera2D

signal weapon_changed(weapon_data : WeaponData)
signal team_changed(new_team : int)
signal sprint_changed(sprint : bool)


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	if is_multiplayer_authority():
		camera.make_current()
	state_chart.set_expression_property("stunned",stunned)
	weapon_changed.emit(current_weapon)
	set_team(current_team)


func set_team(new_team : int):
	current_team = new_team
	team_changed.emit(new_team)


func _on_movement_component_movement() -> void:
	state_chart.send_event("walk")


func _on_movement_component_no_movement() -> void:
	state_chart.send_event("idle")


func stun_player(time : float = 5.0):
	stunned = true
	state_chart.set_expression_property("stunned", stunned)
	var timer := get_tree().create_timer(time)
	timer.timeout.connect(_remove_stunned)


func _remove_stunned():
	if stunned:
		stunned = false
		state_chart.set_expression_property("stunned", stunned)


func try_sprint():
	sprint = !sprint
	sprint_changed.emit(sprint)


func _on_fire_component_out_of_ammo() -> void:
	state_chart.send_event("reload")


func _on_fire_component_reload_complete() -> void:
	state_chart.send_event("reload_complete")


func _on_fire_component_no_weapon() -> void:
	pass # Replace with function body.


func _on_death_counter_timeout() -> void:
	state_chart.send_event("died")


func _on_health_component_died() -> void:
	death_counter.start()
