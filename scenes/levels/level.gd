extends Node2D
class_name Level

var data : LevelData

# Set backgrounds and every and etc
func setup(lvl_data : LevelData):
	data = lvl_data
	$Sprite2D.texture = data.texture

func toggle_visibility(is_active : bool):
	visible = is_active
	
	if !is_active:
		process_mode = PROCESS_MODE_DISABLED
	else:
		process_mode = PROCESS_MODE_PAUSABLE
