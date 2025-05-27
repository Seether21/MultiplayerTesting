extends Node

@export var wander_distance := 95
@export var max_wander_time := 5.0
@export var enemy_controller : EnemyController


signal wander_started(new_point : Vector2)
signal wander_completed()
signal try_move(direction : Vector2, delta : float, sprint : bool)

var is_active : bool = false
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	timer.timeout.connect(wander_complete)
	add_child(timer)


func pick_wander_point():
	is_active = true
	if !enemy_controller:
		return
	var current_pos := enemy_controller.global_position
	var angle := randf()  * TAU
	var distance := randf() * wander_distance
	var offset := Vector2(cos(angle), sin(angle)) * distance
	var target_pos := current_pos + offset
	enemy_controller.set_navigation_target(target_pos,true)
	timer.start(max_wander_time)
	



func update_navigation(delta : float):
	if !enemy_controller:
		return
	var target := enemy_controller.get_next_nav_point()
	var direction := enemy_controller.global_position.direction_to(target)
	try_move.emit(direction,delta,false)


func wander_complete():
	if is_active:
		is_active = false
		wander_completed.emit()
		timer.stop()


func state_exited()-> void:
	is_active = false
	timer.stop()
