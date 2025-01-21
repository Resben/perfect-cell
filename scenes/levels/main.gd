extends Node2D
class_name Main

@export var level_prefab : PackedScene

var current_level : Level
var next_level : Level

func _ready():
	load_level(GameHandler.levels[0], true)
	load_level(GameHandler.get_next_level(), false)
	GameHandler.main = self

func load_level(lvl : LevelData, to_current : bool):
	var level = level_prefab.instantiate() as Level
	level.setup(lvl)
	
	if to_current:
		if current_level != null:
			current_level.queue_free()
		current_level = level
		current_level.toggle_visibility(true)
		add_child(current_level)
	else:
		next_level = level
		next_level.toggle_visibility(false)

func transition_to_next():
	next_level.toggle_visibility(true)
	
	var tween = get_tree().create_tween()
	tween.parallel()
	tween.tween_property(current_level.camera, "zoom", Vector2(0.5, 0.5), 1)
	tween.tween_property(current_level, "modulate", Color(1, 1, 1, 0), 1)
	tween.tween_property(next_level, "modulate", Color(1, 1, 1, 1), 1)
	
	await tween.finished
	current_level.queue_free()
	
	var nxtLvlData = GameHandler.get_next_level()
	if nxtLvlData == null:
		return
	
	current_level = next_level
	load_level(nxtLvlData, false)
