extends Node

var mining_point := Vector2.ZERO

var mining_poly : Polygon2D
var mining_poly_radius := 2.0	# Default value: 1 or 2
var laser_power := 10			# Default value: 10

var player : RigidBody2D

var offset_mining_poly : PackedVector2Array

func _process(delta: float) -> void:
	pass
