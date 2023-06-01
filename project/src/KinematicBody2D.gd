extends KinematicBody2D

export var SPEED := 10
export var GRAVITY := 120
export var JUMP := 100
export var FRICTION := 0.1
var velocity = Vector2(0, GRAVITY)
var last_position = Vector2()

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION)
	
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			velocity.y = -JUMP
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _on_Timer_timeout():
	if is_on_floor():
		last_position = position 

func _on_Area2D_area_entered(area):
	if area.is_in_group("Respawn"):
		last_position.y -= 85
		position = last_position
