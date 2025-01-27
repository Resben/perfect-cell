extends CanvasLayer

const balloon = preload("res://scenes/UI/small_balloon.tscn")

func _ready():
	var bubble = balloon.instantiate()
	add_child(bubble)
	bubble.start(load("res://resources/dialogue/opening_scene.dialogue"), "start")
