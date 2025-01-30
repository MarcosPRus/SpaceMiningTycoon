extends RigidBody2D

var original_asteroid_flag := true

var asteroid_scene = preload("res://Entities/Asteroids/asteroid.tscn")

@onready var visual_poly := $Polygon2D
@onready var collision_poly := $CollisionPolygon2D
@onready var occluder_poly : OccluderPolygon2D = $LightOccluder2D.occluder

var asteroid_polygon : PackedVector2Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	asteroid_polygon.resize(Global.asteroids_resolution)

	# Original asteroid flag is set to false when a new asteroid is created from a division of
	# another asteroid, so that it doesn't initialize a random shape again 
	if original_asteroid_flag:
		generate_random_asteroid()
	
	# Set the mass based on the polygon area, destroy small polygons
	calculate_polygon_area()
	update_border_line()


func mine() -> void:
	var offset_mining_poly : PackedVector2Array = Transform2D(Global.player.rotation, Global.mining_point) * Global.mining_poly.polygon
	var offset_asteroid_poly : PackedVector2Array = Transform2D(self.rotation, self.global_position) * visual_poly.polygon
	var new_asteroid_poly : Array[PackedVector2Array] = Geometry2D.clip_polygons(offset_asteroid_poly, offset_mining_poly)
	
	if new_asteroid_poly.size() == 0:
		# Asteroid completely mined, delete it
		queue_free()
	elif new_asteroid_poly.size() == 1:
		# The asteroid is still in one piece
		update_asteroid_polygons(new_asteroid_poly)
		# Adjust the mass of the asteroid and destroy it if its too small
		calculate_polygon_area()
		update_border_line()
		
	elif new_asteroid_poly.size() >= 2:
		# If the asteroid is cut in half, instance a new asteroid
		update_asteroid_polygons(new_asteroid_poly)
		# Adjust the mass of the asteroid and destroy it if its too small
		calculate_polygon_area()
		update_border_line()
		
		var asteroid_instance = asteroid_scene.instantiate()
		new_asteroid_poly[1] = Transform2D(0, -1 * self.global_position) * new_asteroid_poly[1]
		new_asteroid_poly[1] = Transform2D(-self.rotation, Vector2.ZERO) * new_asteroid_poly[1]
		asteroid_instance.get_node("Polygon2D").polygon = new_asteroid_poly[1]
		asteroid_instance.get_node("CollisionPolygon2D").set_deferred("polygon", new_asteroid_poly[1])
		asteroid_instance.get_node("LightOccluder2D").occluder.polygon = new_asteroid_poly[1]
		asteroid_instance.global_position = self.global_position
		asteroid_instance.rotation = self.rotation
		asteroid_instance.original_asteroid_flag = false
		get_parent().add_child(asteroid_instance)


func update_asteroid_polygons(new_asteroid_poly : Array[PackedVector2Array]) -> void:
	new_asteroid_poly[0] = Transform2D(0, -1 * self.global_position) * new_asteroid_poly[0]
	new_asteroid_poly[0] = Transform2D(-self.rotation, Vector2.ZERO) * new_asteroid_poly[0]
	visual_poly.polygon = new_asteroid_poly[0]
	collision_poly.set_deferred("polygon", new_asteroid_poly[0])
	occluder_poly.set_deferred("polygon", new_asteroid_poly[0])


func calculate_polygon_area() -> void:
	var area := 0.0
	var polygon_vertex : PackedVector2Array = visual_poly.polygon
	polygon_vertex.append(visual_poly.polygon[0])
	
	for i in range(polygon_vertex.size()-1):
		area += polygon_vertex[i].x * polygon_vertex[i+1].y
		area -= polygon_vertex[i].y * polygon_vertex[i+1].x
	
	if area < 150:
		queue_free()
	else:
		self.mass = area/1000


func update_border_line() -> void:
	$Polygon2D/Line2D.points = $Polygon2D/Line2D.get_parent().polygon
	$Polygon2D/Line2D.add_point($Polygon2D/Line2D.get_parent().polygon[0])


func generate_random_asteroid() -> void:
	var ang := 0.0
	var asteroid_size = randf_range(Global.asteroids_min_size, Global.asteroids_max_size)
	
	#for i in visual_poly.polygon.size():
	for i in range(Global.asteroids_resolution):
		var length = randf_range((1-Global.asteroid_spikiness)*asteroid_size, (1+Global.asteroid_spikiness)*asteroid_size)
		var vertex = Vector2(length * cos(deg_to_rad(ang)), length * sin(deg_to_rad(ang)))
		asteroid_polygon[i] = vertex
		
		ang += 360/Global.asteroids_resolution
	
	visual_poly.polygon = asteroid_polygon
	collision_poly.polygon = asteroid_polygon
	occluder_poly.polygon = asteroid_polygon
