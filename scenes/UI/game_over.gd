extends Control

func _on_button_pressed():
	get_parent().switch_to_menu()

func set_score(_score):
	pass # total score and etc

func game_condition(did_player_win : bool):
	pass
