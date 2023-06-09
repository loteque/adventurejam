extends Control

onready var main = get_node("..")

func _ready():
	main.level_manager.scene_node = $"."
	main.music_manager.update_theme_song(5)
	main.player_controller.reset_rust_level()
	main.player_controller.reset_rust_timer()
	main.player_controller.init_vars()
	main.player_ui.hide()

func _on_AnimationPlayer_animation_finished(anim_name):
	main.level_manager.next_scene()
