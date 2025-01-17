extends Node2D
class_name Level

@onready var camera : Camera2D = $Camera2D

var data : LevelData

# Set backgrounds and every and etc
func setup(lvl_data : LevelData):
	data = lvl_data
	$Sprite2D.texture = data.texture

func transition_to_next_level():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2(2, 2), 1)
	GameHandler.main.transition_to_next()

func toggle_visibility(should_hide : bool, should_pause : bool):
	visible = should_hide
	
	if should_pause:
		process_mode = PROCESS_MODE_DISABLED
	else:
		process_mode = PROCESS_MODE_PAUSABLE
