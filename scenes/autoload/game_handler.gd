extends Node

@export var levels : Array[LevelData]

var level_index : int = 0
var main : Main

func get_next_level():
	level_index += 1
	var next_level = null
	if levels.size() > level_index:
		next_level = levels[level_index]
	return next_level

func transition_to_next():
	pass

func bye_bye():
	print("not implemented")

func play():
	pass
