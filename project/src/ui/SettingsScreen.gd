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

func _on_HSlider_value_changed(value):
	var player_camera = main.player_controller.get_node("Camera2D")
	player_camera.zoom = Vector2(value / 100, value / 100)


func _on_CheckBox_pressed():
	if !main.player_controller.rust_when_falling:
		main.player_controller.rust_when_falling = true
	else: 
		main.player_controller.rust_when_falling = false
