extends CanvasLayer

export (NodePath) var main_node = ".."

onready var main: Node = get_node(main_node)

func _on_CheckButton_toggled(button_pressed):
	print(str(button_pressed))
	if button_pressed:
		main.touch_ui.show()
	else:
		main.touch_ui.hide()

func _on_Button_button_up():
	hide()
