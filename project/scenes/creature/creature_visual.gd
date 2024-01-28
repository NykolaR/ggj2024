extends Node2D



func set_velocity(velocity: float, grounded: bool) -> void:
	if velocity < 1:
		scale.x = -1
	if velocity > 1:
		scale.x = 1
	
	if grounded:
		pass
	else:
		pass
