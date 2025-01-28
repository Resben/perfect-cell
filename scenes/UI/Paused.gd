extends Control

func _on_continue_pressed():
	get_parent().toggle_pause()

func _on_to_menu_pressed():
	get_parent().switch_to_menu()
	get_tree().paused = false

func when_shown():
	$MarginContainer/TextureRect/HSlider.value = get_parent().bgm_volume
