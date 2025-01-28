extends Resource
class_name LevelData

@export var level_number : int

@export var required_points : int
@export var last_required_points : int

@export var measurement_type : String
@export var minimum_size : float
@export var maximum_size : float

@export var enemy_composition : Array[EnemyData]
@export var texture : Texture2D

@export var dialogue_to_play : DialogueResource
@export var music_to_play : AudioStream
