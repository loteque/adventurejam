extends KinematicBody2D

export (NodePath) var jump_timer_node_path := "JumpTimer"

onready var jump_timer: Node = get_node(jump_timer_node_path)

export var SPEED := 10
export var GRAVITY := 120
export var JUMP := 100
export var FRICTION := 0.1
export var COYOTE_TIME := 0.1

var velocity: Vector2
var last_position: Vector2
var can_jump: bool

func _ready():
	jump_timer.wait_time = COYOTE_TIME

func _physics_process(delta):
	
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		can_jump = true
	elif can_jump == true && jump_timer.is_stopped():
		jump_timer.start()
	
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = 0
	
	if Input.is_action_pressed("jump") && can_jump:
		velocity.y = -JUMP
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
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
