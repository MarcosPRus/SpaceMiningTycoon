extends Polygon2D


var aux_polygon : PackedVector2Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aux_polygon.resize(36)
	
	var polygon_size := aux_polygon.size()
	print(polygon_size)
	var ang := 0
	
	for i in range(polygon_size):
		var x := cos(deg_to_rad(ang))
		var y := sin(deg_to_rad(ang))
		
		aux_polygon[i] = Global.mining_poly_radius * Vector2(x, y)
		ang += 360/polygon_size
		print(i)
	
	polygon = aux_polygon
	Global.mining_poly = self
