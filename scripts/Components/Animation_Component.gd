extends Node

@export var player_controller : CharacterBody2D
@export var animation_player : AnimatedSprite2D
@export var idle_threshold : float = .2
@export var min_speed : int = 10

func _change_animation(animation : StringName, speed : float = 1.0):
	if !animation_player:
		return
	animation_player.play(animation,speed)


func on_process(_delta : float):
	if !player_controller:
		return
	if !animation_player:
		return
	var animation_speed := player_controller.velocity.length()
	if animation_speed < .2:
		_change_animation("idle")
		return
	_change_animation("walk",animation_speed / min_speed)
