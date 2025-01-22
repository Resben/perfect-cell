extends Entity
class_name Player

var direction = Vector2(1, 1)

func _ready():
	super._ready()
	add_to_group("player")
	consumed_points = 25
	GameHandler._start_game.connect(self.init_player)

func init_player():
	calc_size(false)
	GameHandler.main.controller.update_score(consumed_points)

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up"))

	if velocity.length() > 1:
		velocity = velocity.normalized()
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)

func _process(delta):
	if Input.is_action_just_pressed("test"):
		GameHandler.main.transition_to_next()

func bye_bye():
	consumed_points = 0
	z_index = 1

func on_consume(body):
	print("value: ", body.calculate_value())
	super.on_consume(body)
	#var scale_value = GameHandler.map_value(consumed_points, lvlData.last_required_points, current_max_points, 0.2, 2)
	#var tween = get_tree().create_tween()
	#tween.tween_property($Camera2D, "zoom", Vector2(scale_value, scale_value))
	GameHandler.main.controller.update_score(consumed_points)
	if consumed_points >= GameHandler.main.current_level.data.required_points:
		print("next lvl")
		GameHandler.main.transition_to_next()

func on_eaten(body):
	pass # Died
