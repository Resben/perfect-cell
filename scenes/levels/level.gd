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
	$EntityHandler.reset_nav_targets()

func toggle_consumption(val : bool):
	if val:
		$EntityHandler.enable_consumption()
	else:
		$EntityHandler.disable_consumption()

func scale_all(tween : Tween, to_scale : Vector2, time : float):
	for e in $EntityHandler.enemy_references:
		tween.parallel().tween_property(e, "scale", to_scale, time)
