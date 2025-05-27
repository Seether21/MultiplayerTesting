extends Area2D
class_name HurtBoxComponent

@export var friendly_fire := false

signal object_hit(area : Area2D)

func set_team(new_team : int, friendly : bool = false):
	if !friendly_fire:
		friendly_fire = friendly
	var new_mask : int = 0
	for i in 7:
		if i == new_team && friendly_fire:
			new_mask += pow(2,i)
		elif i != new_team:
			new_mask += pow(2,i)
	collision_mask = new_mask
