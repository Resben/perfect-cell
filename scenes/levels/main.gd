extends Node2D
class_name Main

@export var level_prefab : PackedScene

@onready var controller : Controller = $Controller
@onready var player_ref : Player = $Player

var saved_index = 1

var current_level : Level
var next_level : Level
var is_last_level : bool = false

func _ready():
	GameHandler.main = self

func open_scene_finished():
	load_level(GameHandler.get_next_level(), true)
	load_level(GameHandler.get_next_level(), false)
	player_ref.enable_mouth()
	GameHandler.game_ready()

func load_level(lvl : LevelData, to_current : bool):
	if lvl == null && to_current:
		printerr("This should never happen")
		return
	
	if lvl == null && !to_current:
		is_last_level = true
		return
	
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
		current_level.enable_spawns()
		if current_level.data.music_to_play:
			GameHandler.main.controller.load_music(current_level.data.music_to_play, true)
	else:
		next_level = level
		next_level.toggle_visibility(false)
		add_child(next_level)
		next_level.scale = Vector2(2, 2)
		next_level.modulate = Color(1, 1, 1, 0)

func transition_to_next():
	if is_last_level:
		GameHandler.main.controller.transition_to_end_scene()
		saved_index = 1
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
	player_ref.force_calculate_zoom(next_level.data)
	tween.tween_callback(current_level.queue_free)
	tween.tween_callback(next_level.finish_transition)
	tween.tween_callback(player_ref.enable_mouth)
	tween.tween_interval(1)
	tween.tween_callback(next_level.show_dialogue)
	tween.tween_callback(next_level.enable_spawns)
	
	if next_level.data.music_to_play:
		GameHandler.main.controller.load_music(next_level.data.music_to_play, true)
	
	saved_index += 1
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
