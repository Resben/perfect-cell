extends Area2D
class_name MouthComponent

signal _on_consumption

var is_enabled : bool

func _on_area_entered(area):
	if is_enabled && area is ConsumableComponent:
		if area.get_parent().consumed_points < get_parent().consumed_points:
			_on_consumption.emit(area.get_parent())
			area.consumed(get_parent())

func disable():
	is_enabled = false

func enable():
	is_enabled = true
