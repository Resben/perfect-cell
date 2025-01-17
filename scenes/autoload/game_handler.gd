extends Node

@export var levels : Array[LevelData]

var current_level : LevelData
var level_index : int = 0

func get_next_level():
	level_index += 1
	current_level = levels[level_index]
	
	return levels[level_index + 1]
