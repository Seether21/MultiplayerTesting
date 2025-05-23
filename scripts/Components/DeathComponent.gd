extends Node
class_name DeathComponent

@export var parent : Node
@export var animation_player : AnimatedSprite2D

func _die():
	if animation_player:
		animation_player.play("death")
		await animation_player.animation_finished
	if parent:
		parent.call_deferred("queu_free")
