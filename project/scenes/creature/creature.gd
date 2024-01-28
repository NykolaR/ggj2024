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


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	get_tree().call_group("GameCam", "creature_enter")


func mouth_mask() -> void:
	pass


func _on_creature_visual_mouth_opened() -> void:
	$CreatureVisual/Node2D/Body/Mouth.monitorable = true


func _on_creature_visual_mouth_closed() -> void:
	$CreatureVisual/Node2D/Body/Mouth.monitorable = false
