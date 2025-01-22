extends Node2D

var enemy_composition : Array[EnemyData]
var enemy_references = []

var player_ref : Player
var view_radius = 500
var spawn_radius = 1000
var despawn_radius = 2000
var min_enemies = 5

func _ready():
	player_ref = get_tree().get_nodes_in_group("player")[0]

func setup(lvl : LevelData):
	enemy_composition = lvl.enemy_composition

func _process(delta):
	ensure_entities_around_player()

func ensure_entities_around_player():
	var player_position = player_ref.global_position
	var enemies_in_radius = 0

	# Check for existing entities within the radius
	for entity in enemy_references:
		var distance = player_position.distance_to(entity.global_position)
		if distance <= spawn_radius:
			enemies_in_radius += 1
		elif distance >= despawn_radius:
			enemy_references.erase(entity)
			entity.queue_free()
	
	# Spawn additional entities if below threshold
	var missing_entities = min_enemies - enemies_in_radius
	for i in range(missing_entities):
		spawn_enemy_near_player(player_position)

func spawn_enemy_near_player(player_position: Vector2):
	var enemy = enemy_composition[0].enemy.instantiate()
	var direction
	var random_offset
	
	# Spawn in all direcitons or in the direction the player is moving
	if player_ref.direction == Vector2(0, 0):
		random_offset = Vector2(randf_range(1, 2) * spawn_radius, randf_range(1, 2) * spawn_radius).rotated(randf_range(1, 2) * TAU)
	else:
		random_offset = player_ref.direction * randf_range(1, 2) * view_radius

	var angle_variation = deg_to_rad(45)
	random_offset = random_offset.rotated(randf_range(-angle_variation, angle_variation))
	enemy.global_position = player_position + random_offset
	
	add_child(enemy)
	var rand_size = randi_range(1, 10)
	var result = GameHandler.map_value(rand_size, 1, 10, 0.2, 2)
	var lvlData = GameHandler.main.current_level.data
	enemy.consumed_points = GameHandler.map_value(result, 0.2, 2, lvlData.last_required_points, lvlData.required_points * 0.9)
	enemy.z_index = rand_size
	enemy.scale = Vector2(result, result)
	enemy._died.connect(self.on_registered_entity_died)
	enemy_references.push_back(enemy)

func on_registered_entity_died(body):
	enemy_references.erase(body)
