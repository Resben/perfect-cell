extends Entity
class_name Player

@export var min_zoom : float = 0.5
@export var max_zoom : float = 3.0

var was_eaten = false
var won = false

var direction = Vector2(1, 1)

func _ready():
	super._ready()
	add_to_group("player")
	consumed_points = 0
	GameHandler._start_game.connect(self.init_player)

func init_player():
	consumed_points = GameHandler.main.current_level.data.last_required_points
	calc_size(false)
	GameHandler.main.controller.hud.update_score(consumed_points)

func _physics_process(delta):
	if was_eaten || won:
		return
	
	direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()
	
	velocity_component.accelerate_in_direction(direction, delta)
	velocity_component.move(self)

func _process(_delta):
	if Input.is_action_just_pressed("test"):
		GameHandler.main.transition_to_next()

func winner():
	won = true

func bye_bye():
	z_index = 1
	mouth_component.enable()
	was_eaten = false
	visible = true
	won = false

func on_consume(body):
	consumed_points += body.calculate_value()
	calc_size(true)
	GameHandler.main.controller.hud.update_score(consumed_points)
	if consumed_points >= GameHandler.main.current_level.data.required_points:
		GameHandler.main.transition_to_next()

# Override for player
func calc_size(should_tween : bool):
	var new_scale = calc_scale(GameHandler.main.current_level.data)
	var zoom_scale = GameHandler.map_value(new_scale, 0.3, 2.1, min_zoom, max_zoom)
	zoom_scale = (min_zoom + max_zoom) - zoom_scale
	
	if zoom_scale > max_zoom:
		zoom_scale = max_zoom
	if zoom_scale < min_zoom:
		zoom_scale = min_zoom
	
	if should_tween:
		var tween = get_tree().create_tween()
		scale_components(Vector2(new_scale, new_scale), 1, true, tween)
		tween.parallel().tween_property($Camera2D, "zoom", Vector2(zoom_scale, zoom_scale), 0.5)
	else:
		scale_components(Vector2(new_scale, new_scale), false, 1)
		$Camera2D.zoom = Vector2(zoom_scale, zoom_scale)
	z_index = GameHandler.map_value(new_scale, 0.3, 2.1, 2, 11)
	GameHandler.main.controller.hud.update_scale(Vector2(new_scale, new_scale))

func force_calculate_zoom(lvlData : LevelData):
	var new_scale = calc_scale(lvlData)
	var zoom_scale = GameHandler.map_value(new_scale, 0.3, 2.1, min_zoom, max_zoom)
	zoom_scale = (min_zoom + max_zoom) - zoom_scale
	
	if zoom_scale > max_zoom:
		zoom_scale = max_zoom
	if zoom_scale < min_zoom:
		zoom_scale = min_zoom
	
	var tween = get_tree().create_tween()
	tween.parallel().tween_property($Camera2D, "zoom", Vector2(zoom_scale, zoom_scale), 0.5)

# Override for player
func calc_scale(lvlData : LevelData):
	if consumed_points > lvlData.required_points:
		if GameHandler.main.next_level != null:
			lvlData = GameHandler.main.next_level.data
		else:
			return 2.1
	
	var current_max_points = lvlData.required_points * 0.9
	return GameHandler.map_value(consumed_points, lvlData.last_required_points, current_max_points, 0.3, 2.1)

func on_eaten(body):
	print("size: " + str(body.scale) + " vs " + str(scale))
	GameHandler.game_over()
	was_eaten = true
	visible = false
