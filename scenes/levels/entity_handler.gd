extends Node2D

var enemy_composition : Array[EnemyData]
var enemy_references = []

var player_ref : Player
var spawn_radius = 500
var despawn_radius = 1000
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
	var random_offset = Vector2(randf() * spawn_radius, randf() * spawn_radius).rotated(randf() * TAU)
	enemy.global_position = player_position + random_offset
	add_child(enemy)
	enemy_references.push_back(enemy)
