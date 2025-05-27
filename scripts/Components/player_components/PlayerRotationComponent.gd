extends Node

@export var visuals_node : Node2D


func rotate_player(_delta : float):
	if !is_multiplayer_authority():
		return
	if !get_window().has_focus():
		return
	if !visuals_node:
		return
	var mouse_pos = visuals_node.get_global_mouse_position()
	var direction := visuals_node.global_position.direction_to(mouse_pos)
	visuals_node.rotation = direction.angle() - deg_to_rad(90)
