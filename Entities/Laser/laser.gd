extends Line2D

func set_objective_point() -> void:
	var local_mining_point = to_local(Global.mining_point)
	var local_emitter_point = 32 * local_mining_point.normalized()
	
	points[0] = local_emitter_point
	points[1] = local_mining_point
	
	$EmitterLight.position = local_emitter_point
	$MiningLight.position = local_mining_point
	
	$Emitterparticles.position = local_emitter_point
	$MiningParticles.position = local_mining_point

func stop_laser() -> void:
	$Emitterparticles.emitting = false
	$MiningParticles.emitting = false
	self.hide()
	

func start_laser() -> void:
	$Emitterparticles.emitting = true
	$MiningParticles.emitting = true
	self.show()
