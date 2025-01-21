extends CharacterBody2D
class_name Player

@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var hitbox_component : HitBoxComponent = $HitBoxComponent
@onready var hurtbox_component : HurtBoxComponent = $HurtBoxComponent
@onready var health_component : HealthComponent = $HealthComponent

var current_level_points : int = 0

func _ready():
	add_to_group("player")

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	var direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up"))

	if velocity.length() > 1:
		velocity = velocity.normalized()
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)

func _on_yum_sphere_area_entered(area):
	if area is Edible:
		current_level_points += area.value
		if current_level_points > GameHandler.main.current_level.data.required_points:
			GameHandler.main.transition_to_next()
		area.queue_free()

func _process(delta):
	if Input.is_action_just_pressed("test"):
		GameHandler.main.transition_to_next()

func bye_bye():
	current_level_points = 0
