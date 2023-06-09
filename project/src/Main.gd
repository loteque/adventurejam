extends Node2D

export (NodePath) var level_manager_node_path = "LevelManager"
export (NodePath) var music_manager_node_path = "MusicManager"
export (NodePath) var touch_ui_node_path = "TouchUI"
export (NodePath) var debug_ui_node_path = "DebugUI"
export (NodePath) var player_ui_node_path = "PlayerUI"
export (NodePath) var pause_screen_node_path = "PauseScreen"
export (NodePath) var settings_screen_node_path = "SettingsScreen"
export (NodePath) var player_controller_node_path = "PlayerController"

onready var level_manager: Node = get_node(level_manager_node_path)
onready var music_manager: Node = get_node(music_manager_node_path)
onready var touch_ui: Node = get_node(touch_ui_node_path)
onready var player_ui: Node = get_node(player_ui_node_path)
onready var debug_ui: Node = get_node(debug_ui_node_path)
onready var pause_screen: Node = get_node(pause_screen_node_path)
onready var settings_screen: Node = get_node(settings_screen_node_path)
onready var player_controller: Node = get_node(player_controller_node_path)

var level_node: Node
var is_paused: bool = false

signal started_raining
signal stopped_raining
signal collided

func init_vars():
	level_node = level_manager.scene_node

func _input(event):
	if event.is_action_pressed("toggle_pause"):
		toggle_pause()
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func _ready():
	init_vars()
	level_manager.next_scene()

func toggle_pause():
	if is_paused && level_manager.scene_node.name != "StartSceen":
		antipause()
	elif !is_paused && level_manager.scene_node.name != "StartScreen":
		pause()

func pause():
	get_tree().paused = true
	is_paused = true
	pause_screen.show()

func antipause():
	get_tree().paused = false
	is_paused = false
	pause_screen.hide()
	
func quit():
	get_tree().quit()
