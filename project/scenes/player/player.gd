extends CharacterBody2D

@export var move_speed = 200.0

#var velocity := Vector2.ZERO

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var feather: Node2D

var falling: bool = false

func _physics_process(delta):
	if Input.is_action_just_released("jump") and not falling:
		falling = true
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		falling = false
		jump()
	
	move_and_slide()


func get_gravity() -> float:
	if not falling:
		falling = velocity.y > 0.0
	if falling:
		return fall_gravity
	return jump_gravity


func jump():
	velocity.y = jump_velocity


func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0
	
	return horizontal
