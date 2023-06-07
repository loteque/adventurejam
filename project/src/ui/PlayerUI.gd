extends CanvasLayer

onready var rust_meter_bar: Node = get_node("RustMeterContainer/RustMeter/RustMeterBar")

func _on_Retry_button_down():
	get_tree().reload_current_scene()

func _on_Exit_button_down():
	get_tree().quit()

func reset_rust_meter():
	rust_meter_bar.rect_size.x = 0
