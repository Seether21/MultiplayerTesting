extends CanvasLayer

@export var fire_component : FireComponent
@export var ammo_label : Label
@export var reload_progress_bar : TextureProgressBar
@export var health_bar : ProgressBar
@export var health_component : HealthComponent
@export var health_label : Label

var reload : bool = true

func _ready() -> void:
	if !is_multiplayer_authority():
		queue_free()
		return
	if fire_component:
		fire_component.fired.connect(_weapon_fired)
		fire_component.no_weapon.connect(_no_weapon)
		fire_component.out_of_ammo.connect(_weapon_reload)
		fire_component.reload_complete.connect(_reload_complete)
	if ammo_label && !fire_component:
		ammo_label.hide()
	if reload_progress_bar:
		reload_progress_bar.hide()
	if health_bar && health_component:
		_update_health_bar()
	elif health_bar:
		health_bar.hide()


func _weapon_fired():
	_update_ammo_lable()


func _weapon_reload():
	_update_ammo_lable()
	reload = true
	if reload_progress_bar:
		reload_progress_bar.show()


func _no_weapon():
	_update_ammo_lable()
	reload = false
	if reload_progress_bar:
		reload_progress_bar.hide()


func _reload_complete():
	_update_ammo_lable()
	reload = false
	if reload_progress_bar:
		reload_progress_bar.hide()


func _update_ammo_lable():
	if !ammo_label:
		return
	if fire_component.current_weapon == null:
		ammo_label.hide()
	elif !ammo_label.visible:
		ammo_label.show()
	ammo_label.text = "x"+str(fire_component.current_weapon.current_ammo)


func _update_health_bar(new_amount : int = 0):
	health_bar.value = (float(health_component.current_health) / float(health_component.max_health)) * 100.0
	if health_label:
		health_label.text = str(health_component.current_health) + "/" + str(health_component.max_health)


func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	if reload && reload_progress_bar:
		reload_progress_bar.value = fire_component.reload_percentage
