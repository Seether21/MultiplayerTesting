extends Node
class_name MovementComponent

@export var walk_speed : int = 10.0
@export var run_speed : int = 25.0
@export var controller : CharacterBody2D
@export var acceleration := 2.0

signal movement
signal no_movement

func _run(direction : Vector2,delta : float):
	if !controller:
		return
	var old_velocity := controller.velocity
	var new_velocity := direction * run_speed
	_move(old_velocity.lerp(new_velocity, delta * acceleration))


func _walk(direction : Vector2,delta : float):
	if !controller:
		return
	var new_velocity := direction * walk_speed
	var old_velocity := controller.velocity
	_move(old_velocity.lerp(new_velocity, delta * acceleration))


func _stop(delta: float):
	if !controller:
		return
	_move(controller.velocity.lerp(Vector2.ZERO, delta * acceleration))


func _move(new_velocity : Vector2):
	if controller:
		controller.velocity = new_velocity
		controller.move_and_slide()


func try_move(direction : Vector2, delta : float, sprint : bool = false):
	if direction.is_zero_approx():
		_stop(delta)
	if sprint:
		_run(direction,delta)
	else:
		_walk(direction,delta)
	
