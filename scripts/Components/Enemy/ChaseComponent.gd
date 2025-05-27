extends Node

@export var min_distance : int = 0
@export var max_distance : int = 250
@export var update_rate : float = .1
@export var controller : EnemyController

var last_update : float
var current_target : Node2D

signal no_target
signal chase_complete
signal try_move(direction : Vector2, delta : float, run : bool)

func start_chase(target : Node2D):
	if !is_instance_valid(target):
		if !is_instance_valid(current_target):
			no_target.emit()
		return
	if !is_instance_valid(current_target):
		current_target = target
	elif controller:
		if target.global_position.distance_squared_to(controller.global_position) < current_target.global_position.distance_squared_to(controller.global_position):
			current_target = target


func chase_target(delta : float):
	if !is_instance_valid(current_target):
		return
	if !controller:
		return
	_update_target_position()
	var target := controller.get_next_nav_point()
	var direction := controller.global_position.direction_to(target)
	try_move.emit(direction,delta,true)


func _update_target_position():
	if Time.get_unix_time_from_system() - last_update < update_rate:
		return
	last_update = Time.get_unix_time_from_system()
	controller.set_navigation_target(current_target.global_position,false)
	if controller.global_position.distance_squared_to(current_target.global_position) <= (min_distance * min_distance):
		distance_met()
		return
	if controller.global_position.distance_squared_to(current_target.global_position) > (max_distance * max_distance):
		chase_failed()
		return


func distance_met():
	chase_complete.emit()


func chase_failed():
	no_target.emit()
	current_target = null


func exit_chase():
	current_target = null
