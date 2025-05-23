extends Area2D
class_name HitBoxComponent

signal damage_taken(amount : int)


func take_damage(amount : int):
	damage_taken.emit(amount)


func set_team(team : int):
	collision_layer = pow(2,team)
