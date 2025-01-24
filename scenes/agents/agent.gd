extends Entity
class_name Agent

enum { WANDER, ATTACK, DEAD }
var state = WANDER
var last_state = DEAD

@onready var navigation_component : NavigationComponent = $NavigationComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state != last_state:
		exit_state(last_state)
		enter_state(state)
		last_state = state
	
	run_state(delta, state)
	
	navigation_component.follow_path()
	velocity_component.move(self)

func exit_state(_in_state):
	pass

func enter_state(in_state):
	match in_state:
		DEAD:
			pass
		WANDER:
			navigation_component.set_target_position(Vector2(randf_range(-200, 200), randf_range(-200, 200)) + global_position)

func run_state(_delta, _in_state):
	pass

func on_eaten(_body):
	state = DEAD
	die()

func on_consume(_body):
	pass

func force_reset_nav():
	navigation_component.force_set_target_position(Vector2(randf_range(-200, 200), randf_range(-200, 200)) + global_position)

# Died to something other than consumption
func on_death():
	state = DEAD
	die()
