extends CanvasLayer

export (NodePath) var player_label_node_path = "TabContainer/Player/Label"
export (NodePath) var player_node_path = "../PlayerController"

export (NodePath) var friction_entry_node_path = "TabContainer/Player/Entries/Friction/FrictionLineEdit"
export (NodePath) var jump_entry_node_path = "TabContainer/Player/Entries/Jump/JumpLineEdit"
export (NodePath) var coyote_time_entry_node_path = "TabContainer/Player/Entries/CoyoteTime/CoyoteTimeLineEdit"
export (NodePath) var jump_distance_entry_node_path = "TabContainer/Player/Entries/JumpDistance/JumpDistanceLineEdit"
export (NodePath) var time_to_jump_peak_entry_node_path = "TabContainer/Player/Entries/TimeToJumpPeak/TimeToJumpPeakLineEdit"

onready var player_label_node := get_node(player_label_node_path)
onready var player_node := get_node(player_node_path)

onready var friction_entry_node := get_node(friction_entry_node_path)
onready var jump_entry_node := get_node(jump_entry_node_path)
onready var coyote_time_entry_node := get_node(coyote_time_entry_node_path)
onready var jump_distance_entry_node := get_node(jump_distance_entry_node_path)
onready var time_to_jump_peak_entry_node := get_node(time_to_jump_peak_entry_node_path)


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
	friction_entry_node.text = str(player_node.FRICTION)
	jump_entry_node.text = str(player_node.JUMP)
	coyote_time_entry_node.text = str(player_node.COYOTE_TIME)
	jump_distance_entry_node.text = str(player_node.JUMP_DISTANCE)
	time_to_jump_peak_entry_node.text = str(player_node.TIME_TO_JUMP_PEAK)

func _input(event):
	var debug_ui_should_open = InputMap.event_is_action(event, "ui_debug") and event.is_pressed() and !visible
	var debug_ui_should_close = InputMap.event_is_action(event, "ui_debug") and event.is_pressed() and visible
	
	if debug_ui_should_open:
		show()
		friction_entry_node.grab_focus()
	
	elif debug_ui_should_close:
		player_node.init_vars()
		hide()

func _on_FrictionLineEdit_gui_input(event):
	var entry_container = friction_entry_node.get_parent()
	var entry_data = friction_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.FRICTION = float(entry_data)
		find_next_entry(entry_container).grab_focus()

func _on_JumpLineEdit_gui_input(event):
	var entry_container = jump_entry_node.get_parent()
	var entry_data = jump_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.JUMP = int(entry_data)
		find_next_entry(entry_container).grab_focus()

func _on_CoyoteTimeLineEdit_gui_input(event):
	var entry_container = coyote_time_entry_node.get_parent()
	var entry_data = coyote_time_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.COYOTE_TIME = float(entry_data)
		find_next_entry(entry_container).grab_focus()

func _on_JumpDistanceLineEdit_gui_input(event):
	var entry_container = jump_distance_entry_node.get_parent()
	var entry_data = jump_distance_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.JUMP_DISTANCE = int(entry_data)
		find_next_entry(entry_container).grab_focus()

func _on_TimeToJumpPeakLineEdit_gui_input(event):
	var entry_container = time_to_jump_peak_entry_node.get_parent()
	var entry_data = time_to_jump_peak_entry_node.text
	if InputMap.event_is_action(event, "ui_accept") and event.is_pressed():
		player_node.TIME_TO_JUMP_PEAK = float(entry_data)
		find_next_entry(entry_container).grab_focus()
