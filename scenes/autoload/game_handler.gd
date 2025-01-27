extends Node

@export var levels : Array[LevelData]

signal _start_game

var level_index : int = 0
var main : Main

func get_next_level():
	level_index += 1
	var next_level = null
	if levels.size() > level_index:
		next_level = levels[level_index]
	return next_level

func transition_to_next():
	pass

func bye_bye():
	level_index = 0
	main.bye_bye()

# Used to calculate a scale value
func map_value(input_value: float, min_input: float, max_input: float, min_output: float, max_output: float) -> float:
	return min_output + (input_value - min_input) * (max_output - min_output) / (max_input - min_input)

func game_ready():
	_start_game.emit()

func game_over():
	main.game_over()
	main.controller.show_game_over(main.player_ref.consumed_points)

func game_won():
	main.game_over()
	main.controller.show_game_won(main.player_ref.consumed_points)
