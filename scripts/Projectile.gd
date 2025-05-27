extends Node2D
class_name Projectile
@export var base_speed : int = 400
@export var hurtbox : HurtBoxComponent
var base_damage : int = 1
var start_position: Vector2
var start_rotation: float

signal team_set(new_team : int, friend_fire : bool)

func set_data(new_team : int, friendly_fire := false, damage : int = 1):
	team_set.emit(new_team,friendly_fire)
	if hurtbox:
		hurtbox.set_team(new_team,friendly_fire)
	base_damage = damage

func _ready() -> void:
	global_rotation = start_rotation
	global_position = start_position

func _physics_process(delta: float) -> void:
	var move_vec = transform.x * base_speed
	global_position += move_vec * delta


func _do_damage(hitBox : HitBoxComponent, damage : int):
	hitBox.take_damage.rpc(damage)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is HitBoxComponent:
		_do_damage(area as HitBoxComponent, base_damage)
	_despawn.rpc()


@rpc("any_peer","call_local")
func _despawn():
	self.call_deferred("queue_free")
