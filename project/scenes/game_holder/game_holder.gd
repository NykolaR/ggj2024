extends Node


const LEVELS: Array[PackedScene] = [
	preload("res://scenes/levels/level-1.tscn"),
	preload("res://scenes/levels/level-2.tscn"),
	preload("res://scenes/levels/level-3.tscn")
]

var current_level: int = 0


func _ready() -> void:
	var scene: Node = LEVELS[current_level].instantiate()
	add_child(scene)


func level_completed() -> void:
	current_level = wrapi(current_level + 1, 0, LEVELS.size())
	load_current_level()


func restart_level() -> void:
	load_current_level()


func load_current_level() -> void:
	Fader.fade_opaque()
	await Fader.fade_completed
	for child in get_children():
		child.queue_free()
	var scene: Node = LEVELS[current_level].instantiate()
	add_child(scene)
	Fader.fade_transparent()
