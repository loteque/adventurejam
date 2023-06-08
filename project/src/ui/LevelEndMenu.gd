extends Control

export (NodePath) var main_node = "../.."

onready var main = get_node(main_node)

func _on_Button_button_up():
	main.level_manager.next_scene()
