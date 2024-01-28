extends Node2D

@export var focus: Node2D
var unzoomed: bool = false

func _ready() -> void:
	set_process(is_instance_valid(focus))


func _process(delta: float) -> void:
	global_position.x = focus.global_position.x


func creature_enter() -> void:
	if unzoomed:
		return
	unzoomed = true
	$AnimationPlayer.play("zoom_out")
	
