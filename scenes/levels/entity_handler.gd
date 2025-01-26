extends Node2D

var enemy_composition : Array[EnemyData]
var enemy_references = []

var player_ref : Player
var view_radius = 400
var spawn_radius = 800
var despawn_radius = 1600
var min_enemies = 30

var is_enabled = false

func _ready():
	player_ref = get_tree().get_nodes_in_group("player")[0]

func setup(lvl : LevelData):
	enemy_composition = lvl.enemy_composition

func _process(_delta):
	ensure_entities_around_player()

func ensure_entities_around_player():
	var player_position = player_ref.global_position
	var enemies_in_radius = 0

	# Check for existing entities within the radius
	for entity in enemy_references:
		var distance = player_position - entity.global_position
		if distance.x <= spawn_radius || distance.y <= spawn_radius:
			enemies_in_radius += 1
		elif distance.x >= despawn_radius || distance.y >= despawn_radius:
			enemy_references.erase(entity)
			entity.queue_free()
	
	# Spawn additional entities if below threshold
	var missing_entities = min_enemies - enemies_in_radius
	for i in range(missing_entities):
		spawn_enemy_near_player(player_position)

func spawn_enemy_near_player(player_position: Vector2):
	var enemy = enemy_composition[0].enemy.instantiate()
	var random_offset
	
	# Spawn in all direcitons or in the direction the player is moving
	if player_ref.direction == Vector2(0, 0):
		random_offset = Vector2(randf_range(view_radius, spawn_radius), 0).rotated(randf_range(0, 1) * TAU)
	else:
		random_offset = player_ref.direction * randf_range(1, 2) * view_radius

	var angle_variation = deg_to_rad(45)
	random_offset = random_offset.rotated(randf_range(-angle_variation, angle_variation))
	enemy.global_position = player_position + random_offset
	
	add_child(enemy)
	var rand_size = get_biased_random(1, 10, 2)
	var result = GameHandler.map_value(rand_size, 1, 10, 0.2, 2)
	var lvlData = GameHandler.main.current_level.data
	enemy.consumed_points = GameHandler.map_value(result, 0.2, 2, lvlData.last_required_points, lvlData.required_points * 0.9)
	enemy.z_index = rand_size
	enemy.scale_components(Vector2(result, result), 0.5, false)
	enemy._died.connect(self.on_registered_entity_died)
	if is_enabled:
		enemy.mouth_component.enable()
	else:
		enemy.mouth_component.disable()
	enemy_references.push_back(enemy)

func get_biased_random(low_range : float, high_range : float, exponent: float) -> int:
	var x = randf()
	x = pow(x, exponent)
	return low_range + int(floor(high_range * x))

func on_registered_entity_died(body):
	enemy_references.erase(body)

func reset_nav_targets():
	for e in enemy_references:
		e.force_reset_nav()

func enable_consumption():
	is_enabled = true
	for e in enemy_references:
		e.enable_mouth()

func disable_consumption():
	is_enabled = false
	for e in enemy_references:
		e.disable_mouth()
