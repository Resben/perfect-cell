extends Node2D
class_name Main

@export var level_prefab : PackedScene

var current_level : Level
var next_level : Level

func _ready():
	load_level(GameHandler.levels[0], true)
	load_level(GameHandler.get_next_level(), false)

func load_level(lvl : LevelData, to_current : bool):
	var level = level_prefab.instantiate() as Level
	level.setup(lvl)
	
	if to_current:
		if current_level != null:
			current_level.queue_free()
		current_level = level
		current_level.toggle_visibility(false, false)
	else:
		next_level = level
		next_level.toggle_visibility(true, true)

func transition_to_next():
	current_level.queue_free()
	current_level = next_level
	current_level.toggle_visibility(false, false)
	var nxtLvlData = GameHandler.get_next_level()
	if nxtLvlData == null:
		return
	
	load_level(nxtLvlData, false)
