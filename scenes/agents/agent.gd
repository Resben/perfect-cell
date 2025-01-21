extends CharacterBody2D
class_name Agent

enum { WANDER, ATTACK, DEAD }
var state = WANDER
var last_state = DEAD

@onready var health_component : HealthComponent = $HealthComponent
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var hitbox_component : HitBoxComponent = $HitBoxComponent
@onready var hurtbox_component : HurtBoxComponent = $HurtBoxComponent
@onready var navigation_component : NavigationComponent = $NavigationComponent

@export var edible : PackedScene
@export var value : int

# Called when the node enters the scene tree for the first time.
func _ready():
	health_component._on_health_depletion.connect(self.on_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state != last_state:
		exit_state(last_state)
		enter_state(state)
		last_state = state
	
	run_state(delta, state)
	
	navigation_component.follow_path()
	velocity_component.move(self)

func exit_state(in_state):
	pass

func enter_state(in_state):
	match in_state:
		DEAD:
			pass
		WANDER:
			navigation_component.set_target_position(Vector2(randf_range(-200, 200), randf_range(-200, 200)) + global_position)

func run_state(delta, in_state):
	pass

func on_death():
	state = DEAD
	var to_spawn = edible.instantiate() as Edible
	to_spawn.setup(value)
	to_spawn.position = position
	get_parent().add_child(to_spawn)

