extends Control

func update_score(score : int):
	$Label.text = str(score)
	update_size(score)

func update_size(score : int):
	var lvlData = GameHandler.main.current_level.data
	var score_to_size = GameHandler.map_value(score, lvlData.last_required_points, lvlData.required_points, lvlData.minimum_size, lvlData.maximum_size)
	$Label2.text = str(score_to_size) + lvlData.measurement_type
