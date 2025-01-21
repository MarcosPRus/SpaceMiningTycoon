extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mining_poly = self
	
	var polygon_size := self.polygon.size()
	var ang := 180
	
	for i in polygon_size:
		#polygon[i] = Global.mining_poly_radius * Vector2(cos(deg_to_rad(ang)), 0.5+sin(deg_to_rad(ang))) 
		polygon[i] = Global.mining_poly_radius * polygon[i]
		ang += 180/(polygon_size-1)
