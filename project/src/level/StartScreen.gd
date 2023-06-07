extends Node2D

export (NodePath) var main_node_path = ".."

onready var main: Node = get_node(main_node_path)

func _on_StartButton_button_up():
	main.level_manager.next_scene()
	$StartMenu.hide()
	
func _on_SettingsButton_button_up():
	main.settings_screen.show()

func _on_QuitButton_button_up():
	main.quit()
