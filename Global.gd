extends Node

var mining_point := Vector2.ZERO

var mining_poly : Polygon2D
var mining_poly_radius := 5.0 # Default value: 1 or 2
var laser_power := 20 # Default value: 10

var player : RigidBody2D

var offset_mining_poly : PackedVector2Array

var asteroids_resolution : int = 25 #Number of vertex in the asteroid polygons
var asteroids_min_size : int = 20
var asteroids_max_size : int = 250
var asteroid_spikiness : float = 0.125 #Ratio of difference between mountains and valleys

func _process(delta: float) -> void:
	pass
