extends Node2D
class_name Main

@export var level_prefab : PackedScene

@onready var controller : Controller = $Controller
@onready var player_ref : Player = $Player

var current_level : Level
var next_level : Level
var is_last_level : bool = false

func _ready():
	load_level(GameHandler.levels[0], true)
	load_level(GameHandler.get_next_level(), false)
	GameHandler.main = self
	GameHandler.game_ready()
	player_ref.enable_mouth()

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
		current_level.toggle_consumption(true)
	else:
		next_level = level
		next_level.toggle_visibility(false)
		add_child(next_level)
		next_level.scale = Vector2(2, 2)
		next_level.modulate = Color(1, 1, 1, 0)

func transition_to_next():
	if is_last_level:
		GameHandler.game_won()
		return
	
	player_ref.disable_mouth()
	current_level.toggle_consumption(false)
	next_level.toggle_visibility(true)
	
	#### SCALE EVERYTHING INDIVIDUALLY INSTEAD
	
	var tween = get_tree().create_tween()
	current_level.scale_all(tween, Vector2(0.5, 0.5), 2)
	tween.parallel().tween_property(current_level, "modulate", Color(1, 1, 1, 0), 2)
	tween.parallel().tween_property(next_level, "modulate", Color(1, 1, 1, 1), 2)
	#next_level.scale_all(tween, Vector2(1, 1), 2)
	# Base new player scale off the next levels data
	var new_scale = player_ref.calc_scale(next_level.data)
	player_ref.scale_components(Vector2(new_scale, new_scale), 2, true, tween)
	tween.tween_callback(current_level.queue_free)
	tween.tween_callback(next_level.finish_transition)
	tween.tween_callback(player_ref.enable_mouth)
	
	current_level = next_level
	var nxtLvlData = GameHandler.get_next_level()
	if nxtLvlData == null:
		is_last_level = true
		return # No need to load level
	
	load_level(nxtLvlData, false)

func game_over():
	player_ref.disable_mouth()
	current_level.toggle_consumption(false)

func bye_bye():
	player_ref.bye_bye()
	
	if current_level != null:
		current_level.queue_free()
	if next_level != null:
		next_level.queue_free()
	
	load_level(GameHandler.levels[0], true)
	load_level(GameHandler.get_next_level(), false)
