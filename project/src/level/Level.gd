extends Node2D

export (NodePath) var main_node_path = ".."
export (NodePath) var rain_particles_node_path = "RainParticles"
export (bool) var is_raining = true

onready var main: Node = get_node(main_node_path)

onready var music_manager: Node = main.get_node("MusicManager")
export var theme_song := 0

onready var level_manager: Node = main.get_node("LevelManager")

onready var rain_particles: Node = get_node(rain_particles_node_path)

func init_vars():
	level_manager.scene_node = $"."

func _ready():
	init_vars()
	update_environment()
	update_theme_song(theme_song)
	

func update_environment():
	if is_raining:
		rain_particles.show()
		main.emit_signal("started_raining")
	else:
		rain_particles.hide()

func update_theme_song(song_index):
	music_manager.update_theme_song(song_index)


func _on_level_end_body_entered(body):
	if body.is_in_group("Player"):
		print("you beat the level")
		$LevelEndMenu/CanvasLayer.show()

func _on_Button_button_up():
	main.level_manager.next_scene()
