extends Area2D
class_name HitBoxComponent

signal damage_taken(amount : int)

@rpc("any_peer","call_local")
func take_damage(amount : int):
	if is_multiplayer_authority():
		damage_taken.emit(amount)


func set_team(team : int):
	collision_layer = pow(2,team)
