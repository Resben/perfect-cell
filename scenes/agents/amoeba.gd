extends Agent

func run_state(delta, in_state):
	match in_state:
		WANDER:
			if navigation_component.is_navigation_finished():
				navigation_component.set_target_position(Vector2(randf_range(-200, 200), randf_range(-200, 200)) + global_position)
