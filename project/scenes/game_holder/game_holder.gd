extends Node


const LEVELS: Array[PackedScene] = [
	
]

var current_level: int = 0


func _ready() -> void:
	load_current_level()


func level_completed() -> void:
	current_level = wrapi(current_level + 1, 0, LEVELS.size())
	load_current_level()


func restart_level() -> void:
	load_current_level()


func load_current_level() -> void:
	for child in get_children():
		child.queue_free()
	var scene: Node = LEVELS[current_level].instantiate()
