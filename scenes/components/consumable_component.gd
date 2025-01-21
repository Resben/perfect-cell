extends Area2D
class_name ConsumableComponent

signal _on_eaten

func consumed(body):
	_on_eaten.emit(body)
