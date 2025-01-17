extends Node2D
class_name Level

@onready var camera : Camera2D = $Camera2D

var current_level
var next_level

func _ready():
	load_to_current(GameHandler.levels[0])
	load_to_queue(GameHandler.get_next_level())

func play_scene():
	pass

func pause_scene():
	pass

func transition_to_next_level():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2(2, 2), 1)
	
	current_level = next_level
	next_level = GameHandler.get_next_level()

func load_to_current(lvl : LevelData):
	pass

func load_to_queue(lvl : LevelData):
	pass
