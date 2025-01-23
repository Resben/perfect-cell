extends Entity
class_name Player

var direction = Vector2(1, 1)

func _ready():
	super._ready()
	add_to_group("player")
	consumed_points = 0
	GameHandler._start_game.connect(self.init_player)

func init_player():
	calc_size(false)
	GameHandler.main.controller.hud.update_score(consumed_points)

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()

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
	mouth_component.enable()

func on_consume(body):
	consumed_points += body.calculate_value()
	calc_size(true)
	GameHandler.main.controller.hud.update_score(consumed_points)
	if consumed_points >= GameHandler.main.current_level.data.required_points:
		print("next lvl")
		GameHandler.main.transition_to_next()

# Override for player
func calc_size(should_tween : bool):
	var new_scale = calc_scale(GameHandler.main.current_level.data)
	if should_tween:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(new_scale, new_scale), 1)
	else:
		scale = Vector2(new_scale, new_scale)
	z_index = GameHandler.map_value(new_scale, 0.3, 2.1, 2, 11)

# Override for player
func calc_scale(lvlData : LevelData):
	var current_max_points = lvlData.required_points * 0.9
	return GameHandler.map_value(consumed_points, lvlData.last_required_points, current_max_points, 0.3, 2.1)

func on_eaten(body):
	print("size: " + str(body.scale) + " vs " + str(scale))
	GameHandler.game_over()
