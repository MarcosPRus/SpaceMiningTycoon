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
	var tween = get_tree().create_tween()
	tween.tween_property(self, "width", 0, 0.1)
	$Emitterparticles.emitting = false
	$MiningParticles.emitting = false
	$MiningLight.enabled = false
	$EmitterLight.enabled = false
	#self.hide()
	

func start_laser() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "width", 5, 0.1)
	$Emitterparticles.emitting = true
	$MiningParticles.emitting = true
	$MiningLight.enabled = true
	$EmitterLight.enabled = true
	#self.show()
