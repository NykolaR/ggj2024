extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		Sounds.play()
		set_process_input(false)
		Fader.fade_opaque()
		await Fader.fade_completed
		get_tree().change_scene_to_file("res://scenes/game_holder/game_holder.tscn")
