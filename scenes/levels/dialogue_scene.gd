extends CanvasLayer

const balloon = preload("res://scenes/UI/small_balloon.tscn")

var scene_to_load = "res://resources/dialogue/opening_scene.dialogue"
var is_ending_scene = false

func _ready():
	var bubble = balloon.instantiate() as SmallBalloonDialogue
	add_child(bubble)
	bubble.start(load(scene_to_load), "start")
	bubble._on_dialogue_finished.connect(self.dialogue_finished)

func dialogue_finished():
	if is_ending_scene:
		GameHandler.main.controller.play_SFX("glass")
		GameHandler.main.controller.transition_player.play_transition(custom_to_menu)
	else:
		GameHandler.main.controller.transition_player.play_transition(custom_to_game)

func custom_to_game():
	GameHandler.main.controller.to_game_callback()
	queue_free()

func custom_to_menu():
	GameHandler.main.controller.to_menu_callback()
	queue_free()
