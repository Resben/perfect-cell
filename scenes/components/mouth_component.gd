extends Area2D
class_name MouthComponent

signal _on_consumption

var is_enabled : bool

func _on_area_entered(area):
	if is_enabled && area is ConsumableComponent:
		if area.get_parent() is Player:
			if get_parent() is Agent:
				if area.get_parent().scale_tacker.scale.x < get_parent().scale_tacker.scale.x:
					_on_consumption.emit(area.get_parent())
					area.consumed(get_parent())
		elif area.get_parent() is Agent:
			if get_parent() is Player:
				if area.get_parent().scale_tacker.scale.x < get_parent().scale_tacker.scale.x:
					_on_consumption.emit(area.get_parent())
					area.consumed(get_parent())

func disable():
	is_enabled = false

func enable():
	is_enabled = true
