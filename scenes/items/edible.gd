extends Node2D
class_name Edible

@export var value : int
@export var texture : Texture2D

func _ready():
	$Sprite2D.texture = texture


