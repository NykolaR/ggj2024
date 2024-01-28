extends CanvasLayer


@onready var comp: Label = $Complete as Label


func show_comp() -> void:
	comp.modulate.a = 1.0


func hide_comp() -> void:
	comp.modulate.a = 0.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and comp.modulate.a > 0.98:
		get_tree().call_group("GameHolder", "level_completed")
		comp.modulate.a = 0.97
