extends CanvasLayer

const balloon = preload("res://scenes/UI/small_balloon.tscn")

func _ready():
	var bubble = balloon.instantiate() as SmallBalloonDialogue
	add_child(bubble)
	bubble.start(load("res://resources/dialogue/opening_scene.dialogue"), "start")
	bubble._on_dialogue_finished.connect(self.dialogue_finished)

func dialogue_finished():
	GameHandler.main.controller.transition_player.play_transition(custom_to_game)

func custom_to_game():
	GameHandler.main.controller.to_game_callback()
	queue_free()
