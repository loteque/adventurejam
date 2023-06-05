extends Node2D

export (NodePath) var main_node_path = ".."
export (bool) var is_raining = true

onready var main: Node = get_node(main_node_path)

func _ready():
	main.is_raining = is_raining
