extends TextureProgressBar

@export var fire_component : FireComponent

func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !fire_component:
		return
	value = fire_component.reload_percentage
	if value == 0:
		hide()
	elif  !visible:
		show()
