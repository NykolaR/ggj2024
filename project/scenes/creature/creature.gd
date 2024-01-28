extends Node2D

var tickle_tension: float = 0.0
var tickled: bool = false
@onready var visual: CreatureVisual = $CreatureVisual as CreatureVisual

func tickle_reset() -> void:
	tickle_tension = 0.0
	tickled = false


func tickle_increase(amount: float) -> void:
	if tickled:
		return
	tickle_tension += amount
	
	if tickle_tension > 1:
		tickled = true
		visual.laugh()
