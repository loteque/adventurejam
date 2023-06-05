extends KinematicBody2D

export (NodePath) var jump_timer_node_path := "JumpTimer"

onready var jump_timer: Node = get_node(jump_timer_node_path)

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

func init_vars():
	jump_timer.wait_time = COYOTE_TIME
	GRAVITY = (2*JUMP)/pow(TIME_TO_JUMP_PEAK, 2)
	JUMP_SPEED = GRAVITY * TIME_TO_JUMP_PEAK
	SPEED = JUMP_DISTANCE / (2 * TIME_TO_JUMP_PEAK)
	
func _ready():
	init_vars()

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

func _on_Area2D_area_entered(area):
	if area.is_in_group("Respawn"):
		last_position.y -= 85
		position = last_position

func _on_JumpTimer_timeout():
	print("timeout")
	can_jump = false
