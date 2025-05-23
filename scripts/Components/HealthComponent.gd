extends Node
class_name HealthComponent

@export var max_health : int = 10
var temp_max_health : int
var current_health : int

signal died
signal health_changed(new_health : int)
signal damage_taken(amount : int)
signal health_generated(amount : int)

func _ready() -> void:
	current_health = max_health
	temp_max_health = max_health


func subtract_health(amount : int):
	current_health -= amount
	damage_taken.emit(amount)
	if current_health <= 0:
		current_health = 0
		died.emit()
	health_changed.emit(current_health)


func add_health(amount : int):
	current_health += amount
	health_generated.emit(amount)
	if current_health >= temp_max_health:
		current_health = temp_max_health
	health_changed.emit(current_health)


func change_max_health(amount : int):
	temp_max_health += amount
	if temp_max_health < 1:
		temp_max_health = 1
	health_changed.emit(current_health)
