extends CharacterBody2D

const MAX_STAMINA: float = 3.99
const STAMINA_RATE: float = 0.15
const MAX_SPEED: float = 200.0

@export var move_speed: float = 100.0

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@export var friction: float = 50.0

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var feathers: Array[Node2D] = [
	$Feather/F1,
	$Feather/F2,
	$Feather/F3,
	$Feather/F4,
	$Feather/F5
]

@onready var particles: GPUParticles2D = $Feather/GPUParticles2D as GPUParticles2D
@onready var ftimer: Timer = $Timer as Timer

@onready var visual: Node2D = $Node2D as Node2D

@export var feather: Area2D
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
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)


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
	if stamina > 0.0:
		velocity -= vel * pos * feather_impact
		stamina -= vel * STAMINA_RATE
	# do feather effect
	
	if vel > 0.02:
		if stamina > 0 and ftimer.is_stopped():
			ftimer.start()
	else:
		ftimer.stop()
	
	for feather in feathers:
		feather.show()
	if stamina < 3:
		feathers[1].hide()
	if stamina < 2:
		feathers[2].hide()
	if stamina < 1:
		feathers[3].hide()
	if stamina < 0:
		feathers[4].hide()
	
	if stamina > 0:
		for body in feather.get_overlapping_areas():
			var ppp: Node = body.get_parent().get_parent().get_parent()
			if ppp and ppp.has_method("tickle_increase"):
				ppp.tickle_increase(vel)


func get_gravity() -> float:
	if not falling:
		falling = velocity.y > 0.0
	if falling:
		return fall_gravity
	return jump_gravity


func jump() -> void:
	velocity.y = jump_velocity
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	visual.scale.x = 0.075
	tween.tween_property(visual, "scale:x", 0.085, 1.0)


func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0
	
	return horizontal


func _on_timer_timeout() -> void:
	particles.emitting = true
	await get_tree().create_timer(0.02).timeout
	particles.emitting = false
