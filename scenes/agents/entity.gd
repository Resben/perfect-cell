extends CharacterBody2D
class_name Entity

signal _died

@onready var health_component : HealthComponent = $HealthComponent
@onready var velocity_component : VelocityComponent = $VelocityComponent
@onready var hurtbox_component : HurtBoxComponent = $HurtBoxComponent
@onready var mouth_component : MouthComponent = $MouthComponent
@onready var consumable_component : ConsumableComponent = $ConsumableComponent

@onready var scale_tracker = $Sprite2D
var consumed_points : int = 0

func _ready():
	health_component._on_health_depletion.connect(self.on_death)
	mouth_component._on_consumption.connect(self.on_consume)
	consumable_component._on_eaten.connect(self.on_eaten)

func on_death():
	pass

func on_consume(body):
	if body is Entity:
		consumed_points += body.calculate_value()
	elif body is Edible:
		consumed_points += body.value
	calc_size(true)

func calc_size(should_tween : bool):
	var new_scale = calc_scale(GameHandler.main.current_level.data)
	if should_tween:
		var tween = get_tree().create_tween()
		scale_components(Vector2(new_scale, new_scale), 1, true, tween)
	else:
		scale_components(Vector2(new_scale, new_scale), 1, false)
	z_index = GameHandler.map_value(new_scale, 0.2, 2, 1, 10)

func calc_scale(lvlData : LevelData):
	var current_max_points = lvlData.required_points * 0.9
	return GameHandler.map_value(consumed_points, lvlData.last_required_points, current_max_points, 0.2, 2)

func scale_components(new_scale : Vector2, time : float, is_parallel : bool, tween : Tween = null):
	if tween != null:
		if is_parallel:
			tween.parallel().tween_property($Sprite2D, "scale", new_scale, time)
			tween.parallel().tween_property($HurtBoxComponent, "scale", new_scale, time)
			tween.parallel().tween_property($MouthComponent, "scale", new_scale, time)
			tween.parallel().tween_property($ConsumableComponent, "scale", new_scale, time)
		else:
			tween.tween_property($Sprite2D, "scale", new_scale, time)
			tween.tween_property($HurtBoxComponent, "scale", new_scale, time)
			tween.tween_property($MouthComponent, "scale", new_scale, time)
			tween.tween_property($ConsumableComponent, "scale", new_scale, time)
	else:
		$Sprite2D.scale = new_scale
		$HurtBoxComponent.scale = new_scale
		$MouthComponent.scale = new_scale
		$ConsumableComponent.scale = new_scale

func on_eaten(_body):
	pass

func die():
	_died.emit(self)
	queue_free()

func calculate_value():
	var lvlData = GameHandler.main.current_level.data
	var value = consumed_points - lvlData.last_required_points
	return max(1, value)

func disable_mouth():
	mouth_component.disable()

func enable_mouth():
	mouth_component.enable()
