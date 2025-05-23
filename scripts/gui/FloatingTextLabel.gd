extends Label
class_name FloatingTextLabel

var value : String
var scroll_speed : int = 25
var color : Color = Color.WHITE

func _ready() -> void:
	text = value
	modulate = color
	var timer := get_tree().create_timer(2)
	timer.timeout.connect(_despawn_text)

func _process(delta: float) -> void:
	global_position.y -= (scroll_speed * delta)


func timed_out():
	_despawn_text.rpc()


@rpc("any_peer","call_local")
func _despawn_text():
	self.queue_free()
