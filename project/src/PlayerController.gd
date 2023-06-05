extends KinematicBody2D

export (NodePath) var main_node_path := ".."
export (NodePath) var jump_timer_node_path := "JumpTimer"
export (NodePath) var rust_timer_node_path := "RustTimer"
export (NodePath) var player_ui_node_path := "PlayerUI"

onready var main: Node = get_node(main_node_path)
onready var jump_timer: Node = get_node(jump_timer_node_path)
onready var rust_timer: Node = get_node(rust_timer_node_path)
onready var player_ui: Node = get_node(player_ui_node_path)

export var FRICTION := 0.1
export var COYOTE_TIME := 0.1
export var JUMP := 32
export var JUMP_DISTANCE := 100
export var TIME_TO_JUMP_PEAK := 0.2

var GRAVITY : float
var JUMP_SPEED : float
var SPEED : float

var velocity: Vector2
var last_position: Vector2
var can_jump: bool
var rust_level: int = 0

func init_vars():
	jump_timer.wait_time = COYOTE_TIME
	GRAVITY = (2*JUMP)/pow(TIME_TO_JUMP_PEAK, 2)
	JUMP_SPEED = GRAVITY * TIME_TO_JUMP_PEAK
	SPEED = JUMP_DISTANCE / (2 * TIME_TO_JUMP_PEAK)
	
func _ready():
	init_vars()
	if main.is_raining == true:
		rust_timer.start()

func _physics_process(delta):
	
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		can_jump = true
	elif can_jump == true && jump_timer.is_stopped():
		jump_timer.start()
	
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

func _on_Timer_timeout():
	if is_on_floor():
		last_position = position
		 
func _on_JumpTimer_timeout():
	can_jump = false

func _on_Area2D_area_entered(area):
	if area.is_in_group("Respawn"):
		last_position.y -= 85
		position = last_position
	if area.is_in_group("Water"):
		rust_timer.start()
	if area.is_in_group("DryArea"):
		rust_timer.stop()

func _on_Area2D_area_exited(area):
	if area.is_in_group("Water"):
		rust_timer.stop()
	if area.is_in_group("DryArea"):
		rust_timer.start()

func _on_RustTimer_timeout():
	var rust_meter_bar = player_ui.get_node("RustMeterContainer/RustMeter/RustMeterBar")
	rust_level = clamp(rust_level + 1, 0, 100)
	rust_meter_bar.rect_size.x = float(rust_level)
	JUMP_DISTANCE = 100 - rust_level
	if rust_level == 90:
		JUMP = 5
	if rust_level == 100:
		yield(get_tree().create_timer(5), "timeout")
		get_tree().reload_current_scene()
	init_vars()
	print("RUST METER: " + str(rust_level))
	print("JUMP_DISTANCE: " + str(JUMP_DISTANCE))
