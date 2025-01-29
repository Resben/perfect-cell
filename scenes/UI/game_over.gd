extends Control

func set_score(_score):
	pass # total score and etc

func game_condition(did_player_win : bool):
	if did_player_win:
		$Respawn.visible = false
	else:
		$Respawn.visible = true

func _on_menu_pressed():
	get_parent().switch_to_menu()

func _on_respawn_pressed():
	get_parent().transition_player.play_transition(on_respawn_transition)

func on_respawn_transition():
	GameHandler.bye_bye()
	GameHandler.level_index = GameHandler.main.saved_index - 1
	GameHandler.main.open_scene_finished()
	GameHandler.main.player_ref.consumed_points = GameHandler.main.current_level.data.last_required_points
	GameHandler.main.player_ref.enable_mouth()
	self.visible = false
