extends CanvasLayer
class_name Controller

signal _on_finish_loading

enum { MENU, PAUSED, GAME }

var state = MENU

var current_bgm = "peaceful"
var bgm_volume = 0.5
var sfx_volume = 1.0

var track_one_active = true

var dialogue_scene = preload("res://scenes/levels/dialogue_scene.tscn")

@onready var hud = $HUD
@onready var transition_player = $TransitionPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$TransitionPlayer.visible = true
	$GameOver.visible = false
	$Startup.visible = true
	$HUD.visible = false
	$Paused.visible = false
	$BGMOne.volume_db = linear_to_db(bgm_volume)
	$BGMTwo.volume_db = linear_to_db(0)
	$Startup/Volume.value = bgm_volume
	show_buttons()

func _input(_event):
	if Input.is_action_just_pressed("pause") && !$Startup.visible:
		toggle_pause()

func show_buttons():
	if !GameHandler.main || GameHandler.main.saved_index == 1:
		$Startup/Play.visible = true
		$Startup/Continue.visible = false
		$Startup/Restart.visible = false
	else:
		$Startup/Play.visible = false
		$Startup/Continue.visible = true
		$Startup/Restart.visible = true

func toggle_pause():
		$Paused.visible = !$Paused.visible
		if $Paused.visible:
			$Paused.mouse_filter = Control.MOUSE_FILTER_STOP
			$Paused.when_shown()
			$HUD.visible = false
		else:
			$Paused.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$HUD.visible = true
		get_tree().paused = $Paused.visible

func switch_to_menu():
	state = MENU
	$TransitionPlayer.play_transition(to_menu_callback)

func to_menu_callback():
	$Startup.visible = true
	$Startup.mouse_filter = Control.MOUSE_FILTER_STOP
	$HUD.visible = false
	$Paused.visible = false
	$GameOver.visible = false
	GameHandler.bye_bye()
	show_buttons()

func show_game_over(points):
	$GameOver.set_score(points)
	$GameOver.visible = true
	$GameOver.game_condition(false)

func show_game_won(points):
	$GameOver.set_score(points)
	$GameOver.visible = true
	$GameOver.game_condition(true)

func switch_to_game(to_dialogue : bool):
	state = GAME
	if to_dialogue:
		$TransitionPlayer.play_transition(to_dialogue_callback)
	else:
		$TransitionPlayer.play_transition(to_game_callback)

func to_dialogue_callback():
	$Startup.visible = false
	$Startup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(load("res://scenes/levels/dialogue_scene.tscn").instantiate())

func transition_to_game():
	$TransitionPlayer.play_transition(to_game_callback)

func to_game_callback():
	$Startup.visible = false
	$Startup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$HUD.visible = true
	GameHandler.main.open_scene_finished()

func load_music(music : AudioStream, should_tween : bool):
	if should_tween:
		if track_one_active:
			track_one_active = false
			$BGMTwo.stream = music
			$BGMTwo.play()
			var tween = get_tree().create_tween()
			tween.parallel().tween_property($BGMOne, "volume_db", linear_to_db(0), 5)
			tween.parallel().tween_property($BGMTwo, "volume_db", linear_to_db(bgm_volume), 5)
			tween.tween_callback($BGMOne.stop)
		else:
			track_one_active = true
			$BGMOne.stream = music
			$BGMOne.play()
			var tween = get_tree().create_tween()
			tween.parallel().tween_property($BGMTwo, "volume_db", linear_to_db(0), 5)
			tween.parallel().tween_property($BGMOne, "volume_db", linear_to_db(bgm_volume), 5)
			tween.tween_callback($BGMTwo.stop)
	else:
		track_one_active = true
		$BGMOne.stream = music
		$BGMOne.play()
		$BGMOne.volume_db = linear_to_db(bgm_volume)
		$BGMTwo.stop()

func play_SFX(_id):
	pass

func _on_bgm_finished():
	if track_one_active:
		$BGMOne.play()
	else:
		$BGMTwo.play()

func _on_h_slider_value_changed(value):
	bgm_volume = value
	if track_one_active:
		$BGMOne.volume_db = linear_to_db(value)
	else:
		$BGMTwo.volume_db = linear_to_db(value)

func transition_to_end_scene():
	$TransitionPlayer.play_transition(end_scene_transition)

func end_scene_transition():
	var scene = dialogue_scene.instantiate()
	scene.scene_to_load = "res://resources/dialogue/ending_scene.dialogue"
	scene.is_ending_scene = true
	GameHandler.main.add_child(scene)

func _on_button_pressed():
	switch_to_game(true)
	GameHandler.level_index = 0
	GameHandler.main.saved_index = 1
	GameHandler.main.player_ref.consumed_points = 0

func _on_continue_pressed():
	GameHandler.level_index = GameHandler.main.saved_index - 1
	switch_to_game(false)

func _on_restart_pressed():
	GameHandler.level_index = 0
	GameHandler.main.saved_index = 1
	GameHandler.main.player_ref.consumed_points = 0
	switch_to_game(true)
