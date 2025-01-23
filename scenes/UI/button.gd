extends TextureButton

func _on_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.25, 1.25), 0.5)

func _on_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5)
