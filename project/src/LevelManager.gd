extends Node

export (NodePath) var main_node_path = ".."
export (NodePath) var player_controller_node_path = "../PlayerController"

onready var main: Node = get_node(main_node_path)
onready var player_controller: = get_node(player_controller_node_path)

onready var scene_node: Node

var scene_paths = ["res://src/Levels/JunkYard.tscn", 
				   "res://src/Levels/Forest.tscn", 
				   "res://src/Levels/City.tscn"]

var current_scene_paths_index: int = scene_paths.size()

func next_scene():
	if main.get_node("Level"):
		scene_node = main.get_node("Level")
	else:
		scene_node = main.get_node("Level2")
		
	if current_scene_paths_index < scene_paths.size() - 1:
		unload_scene(scene_node)
		load_scene_by_index(current_scene_paths_index + 1)
		current_scene_paths_index += 1
		handle_player()
	else:
		unload_scene(scene_node)
		load_scene_by_index(0)
		current_scene_paths_index = 0
		handle_player()
		
func load_scene_by_index(scene_paths_index):
		var packed_scene = load(scene_paths[scene_paths_index])  
		var scene_instance = packed_scene.instance()
		main.add_child(scene_instance, true)

func unload_scene(node: Node):
	if !node:
		return
	node.queue_free()

func handle_player():
		player_controller.hide()
		player_controller.set_global_position(Vector2(0, 0))
		player_controller.show()
