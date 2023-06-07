extends Node2D

export (NodePath) var level_manager_node_path = "LevelManager"

onready var level_manager: Node = get_node(level_manager_node_path)

var is_raining: bool
var level_node: Node

signal started_raining
signal stopped_raining

func _ready():
	level_node = level_manager.scene_node
	level_manager.next_scene()
