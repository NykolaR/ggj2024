extends CanvasLayer

@onready var fade: ColorRect = $ColorRect

signal fade_completed

func level_complete() -> void:
	$StageComplete.show_comp()


func fade_opaque() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 0.5)
	await tween.finished
	fade_completed.emit()
	$StageComplete.hide_comp()


func fade_transparent() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 0.5)
	await tween.finished
	fade_completed.emit()
