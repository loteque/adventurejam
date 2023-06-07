extends Node2D

export (NodePath) var main_node_path = ".."
export (NodePath) var rain_particles_node_path = "RainParticles"
export (bool) var is_raining = true

onready var main: Node = get_node(main_node_path)
onready var rain_particles = get_node(rain_particles_node_path)

func _ready():
	init_vars()
	if is_raining:
		rain_particles.show()
	else:
		rain_particles.hide()

func init_vars():
	main.is_raining = is_raining
