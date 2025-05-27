extends ProgressBar

@export var health_component : HealthComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !health_component:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	health_component.health_changed.connect(health_changed)
	health_component.max_health_changed.connect(max_health_changed)
	value = health_component.current_health
	max_value = health_component.temp_max_health


func _process(delta: float) -> void:
	if value == max_value && !visible:
		hide()
	elif value < max_value && !visible:
		show()


func health_changed(new_health : int):
	value = new_health


func max_health_changed(new_health : int):
	max_value = new_health
