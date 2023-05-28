extends KinematicBody2D

export var SPEED := 15
export var GRAVITY := 10
export var JUMP := 10
var velocity = Vector2(0, GRAVITY)

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			velocity.y = -JUMP
	velocity = move_and_slide(velocity, Vector2.UP)
