extends CanvasLayer


@onready var port: LineEdit = $VBoxContainer/HBoxContainer/Port
@onready var ip_line_edit: LineEdit = $VBoxContainer/HBoxContainer/IPLineEdit
@onready var players: Node2D = $"../Players"
@onready var status_label: Label = $StatusLabel

var default_address := "127.0.0.1"
var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene


func _ready() -> void:
	status_label.text = ""

func _on_join_pressed() -> void:
	if !port.text:
		return
	if !port.text.is_valid_int():
		return
	var ip_address := ip_line_edit.text
	if !ip_address:
		ip_address = default_address
	peer.create_client(ip_address,int(port.text))
	multiplayer.multiplayer_peer = peer
	hide()


func _on_host_pressed() -> void:
	if !port.text:
		return
	if !port.text.is_valid_int():
		return
	peer.create_server(int(port.text))
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	hide()


func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	players.call_deferred("add_child",player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)


func del_player(id):
	rpc("_del_player", id)


@rpc("any_peer","call_local")
func _del_player(id):
	players.get_node(str(id)).queue_free()
