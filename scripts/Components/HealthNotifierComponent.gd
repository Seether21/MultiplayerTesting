extends Node
class_name HealthNotifierComponent
@export var spawn_point : Node2D
@export var health_component: HealthComponent


func _ready() -> void:
	if spawn_point && health_component:
		health_component.damage_taken.connect(_on_damage_taken)
		health_component.health_generated.connect(_on_health_regen)

func _on_damage_taken(amount : int):
	_spawn_floating_text.rpc(str(amount),Color.RED)

func _on_health_regen(amount : int):
	_spawn_floating_text.rpc(str(amount),Color.GREEN)


@rpc("any_peer","call_local")
func _spawn_floating_text(value : String, color : Color):
	var label := FloatingTextLabel.new()
	label.color = color
	label.value = value
	spawn_point.add_child(label, true)
