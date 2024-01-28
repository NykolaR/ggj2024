extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer as AnimationPlayer

var tickle_tension: float = 0.0
var tickled: bool = false

func tickle_reset() -> void:
	tickle_tension = 0.0
	tickled = false


func tickle_increase(amount: float) -> void:
	if tickled:
		return
	tickle_tension += amount
	if tickle_tension > 100:
		tickled = true
		animation.play("laugh")
