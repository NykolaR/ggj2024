extends CharacterBody2D

const MAX_STAMINA: float = 3.99
const STAMINA_RATE: float = 0.2

@export var move_speed: float = 200.0

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@export var friction: float = 50.0

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var feather: Node2D
@export var feather_impact: float = 1.0

var stamina: float = MAX_STAMINA
var falling: bool = false

var keyboard_input: bool = true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("jump") and not falling:
		falling = true
	velocity.y += get_gravity() * delta
	velocity.x += get_input_velocity() * move_speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		falling = false
		jump()
	
	feather_func_one()
	move_and_slide()
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, friction)
		var ostam: float = stamina
		stamina = MAX_STAMINA
		if floor(ostam) < floor(stamina):
			pass # stamina fill v effect
	velocity.x = clampf(velocity.x, -move_speed, move_speed)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		keyboard_input = true
	if event is InputEventJoypadButton:
		keyboard_input = false


func feather_func_one() -> void:
	var r1: Vector2 = feather.global_transform.x
	if keyboard_input:
		feather.look_at(get_global_mouse_position())
	else:
		feather.look_at(feather.global_position + Input.get_vector("feather_left", "feather_right", "feather_up", "feather_down"))
	var r2: Vector2 = feather.global_transform.x
	var vel: float = abs(r1.angle_to(r2))
	var pos: Vector2 = lerp(r1, r2, 0.5)
	if stamina < 0.0:
		velocity -= vel * pos * feather_impact
		stamina -= vel * STAMINA_RATE
	# do feather effect


func get_gravity() -> float:
	if not falling:
		falling = velocity.y > 0.0
	if falling:
		return fall_gravity
	return jump_gravity


func jump() -> void:
	velocity.y = jump_velocity


func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0
	
	return horizontal
