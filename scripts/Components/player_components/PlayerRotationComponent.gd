extends Node

@export var player_controller : Node2D


func rotate_player(_delta : float):
	if !is_multiplayer_authority():
		return
	if !player_controller:
		return
	var mouse_pos = player_controller.get_global_mouse_position()
	player_controller.look_at(mouse_pos)
