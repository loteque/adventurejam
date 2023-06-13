extends CanvasLayer

export (NodePath) var main_path = ".."

onready var main: Node = get_node(main_path)

func _on_Retry_button_down():
	main.level_manager.unload_scene(main.level_manager.scene_node)
	main.level_manager.load_scene_by_index(main.level_manager.current_scene_paths_index)
	main.level_manager.handle_player()
	main.player_controller.reset()
	$Rusted.hide()
	
func _on_Exit_button_down():
	main.level_manager.unload_scene(main.level_manager.scene_node)
	main.level_manager.load_scene_by_index(0)
	main.level_manager.handle_player()
	main.player_controller.reset()
	$Rusted.hide()
