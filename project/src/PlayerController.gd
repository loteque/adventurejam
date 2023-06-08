extends KinematicBody2D

export (NodePath) var main_node_path := ".."
export (NodePath) var jump_timer_node_path := "JumpTimer"
export (NodePath) var rust_timer_node_path := "RustTimer"
export (NodePath) var player_ui_node_path := "PlayerUI"
export (NodePath) var player_area_node_path := "Area2D"

onready var main: Node = get_node(main_node_path)
onready var jump_timer: Node = get_node(jump_timer_node_path)
onready var rust_timer: Node = get_node(rust_timer_node_path)
onready var player_ui: Node = get_node(player_ui_node_path)
onready var player_area: Node = get_node(player_area_node_path)

onready var rust_meter_bar = player_ui.get_node("RustMeterContainer/RustMeter/RustMeterBar")

export var FRICTION := 0.1
export var COYOTE_TIME := 0.1
export var JUMP := 38
export var JUMP_DISTANCE := 100
export var TIME_TO_JUMP_PEAK := 0.2
export var INVENTORY_MAX := 3

var GRAVITY : float
var JUMP_SPEED : float
var SPEED : float

var velocity: Vector2
var last_position: Vector2
var can_jump: bool
var rust_level: int = 0
var is_raining: bool = false

var antirust_inventory: Array = [0, 0]

func init_vars():
	jump_timer.wait_time = COYOTE_TIME
	GRAVITY = (2*JUMP)/pow(TIME_TO_JUMP_PEAK, 2)
	JUMP_SPEED = GRAVITY * TIME_TO_JUMP_PEAK
	SPEED = JUMP_DISTANCE / (2 * TIME_TO_JUMP_PEAK)

func init_signals():
	main.connect("started_raining", self, "_on_started_raining")
	main.connect("stopped_raining", self, "_on_stopped_raining")
	
func _ready():
	init_vars()
	init_signals()

func _physics_process(delta):
	
	velocity.y += GRAVITY * delta
	
	if is_on_floor() && !Input.is_action_pressed("jump"):
		can_jump = true
	elif can_jump == true && jump_timer.is_stopped():
		jump_timer.start()
	
	if Input.is_action_just_pressed("ui_down"):
		print("ui_down")
		print("in_pickup_area(): " + str(in_pickup_area()))
		print("get_pickup_node(): " + str(get_pickup_node()))
		print("--------------------")
		
		if can_pick_up_item():
			pick_up_item()
		elif can_use_item():
			use_item()
	
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = 0
	
	if Input.is_action_pressed("jump") && can_jump:
		velocity.y = -JUMP_SPEED
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = lerp(velocity.x, SPEED, FRICTION)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = lerp(velocity.x, -SPEED, FRICTION)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(area: Area2D = null):
	var antirust_counter = player_ui.get_node("OilMeter/Counter")
	var item_strength: int
	var pickup_node: Node
	
	if area:
		item_strength = area.get_parent().strength
		pickup_node = area.get_parent()
	else:
		item_strength = get_pickup_node().strength
		pickup_node = get_pickup_node()
	
	antirust_inventory[0] = antirust_inventory[0] + 1
	antirust_inventory[1] = item_strength
	antirust_counter.text = str(antirust_inventory[0])
	pickup_node.queue_free()
	print("picked up antirust: " + str(antirust_inventory))

func use_item():
	rust_meter_bar = player_ui.get_node("RustMeterContainer/RustMeter/RustMeterBar")
	var antirust_counter = player_ui.get_node("OilMeter/Counter")
	antirust_inventory[0] -= 1
	rust_level -= antirust_inventory[1]
	rust_meter_bar.rect_size.x = float(rust_level)
	antirust_counter.text = str(antirust_inventory[0])
	init_vars()
	print("used antirust")

# PlayerController Helper Functions
func can_use_item() -> bool:
	if !in_pickup_area() && antirust_inventory[0] > 0:
		return true
	return false

func can_pick_up_item() -> bool:
	if in_pickup_area() && antirust_inventory[0] < INVENTORY_MAX:
		return true
	return false

func in_pickup_area() -> bool:
	var areas = player_area.get_overlapping_areas()
	for area in areas:
		if area.get_parent().is_in_group("Pickup"): 
			return true
	return false

func get_pickup_node() -> Node:
	var pickup_node = null
	var areas = player_area.get_overlapping_areas()
	for area in areas:
		if area.get_parent().is_in_group("Pickup"): 
			pickup_node = area.get_parent()
	return pickup_node

func reset_rust_timer(stop: bool = true):
	rust_timer.wait_time = rust_timer.default_wait_time
	if stop:
		rust_timer.stop()
	
# Signal Callbacks
func _on_started_raining():
	rust_timer.start()
	is_raining = true
	print("Oh no... It is raining, I'll rust!")

func _on_stopped_raining():
	reset_rust_timer()
	rust_timer.stop()
	is_raining = false
	print("the rain stopped...")

func _on_Timer_timeout():
	if is_on_floor():
		last_position = position
 
func _on_JumpTimer_timeout():
	can_jump = false

func _on_Area2D_area_entered(area):
	if area.is_in_group("Respawn"):
		last_position.y -= 85
		position = last_position
		rust_level = clamp(rust_level + 10, 0, 100)
		rust_meter_bar.rect_size.x = float(rust_level)
		init_vars()
	if area.get_parent().is_in_group("Water"):
		if is_raining:
			rust_timer.wait_time = rust_timer.wait_time - (rust_timer.wait_time / 4)
		else:
			rust_timer.start()
	if area.is_in_group("DryArea"):
		rust_timer.stop()
		print("entered dry area")
	if area.get_parent().is_in_group("Pickup") && antirust_inventory[0] < INVENTORY_MAX:
		if area.get_parent().collide_to_pick_up:
			pick_up_item(area)
		print("entered pickup item area")
	
	print("_on_area2D_area_entered: " + str(area.get_parent()))

func _on_Area2D_area_exited(area):
	if area.get_parent().is_in_group("Water"):
		if is_raining:
			reset_rust_timer(false)
		else:
			rust_timer.stop()
	if area.is_in_group("DryArea") and is_raining:
		rust_timer.start()
	print(str(rust_timer.wait_time))

func _on_RustTimer_timeout():
	rust_level = clamp(rust_level + 1, 0, 100)
	rust_meter_bar.rect_size.x = float(rust_level)
	JUMP_DISTANCE = 100 - rust_level
	if rust_level == 90:
		JUMP = 5
	if rust_level == 100:
		player_ui.get_node("Rusted").show()
	init_vars()
#	print("RUST METER: " + str(rust_level))
#	print("JUMP_DISTANCE: " + str(JUMP_DISTANCE))
