extends CanvasLayer

export (NodePath) var main_node = ".."

onready var main: Node = get_node(main_node)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		hide()

func _on_Resume_button_up():
	main.antipause()
	hide()

func _on_Settings_button_up():
	main.settings_screen.show()

func _on_Quit_button_up():
	main.level_manager.unload_scene(main.level_manager.scene_node)
	main.level_manager.load_scene_by_index(0)
	main.player_controller.player_ui.reset_rust_meter()
	main.level_manager.handle_player_ui()
	hide()
	main.antipause()

func _on_PauseScreen_visibility_changed():
	if visible:
		$VBoxContainer/Resume.grab_focus()
