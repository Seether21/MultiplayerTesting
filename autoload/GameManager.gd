extends Node


var friendly_fire : bool = true
signal friendly_fire_changed(toggle : bool)

func _ready() -> void:
	friendly_fire_changed.emit(friendly_fire)

@rpc("authority","call_local")
func friendly_fire_toggle()-> void:
	friendly_fire = !friendly_fire
	friendly_fire_changed.emit(friendly_fire)


func _player_joined(player_info : Dictionary):
	pass
