extends Node2D
class_name Main

@export var level_prefab : PackedScene

var current_level : Level
var next_level : Level
var is_last_level : bool = false

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
		current_level.scale = Vector2(1, 1)
	else:
		next_level = level
		next_level.toggle_visibility(false)
		add_child(next_level)
		next_level.scale = Vector2(2, 2)
		next_level.modulate = Color(1, 1, 1, 0)

func transition_to_next():
	if is_last_level:
		return # Here we say the player won!
	
	next_level.toggle_visibility(true)
	
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(current_level, "scale", Vector2(0.5, 0.5), 2)
	tween.parallel().tween_property(current_level, "modulate", Color(1, 1, 1, 0), 2)
	tween.parallel().tween_property(next_level, "modulate", Color(1, 1, 1, 1), 2)
	tween.parallel().tween_property(next_level, "scale", Vector2(1, 1), 2)
	tween.tween_callback(current_level.queue_free)
	
	var nxtLvlData = GameHandler.get_next_level()
	if nxtLvlData == null:
		is_last_level = true
	
	current_level = next_level
	load_level(nxtLvlData, false)
