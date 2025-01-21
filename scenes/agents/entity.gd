extends CharacterBody2D
class_name Entity

signal _died

@onready var health_component : HealthComponent = $HealthComponent
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var hitbox_component : HitBoxComponent = $HitBoxComponent
@onready var mouth_component : MouthComponent = $MouthComponent
@onready var consumable_component : ConsumableComponent = $ConsumableComponent

var size : int = 1

func _ready():
	health_component._on_health_depletion.connect(self.on_death)
	mouth_component._on_consumption.connect(self.on_consume)
	consumable_component._on_eaten.connect(self.on_eaten)

func on_death():
	pass

func on_consume(body):
	pass

func on_eaten(body):
	pass

func die():
	_died.emit(self)
	queue_free()
