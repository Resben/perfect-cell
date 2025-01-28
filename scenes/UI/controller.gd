extends CanvasLayer
class_name Controller

signal _on_finish_loading

enum { MENU, PAUSED, GAME }

var state = MENU

var current_bgm = "peaceful"
var bgm_volume = 0.5
var sfx_volume = 1.0

@onready var hud = $HUD
@onready var transition_player = $TransitionPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$TransitionPlayer.visible = true
	$GameOver.visible = false
	$Startup.visible = true
	$HUD.visible = false
	$Paused.visible = false
	$BGM.volume_db = linear_to_db(bgm_volume)
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
		else:
			$Paused.mouse_filter = Control.MOUSE_FILTER_IGNORE
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

func switch_bgm(id):
	if id == current_bgm:
		return
	
	#current_bgm = id
	#var tween = get_tree().create_tween()
	#tween.tween_property($BGM, "volume_db", linear_to_db(0.0), 7.5)
	#tween.tween_callback(next_track)

func load_music(music : AudioStream, should_tween : bool):
	if should_tween:
		var callable = Callable(self.load_next_track).bind(music)
		var tween = get_tree().create_tween()
		tween.tween_property($BGM, "volume_db", linear_to_db(0), 5)
		tween.tween_callback(callable)
		tween.tween_property($BGM, "volume_db", linear_to_db(bgm_volume), 5)
	else:
		load_next_track(music)

func load_next_track(music : AudioStream):
	$BGM.stream = music
	$BGM.play()

func play_SFX(_id):
	pass

func _on_bgm_finished():
	$BGM.play()

func _on_h_slider_value_changed(value):
	bgm_volume = value
	$BGM.volume_db = linear_to_db(value)

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
