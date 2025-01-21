extends Node2D
class_name Level

@onready var camera : Camera2D = $Camera2D

var data : LevelData

# Set backgrounds and every and etc
func setup(lvl_data : LevelData):
	data = lvl_data
	$Sprite2D.texture = data.texture

func toggle_visibility(is_active : bool):
	visible = is_active
	
	if !is_active:
		modulate = Color(1, 1, 1, 0)
		process_mode = PROCESS_MODE_DISABLED
	else:
		modulate = Color(1, 1, 1, 1)
		process_mode = PROCESS_MODE_PAUSABLE
