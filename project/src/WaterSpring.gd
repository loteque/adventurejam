extends Node2D

var velocity = 0
var force = 0
var height = 0
var target_height = position.y + 80
var index = 0
var motion_factor = 0.02
var collided_with = null

signal splash

onready var collision = $Area2D/CollisionShape2D

func update_water(spring_constant, dampening):
	height = position.y
	var spring_extension = height - target_height
	var loss = -dampening * velocity
	
	force = -spring_constant * spring_extension + loss
	velocity += force
	
	position.y += velocity

func initialize(x_position, id):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = id

func set_collision_width(value):
	var extents = collision.shape.get_extents()
	var new_extents = Vector2(value / 2, extents.y)
	collision.shape.set_extents(new_extents)

func _on_Area2D_body_entered(body):
	if body == collided_with:
		return
	
	collided_with = body
	
	if body.is_in_group("Player"):
		var speed = body.velocity.y * motion_factor
		emit_signal("splash", index, speed)
