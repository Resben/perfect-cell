extends Node2D
class_name Level

var data : LevelData

# Set backgrounds and every and etc
func setup(lvl_data : LevelData):
	data = lvl_data
	$ParallaxBackground/ParallaxLayer/Sprite2D.texture = data.texture
	$EntityHandler.setup(lvl_data)

func toggle_visibility(is_active : bool):
	visible = is_active
	
	if !is_active:
		process_mode = PROCESS_MODE_DISABLED
	else:
		process_mode = PROCESS_MODE_PAUSABLE

func finish_transition():
	$EntityHandler.enable_consumption()

func toggle_consumption(val : bool):
	if val:
		$EntityHandler.enable_consumption()
	else:
		$EntityHandler.disable_consumption()
