extends Node

export (NodePath) var main_node_path = ".."
export (NodePath) var player_controller_node_path = "../PlayerController"

onready var main: Node = get_node(main_node_path)
onready var player_controller: = get_node(player_controller_node_path)

onready var scene_node: Node

var scene_paths = ["res://src/level/StartScreen.tscn",
				   "res://src/level/JunkYard.tscn", 
				   "res://src/level/Forest.tscn", 
				   "res://src/level/City.tscn"]

var current_scene_paths_index: int = scene_paths.size()

func next_scene():
	
	if current_scene_paths_index < scene_paths.size() - 1:
		unload_scene(scene_node)
		load_scene_by_index(current_scene_paths_index + 1)
		current_scene_paths_index += 1
		handle_player()
		handle_player_ui()
	else:
		unload_scene(scene_node)
		load_scene_by_index(0)
		current_scene_paths_index = 0
		handle_player()
		handle_player_ui()
		
func load_scene_by_index(scene_paths_index):
		var packed_scene = load(scene_paths[scene_paths_index])  
		var scene_instance = packed_scene.instance()
		main.add_child(scene_instance, true)

func unload_scene(node: Node):
	if !node:
		return
	if main.music_manager.current_track:
		main.music_manager.stop()
	main.emit_signal("stopped_raining")
	node.queue_free()

func handle_player():
	player_controller.hide()
	player_controller.set_global_position(Vector2(0, 0))
	player_controller.show()

func handle_player_ui():
	print(str(scene_node.name))
	if scene_node.name == "StartScreen" or scene_node.name == "StartScreen2":
		main.player_ui.hide()
	else:
		main.player_ui.show()
