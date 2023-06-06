extends Node2D

export (float) var SPRING_STIFFNESS = 0.015
export (float) var SPRING_DAMPENING = 0.01
export (float) var SPREAD = 0.0002
export (int) var NUM_PASSES = 8

export (int) var SPRING_DISTANCE = 32
export (int) var NUM_SPRINGS = 8

export (int) var DEPTH = 1000

export var BORDER_THICKNESS = 1.1

onready var water_spring = preload("res://src/WaterSpring.tscn")
onready var water_polygon = $WaterPolygon
onready var water_border = $WaterBorder
onready var collider = $WaterBodyArea/CollisionShape2D
onready var water_body_area = $WaterBodyArea

var water_length = SPRING_DISTANCE * NUM_SPRINGS
var springs = []
var target_height = global_position.y
var bottom = target_height + DEPTH

func _ready():
	#water_border.width = BORDER_THICKNESS
	
	for n in range(NUM_SPRINGS):
		var x_position = SPRING_DISTANCE * n
		var new_spring = water_spring.instance()
		
		add_child(new_spring)
		springs.append(new_spring)
		new_spring.initialize(x_position, n)
		new_spring.set_collision_width(SPRING_DISTANCE)
		new_spring.connect("splash", self, "_on_splash")
		
	var total_length = SPRING_DISTANCE * (NUM_SPRINGS - 1)
	
	var rectangle = RectangleShape2D.new().duplicate()
	var rect_position = Vector2(total_length / 2, DEPTH / 2)
	var rect_extents = Vector2(total_length / 2, DEPTH / 2)
	
	water_body_area.position = rect_position
	rectangle.set_extents(rect_extents)
	collider.set_shape(rectangle)

func _physics_process(delta):
	var left_deltas = []
	var right_deltas = []
	
	for spring in springs:
		spring.update_water(SPRING_STIFFNESS, SPRING_DAMPENING)
	
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
		
	for p in range(NUM_PASSES):
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = SPREAD * (springs[i].height - springs[i - 1].height)
				springs[i - 1].velocity += left_deltas[i]
		
			if i < springs.size() - 1:
				right_deltas[i] = SPREAD * (springs[i].height - springs[i + 1].height)
				springs[i + 1].velocity += right_deltas[i]
		
		draw_border()
		draw_water_body()

func draw_water_body():
	var curve = water_border.curve
	var points = Array(curve.get_baked_points())
	var water_polygon_points = points
	
	var first_index = 0
	var last_index = water_polygon_points.size() - 1
	
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	
	
	water_polygon.set_polygon(water_polygon_points)

func draw_border():
	var curve = Curve2D.new().duplicate()
	var surface_points = []
	
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
		
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
		
	water_border.curve = curve
	water_border.smooth(true)
	water_border.update()

func _on_splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed

func _on_WaterBodyArea_area_entered(area):
	print("WaterBodyArea: Entered Water")

func _on_WaterBodyArea_area_exited(area):
	print("WaterBodyArea: Exited Water")
