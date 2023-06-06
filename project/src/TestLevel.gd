extends Node2D

export (NodePath) var main_node_path = ".."
export (bool) var is_raining = true

onready var main: Node = get_node(main_node_path)

func _ready():
	init_vars()

func init_vars():
	main.is_raining = is_raining
