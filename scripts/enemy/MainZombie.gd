extends CharacterBody2D
class_name EnemyController

@export var nav_agent : NavigationAgent2D
@export var nav_agent_update_rate : float = .1

@onready var state_chart: StateChart = $StateChart
@onready var player_detection: Area2D = $PlayerDetection

var last_nav_update : float

signal target_found(target : Node2D)

func set_navigation_target(new_target : Vector2, verify : bool = false):
	if !nav_agent:
		return
	var target := new_target
	if verify:
		var map := nav_agent.get_navigation_map()
		target = NavigationServer2D.map_get_closest_point(map,new_target)
	nav_agent.target_position = target


func get_next_nav_point()-> Vector2:
	if !nav_agent:
		return Vector2.INF
	return nav_agent.get_next_path_position()


func target_point_reached()-> bool:
	return nav_agent.is_target_reached()


func _on_wander_component_wander_completed() -> void:
	state_chart.send_event("wander_complete")



func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		state_chart.send_event("chase")
		target_found.emit(body)
		


func _on_chase_component_chase_complete() -> void:
	var bodies := player_detection.get_overlapping_bodies()
	if !bodies:
		state_chart.send_event("chase_complete")
		return
	for body in bodies:
		if body.is_in_group("Player"):
			state_chart.send_event("chase")
			target_found.emit(body)
			return


func _on_chase_component_no_target() -> void:
	var bodies := player_detection.get_overlapping_bodies()
	if !bodies:
		state_chart.send_event("chase_complete")
		return
	for body in bodies:
		if body.is_in_group("Player"):
			state_chart.send_event("chase")
			target_found.emit(body)
			return


func _on_health_component_died() -> void:
	self.queue_free()
