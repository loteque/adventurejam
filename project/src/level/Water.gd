extends Node2D

#####
## Add as a child an Area2D
## As a child of the Area2D add: 
## As child 0: a CollisionShape2d
## As child 1: a polygon2D
#####

func _ready():
	draw_water_polygon()
	pass
	
func _physics_process(delta):
#	draw_water_polygon()
	pass
	
func draw_water_polygon():
	var children = get_children()
	for child in children:
		var points: PoolVector2Array
		var rect: Vector2
		var collision_shape = child.get_child(0)
		var water_polygon = child.get_child(1)
		rect.x = collision_shape.shape.extents.x
		rect.y = collision_shape.shape.extents.y
		points = PoolVector2Array([Vector2(-rect.x, -rect.y), 
							   Vector2(rect.x, -rect.y),
							   Vector2(rect.x, rect.y),
							   Vector2(-rect.x, 0 + rect.y)
							  ])
	
		water_polygon.polygon = points
		water_polygon.position = collision_shape.position
