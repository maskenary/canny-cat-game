extends Label

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		self.queue_free()
