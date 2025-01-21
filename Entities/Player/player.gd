extends RigidBody2D

@export var thrust_power : float = 10000
@export var torque_power : float = 100000

@onready var raycast := $RayCast2D
@onready var particles := $GPUParticles2D
@onready var laser_line := $Line2D

var can_mine := true


func _ready() -> void:
	Global.player = self
	laser_line.width = Global.mining_poly_radius


func _physics_process(delta: float) -> void:
#region Ship Movement
	# Ship Forward and Backwards Thrust, rotated to match the player direction
	var direction := Vector2(0, Input.get_axis("move_forward", "move_backwards")).rotated(rotation)
	# Ship rotation, via Torque
	var ang_direction := Input.get_axis("turn_left", "turn_right")
	# Apply directional Force
	apply_central_force(delta * thrust_power * direction)
	# Apply the torque
	apply_torque(delta * torque_power * ang_direction)
#endregion
	
#region Mining Laser
	raycast.target_position = 100*(get_global_mouse_position() - position).rotated(-rotation)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		Global.mining_point = raycast.get_collision_point()
		particles.global_position = raycast.get_collision_point()
		#print(raycast.get_collision_point())
		#print(raycast.get_collider())
		var body : RigidBody2D = raycast.get_collider()
		
		if Input.is_action_pressed("left_click"):
			particles.emitting = true
			laser_line.points[1] = (raycast.get_collision_point() - global_position).rotated(-rotation)
			laser_line.show()
			if can_mine:
				can_mine = false
				body.mine()
				$MiningCooldownTimer.start()
		else:
			particles.emitting = false
			laser_line.hide()
	else:
		particles.emitting = false
		laser_line.hide()
#endregion


func _on_mining_cooldown_timer_timeout() -> void:
	can_mine = true
	$MiningCooldownTimer.wait_time = randf_range(1/Global.laser_power, 2/Global.laser_power)
