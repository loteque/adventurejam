extends Node2D

export (NodePath) var main_node_path = ".."

onready var main: Node = get_node(main_node_path)
onready var level_manager: Node = main.get_node("LevelManager")

func init_vars():
	level_manager.scene_node = $"."

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		main.quit()
		
func _ready():
	main.music_manager.update_theme_song(0)
	init_vars()
	main.player_controller.reset_rust_level()
	main.player_controller.reset_rust_timer()
	main.player_controller.init_vars()
	
func _on_StartButton_button_up():
	main.level_manager.unload_scene(main.level_manager.scene_node)
	main.level_manager.load_scene_by_index(1)
	main.level_manager.handle_player()
	main.level_manager.handle_player_ui()
	$StartMenu.hide()

func _on_SettingsButton_button_up():
	main.settings_screen.show()

func _on_QuitButton_button_up():
	main.quit()
