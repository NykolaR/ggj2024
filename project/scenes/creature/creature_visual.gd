extends Node2D

@onready var move_legs: AnimatedSprite2D = $Node2D/Feet as AnimatedSprite2D
@onready var air_legs: AnimatedSprite2D = $Node2D/Body/Feet2 as AnimatedSprite2D

func set_velocity(velocity: Vector2, grounded: bool) -> void:
	if velocity.x < 1:
		scale.x = -1
	if velocity.x > 1:
		scale.x = 1
	
	if grounded:
		if velocity.length_squared() < 1.0:
			move_legs.hide()
			air_legs.frame = 0
			air_legs.show()
		if velocity.x < -1:
			move_legs.show()
			air_legs.hide()
			scale.x = -1
		if velocity.x > 1:
			move_legs.show()
			air_legs.hide()
			scale.x = 1
	else:
		move_legs.hide()
		air_legs.show()
		if velocity.y > 0:
			air_legs.frame = 1
		else:
			air_legs.frame = 2
