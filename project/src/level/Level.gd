extends Node2D

export (NodePath) var main_node_path = ".."
export (NodePath) var rain_particles_node_path = "RainParticles"
export (bool) var is_raining = false

onready var main: Node = get_node(main_node_path)

onready var music_manager: Node = main.get_node("MusicManager")
export var theme_song := 1
export var background_audio := 0

onready var level_manager: Node = main.get_node("LevelManager")

onready var rain_particles: Node = get_node(rain_particles_node_path)

func init_vars():
	level_manager.scene_node = $"."

func init_signals():
	main.connect("collided", self, "_on_collided")

func _ready():
	init_vars()
	init_signals()
	update_environment()
	update_theme_song(theme_song)
	print("level ready")

func update_environment():
	if is_raining:
		rain_particles.show()
		main.emit_signal("started_raining")
	else:
		rain_particles.hide()

func update_theme_song(song_index):
	music_manager.update_theme_song(song_index)

func update_bg_audio(index):
	music_manager.play_bg(index)

func _on_collided(collision):
	if collision.collider is TileMap:
		var tile_position = collision.collider.world_to_map(main.player_controller.position)
		tile_position -= collision.normal
		var tile = collision.collider.get_cellv(tile_position)
#		print(tile)
		#collision.collider.set_collision_layer_bit(0, false)
		#collision.collider.set_collision_mask_bit(0, false)

func _on_level_end_body_entered(body):
	if body.is_in_group("Player"):
		print("you beat the level")
		$LevelEndMenu/CanvasLayer.show()

func _on_next_level_trigger_body_entered(body):
	if body.is_in_group("Player"):
		main.level_manager.next_scene()

func _on_rain_trigger_body_entered(body):
	if body.is_in_group("Player"):
		is_raining = true
		update_environment()

func _on_FinalGoalArea2D_body_entered(body):
	if body.is_in_group("Player"):
		main.emit_signal("last_goal_reached")
