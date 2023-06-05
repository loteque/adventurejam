extends CanvasLayer

export (NodePath) var player_label_node_path = "TabContainer/Player/Label"
export (NodePath) var player_node_path = "../TestLevel/KinematicBody2D"
export (NodePath) var speed_entry_node_path = "TabContainer/Player/Entries/Speed/LineEdit"
export (NodePath) var gravity_entry_node_path = "TabContainer/Player/Entries/Gravity/GravityLineEdit"
export (NodePath) var jump_entry_node_path = "TabContainer/Player/Entries/Jump/JumpLineEdit"
export (NodePath) var friction_entry_node_path = "TabContainer/Player/Entries/Friction/FrictionLineEdit"

onready var player_label_node := get_node(player_label_node_path)
onready var player_node := get_node(player_node_path)
onready var speed_entry_node := get_node(speed_entry_node_path)
onready var gravity_entry_node := get_node(gravity_entry_node_path)
onready var jump_entry_node := get_node(jump_entry_node_path)
onready var friction_entry_node := get_node(friction_entry_node_path)

var current_focus = null

#####
# helper functions (these could be in a global ui_helpers.gd)
func find_next_entry(target_node):
	# Where node structure is:
	#  catagory_container
	#  |
	#  |_entry_container
	#  |  |
	#  |  |_label_node
	#  |  |
	#  |  |_line_edit_node
	#  |
	#  |_entry_container. . .
	#  .
	#  .
	#  .
	var next_entry = null
	var target_index = target_node.get_index()
	var parent = target_node.get_parent()
	var child_array_end_index = parent.get_children().size() - 1
	var first_entry_container = parent.get_child(0)
	var first_entry = first_entry_container.get_child(1)
	
	if !target_node: 
		return null
	
	if target_index + 1 <= child_array_end_index:
		next_entry = parent.get_child(target_index + 1).get_child(1)
	else:
		next_entry = first_entry
	
	return next_entry
	
# end (helper functions)
#####

func _ready():
	player_label_node.text = str(player_node.name)
	speed_entry_node.text = str(player_node.SPEED)
	gravity_entry_node.text = str(player_node.GRAVITY)
	jump_entry_node.text = str(player_node.JUMP)
	friction_entry_node.text = str(player_node.FRICTION)

func _input(event):
	var debug_ui_should_open = InputMap.event_is_action(event, "ui_debug") and event.is_pressed() and !visible
	var debug_ui_should_close = InputMap.event_is_action(event, "ui_debug") and event.is_pressed() and visible
	
	if debug_ui_should_open:
		show()
		speed_entry_node.grab_focus()
	elif debug_ui_should_close:
		hide()

func _on_SpeedLineEdit_gui_input(event):
	var entry_container = speed_entry_node.get_parent()
	var entry_data = speed_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.SPEED = int(entry_data)
		find_next_entry(entry_container).grab_focus()

func _on_GravityLineEdit_gui_input(event):
	var entry_container = gravity_entry_node.get_parent()
	var entry_data = gravity_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.GRAVITY = int(entry_data)
		find_next_entry(entry_container).grab_focus()

func _on_JumpLineEdit_gui_input(event):
	var entry_container = jump_entry_node.get_parent()
	var entry_data = jump_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.JUMP = int(entry_data)
		find_next_entry(entry_container).grab_focus()

func _on_FrictionLineEdit_gui_input(event):
	var entry_container = friction_entry_node.get_parent()
	var entry_data = friction_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.FRICTION = float(entry_data)
		find_next_entry(entry_container).grab_focus()
