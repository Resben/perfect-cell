extends Control

var base_offset = 80
var scale_offset = 1
var start_pos

func _ready():
	start_pos = $TextureRect.position

func update_score(score : int):
	$Label.text = str(score)
	update_size(score)

func update_size(score : int):
	var lvlData = GameHandler.main.current_level.data
	var score_to_size = GameHandler.map_value(score, lvlData.last_required_points, lvlData.required_points, lvlData.minimum_size, lvlData.maximum_size)
	$Label2.text = str(score_to_size) + lvlData.measurement_type

func update_arrow(direction : Vector2):
	var offset = max(80, base_offset * scale_offset.x)
	$TextureRect.position = start_pos + direction * offset
	$TextureRect.rotation = direction.angle()

func update_scale(new_scale : Vector2):
	scale_offset = new_scale * 0.5
