extends CharacterBody2D
class_name Agent

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
	pass

func on_death():
	var to_spawn = edible.instantiate() as Edible
	to_spawn.setup(value)
