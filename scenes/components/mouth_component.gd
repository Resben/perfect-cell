extends Area2D
class_name MouthComponent

signal _on_consumption

func _on_area_entered(area):
	if area is ConsumableComponent:
		if area.get_parent().size < get_parent().size:
			_on_consumption.emit(area.get_parent())
			area.consumed(get_parent())
