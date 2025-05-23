extends Node


signal move_direction(direction : Vector2, delta : float, sprint : bool)
signal try_fire
signal try_sprint
var sprinting := false

@export var fire_component : FireComponent

func check_for_movement(delta : float):
	if !is_multiplayer_authority():
		return
	var y := Input.get_axis("up","down")
	var x := Input.get_axis("left","right")
	var direction := Vector2(x,y)
	move_direction.emit(direction, delta, sprinting)
	if Input.is_action_just_pressed("sprint"):
		try_sprint.emit()



func set_sprint(sprint : bool):
	sprinting = sprint


func check_for_fire(_delta : float):
	if !is_multiplayer_authority():
		return
	if !fire_component:
		return
	if !fire_component.current_weapon:
		return
	var fire_mode := fire_component.current_weapon.fire_mode
	match fire_mode:
		WeaponData.Fire_Mode.SEMI_AUTO:
			if Input.is_action_just_pressed("fire"):
				try_fire.emit()
		WeaponData.Fire_Mode.FULL_AUTO:
			if Input.is_action_pressed("fire"):
				try_fire.emit()
