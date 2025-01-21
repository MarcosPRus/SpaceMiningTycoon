extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass








	#$AsteroidTest/CollisionPolygon2D.polygon = $AsteroidTest/BluePolygon.polygon
	#
	#if Input.is_action_pressed("Enter"):
		#var offset_poly : PackedVector2Array = Transform2D(0, Global.mining_point) * $PinkPolygon.polygon
		#
		#var new_blue_polygon_points := Geometry2D.clip_polygons($AsteroidTest/BluePolygon.polygon, offset_poly)
		#
		#if new_blue_polygon_points.size() != 0:
			#$AsteroidTest/BluePolygon.polygon = new_blue_polygon_points[0]
