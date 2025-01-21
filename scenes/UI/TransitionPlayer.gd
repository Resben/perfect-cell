extends Control

var next_callback : Callable
var is_loading = false

func _ready():
	$Sprite2D2.visible = false

func play_transition(callback : Callable):
	next_callback = callback
	is_loading = true
	$AnimationPlayer.play("transition")

func play_callback(anim_name):
	if anim_name == "transition":
		$Sprite2D2.visible = true
		$Label.visible = true
		$LoadingAnimationPlayer.play("loop")
		next_callback.call()

func scene_loaded():
	$LoadingAnimationPlayer.stop()
	$Sprite2D2.visible = false
	$Label.visible = false
	$AnimationPlayer.play("transition_pt2")

func _on_default_timeout():
	scene_loaded()
