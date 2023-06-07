extends CanvasLayer



func _on_Retry_button_down():
	get_tree().reload_current_scene()

func _on_Exit_button_down():
	get_tree().quit()
